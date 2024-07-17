[![Release][release-image]][release] [![CI][ci-image]][ci] [![License][license-image]][license] [![Registry][registry-image]][registry]

# terraform-google-service-ce

A Terraform module which forms the base of all `ce` deployments for Snowplow OS services where we deploy a group of nodes running one or more services.  This module serves to reduce the boilerplate code that we incur otherwise to simplify maintenance across all of our OS modules.

The default `startup-script.sh` that is pre-pended to all servers launched contains a few helpful bash functions:

1. `get_instance_id`: Will return the `instance/id` of the server which we use primarily for Telemetry capture
2. `get_application_memory_mb`: Will return the amount of memory that can be assigned to a service running on the box.  It factors in a minimum allocation for the operating system and then returns a percentage of the available memory to assign.
  - Default is 80% of the available memory to the service and 384mb for the Operating System left available
  - Both settings can be overriden with positional arguments (e.g. `get_application_memory_mb 60 500` would allocate 60% to the service and 500mb to the OS)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_health_check.hc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_instance_template.tpl](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template) | resource |
| [google_compute_region_instance_group_manager.grp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager) | resource |
| [google_compute_image.ubuntu_20_04](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to assign a public ip address to this instance; if false this instance must be behind a Cloud NAT to connect to the internet | `bool` | `true` | no |
| <a name="input_check_interval_sec"></a> [check\_interval\_sec](#input\_check\_interval\_sec) | How often (in seconds) to send a health check | `number` | `5` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The path to bind for health checks | `string` | `""` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | A so-far unhealthy instance will be marked healthy after this many consecutive successes | `number` | `2` | no |
| <a name="input_ingress_port"></a> [ingress\_port](#input\_ingress\_port) | The port that the service will be bound to and exposed over HTTP | `number` | `-1` | no |
| <a name="input_instance_group_version_name"></a> [instance\_group\_version\_name](#input\_instance\_group\_version\_name) | A name to give to the instance group version control (e.g. app\_name + app\_version) | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to append to this resource | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type to use | `string` | `"e2-small"` | no |
| <a name="input_name"></a> [name](#input\_name) | A name which will be pre-pended to the resources created | `string` | n/a | yes |
| <a name="input_named_port_http"></a> [named\_port\_http](#input\_named\_port\_http) | The name to give to the bound port on the instance group | `string` | `""` | no |
| <a name="input_network"></a> [network](#input\_network) | The name of the network to deploy within | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The name of the region to deploy within | `string` | n/a | yes |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | The name of the service account email address to bind to the deployment | `string` | n/a | yes |
| <a name="input_ssh_block_project_keys"></a> [ssh\_block\_project\_keys](#input\_ssh\_block\_project\_keys) | Whether to block project wide SSH keys | `bool` | `true` | no |
| <a name="input_ssh_key_pairs"></a> [ssh\_key\_pairs](#input\_ssh\_key\_pairs) | The list of SSH key-pairs to add to the servers | <pre>list(object({<br>    user_name  = string<br>    public_key = string<br>  }))</pre> | `[]` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The name of the sub-network to deploy within; if populated will override the 'network' setting | `string` | `""` | no |
| <a name="input_target_size"></a> [target\_size](#input\_target\_size) | The number of servers to deploy | `number` | `1` | no |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | How long (in seconds) to wait before claiming failure | `number` | `5` | no |
| <a name="input_ubuntu_20_04_source_image"></a> [ubuntu\_20\_04\_source\_image](#input\_ubuntu\_20\_04\_source\_image) | The source image to use which must be based of of Ubuntu 20.04; by default the latest community version is used | `string` | `""` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | A so-far healthy instance will be marked unhealthy after this many consecutive failures | `number` | `10` | no |
| <a name="input_user_supplied_script"></a> [user\_supplied\_script](#input\_user\_supplied\_script) | The user-data script extension to execute | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_health_check_id"></a> [health\_check\_id](#output\_health\_check\_id) | Identifier for the health check on the instance group |
| <a name="output_health_check_self_link"></a> [health\_check\_self\_link](#output\_health\_check\_self\_link) | The URL for the health check on the instance group |
| <a name="output_instance_group_url"></a> [instance\_group\_url](#output\_instance\_group\_url) | The full URL of the instance group created by the manager |
| <a name="output_manager_id"></a> [manager\_id](#output\_manager\_id) | Identifier for the instance group manager |
| <a name="output_manager_self_link"></a> [manager\_self\_link](#output\_manager\_self\_link) | The URL for the instance group manager |
| <a name="output_named_port_http"></a> [named\_port\_http](#output\_named\_port\_http) | The name of the port exposed by the instance group |
| <a name="output_named_port_value"></a> [named\_port\_value](#output\_named\_port\_value) | The named port value (e.g. 8080) |

# Copyright and license

The Google Service CE project is Copyright 2023-present Snowplow Analytics Ltd.

Licensed under the [Snowplow Community License](https://docs.snowplow.io/community-license-1.0). _(If you are uncertain how it applies to your use case, check our answers to [frequently asked questions](https://docs.snowplow.io/docs/contributing/community-license-faq/).)_

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[release]: https://github.com/snowplow-devops/terraform-google-service-ce/releases/latest
[release-image]: https://img.shields.io/github/v/release/snowplow-devops/terraform-google-service-ce

[ci]: https://github.com/snowplow-devops/terraform-google-service-ce/actions?query=workflow%3Aci
[ci-image]: https://github.com/snowplow-devops/terraform-google-service-ce/workflows/ci/badge.svg

[license]: https://docs.snowplow.io/docs/contributing/community-license-faq/
[license-image]: https://img.shields.io/badge/license-Snowplow--Community-blue.svg?style=flat

[registry]: https://registry.terraform.io/modules/snowplow-devops/service-ce/google/latest
[registry-image]: https://img.shields.io/static/v1?label=Terraform&message=Registry&color=7B42BC&logo=terraform
