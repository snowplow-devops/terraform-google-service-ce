locals {
  startup_script = templatefile("${path.module}/templates/startup-script.sh.tmpl", {
    user_supplied_script = var.user_supplied_script
  })
}

data "google_compute_image" "ubuntu_20_04" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance_template" "tpl" {
  name_prefix = "${var.name}-"
  description = "This template is used to create ${var.name} instances"

  instance_description = var.name
  machine_type         = var.machine_type

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.ubuntu_20_04_source_image == "" ? data.google_compute_image.ubuntu_20_04.self_link : var.ubuntu_20_04_source_image
    auto_delete  = true
    boot         = true
    disk_type    = "pd-standard"
    disk_size_gb = 10
  }

  # Note: Only one of either network or subnetwork can be supplied
  #       https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template#network_interface
  network_interface {
    network    = var.subnetwork == "" ? var.network : ""
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.associate_public_ip_address ? [1] : []

      content {
        network_tier = "PREMIUM"
      }
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = local.startup_script

  metadata = {
    block-project-ssh-keys = var.ssh_block_project_keys

    ssh-keys = join("\n", [for key in var.ssh_key_pairs : "${key.user_name}:${key.public_key}"])
  }

  tags = [var.name]

  labels = var.labels

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "hc" {
  count = var.health_check_path != "" ? 1 : 0

  name = var.name

  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    request_path = var.health_check_path
    port         = var.ingress_port
  }
}

resource "google_compute_region_instance_group_manager" "grp" {
  name = "${var.name}-grp"

  base_instance_name = var.name
  region             = var.region

  target_size = var.target_size

  dynamic "named_port" {
    for_each = var.named_port_http != "" ? [1] : []

    content {
      name = var.named_port_http
      port = var.ingress_port
    }
  }

  version {
    name              = var.instance_group_version_name
    instance_template = google_compute_instance_template.tpl.self_link
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_unavailable_fixed = 3
  }

  dynamic "auto_healing_policies" {
    for_each = var.health_check_path != "" ? [1] : []

    content {
      health_check      = join("", google_compute_health_check.hc.*.self_link)
      initial_delay_sec = 300
    }
  }

  wait_for_instances = true

  timeouts {
    create = "20m"
    update = "20m"
    delete = "30m"
  }
}
