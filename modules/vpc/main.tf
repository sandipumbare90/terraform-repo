/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
	VPC configuration
 *****************************************/
resource "google_compute_network" "network" {
  name                                      = var.network_name
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  project                                   = var.project_id
  description                               = var.description
  delete_default_routes_on_create           = var.delete_default_internet_gateway_routes
  mtu                                       = var.mtu
  enable_ula_internal_ipv6                  = var.enable_ipv6_ula
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
}

/******************************************
	Shared VPC
 *****************************************/
resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  provider = google-beta

  count      = var.shared_vpc_host ? 1 : 0
  project    = var.project_id
  depends_on = [google_compute_network.network]
}

/********************************************************
         Subnet Configuration                            
**********************************************************/

locals {
  subnets = {
    for x in var.subnets :
    "${x.subnet_region}/${x.subnet_name}" => x
  }
}


/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {

  for_each                   = local.subnets
  name                       = each.value.subnet_name
  ip_cidr_range              = each.value.subnet_ip
  region                     = each.value.subnet_region
  private_ip_google_access   = lookup(each.value, "subnet_private_access", "false")
  private_ipv6_google_access = lookup(each.value, "subnet_private_ipv6_access", null)
  dynamic "log_config" {
    for_each = coalesce(lookup(each.value, "subnet_flow_logs", null), false) ? [{
      aggregation_interval = each.value.subnet_flow_logs_interval
      flow_sampling        = each.value.subnet_flow_logs_sampling
      metadata             = each.value.subnet_flow_logs_metadata
      filter_expr          = each.value.subnet_flow_logs_filter
      metadata_fields      = each.value.subnet_flow_logs_metadata_fields
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
      filter_expr          = log_config.value.filter_expr
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? log_config.value.metadata_fields : null
    }
  }
  network     = var.network_name
  project     = var.project_id
  description = lookup(each.value, "description", null)
  dynamic "secondary_ip_range" {
    for_each = contains(keys(var.secondary_ranges), each.value.subnet_name) == true ? var.secondary_ranges[each.value.subnet_name] : []

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  purpose          = lookup(each.value, "purpose", null)
  role             = lookup(each.value, "role", null)
  stack_type       = lookup(each.value, "stack_type", null)
  ipv6_access_type = lookup(each.value, "ipv6_access_type", null)
}

/******************************************************
    Firewall Configuration                               
******************************************************/
locals {
  ingress_rules = { for rule in var.ingress_rules : rule.name => merge(rule, { direction = "INGRESS" }) }
  egress_rules  = { for rule in var.egress_rules : rule.name => merge(rule, { direction = "EGRESS" }) }
  rules_all     = merge(local.ingress_rules, local.egress_rules)
}

resource "google_compute_firewall" "rules" {
  for_each                = length(var.rules) > 0 ? { for r in var.rules : r.name => r } : {}
  name                    = each.value.name
  description             = each.value.description
  direction               = each.value.direction
  disabled                = each.value.disabled
  network                 = var.network_name
  project                 = var.project_id
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts
  priority                = each.value.priority

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config") == null ? [] : [each.value.log_config]
    content {
      metadata = log_config.value.metadata
    }
  }

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])
    content {
      protocol = deny.value.protocol
      ports    = lookup(deny.value, "ports", null)
    }
  }
}

resource "google_compute_firewall" "rules_ingress_egress" {
  for_each                = length(var.rules) > 0 ? {} : local.rules_all
  name                    = each.value.name
  description             = each.value.description
  direction               = each.value.direction
  disabled                = each.value.disabled
  network                 = var.network_name
  project                 = var.project_id
  source_ranges           = lookup(each.value, "source_ranges", null)
  destination_ranges      = lookup(each.value, "destination_ranges", null)
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts
  priority                = each.value.priority

  dynamic "log_config" {
    for_each = lookup(each.value, "log_config") == null ? [] : [each.value.log_config]
    content {
      metadata = log_config.value.metadata
    }
  }

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])
    content {
      protocol = deny.value.protocol
      ports    = lookup(deny.value, "ports", null)
    }
  }
}
