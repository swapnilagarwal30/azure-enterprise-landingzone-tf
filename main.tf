# 1. Management Groups Hierarchy (Microsoft CAF Foundation)
module "management_groups" {
  source    = "./modules/management-groups"
  root_id   = var.root_id
  root_name = var.root_name
}

# 2. Centralized Monitoring & FinOps Log Analytics
module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = "rg-${var.environment}-${var.primary_location}-monitoring"
  location            = var.primary_location
  environment         = var.environment
  log_retention_days  = var.log_retention_days
  tags                = var.tags
}

# 3. Central Hub Virtual Network & Bastion
module "hub_network" {
  source              = "./modules/hub-network"
  resource_group_name = "rg-${var.environment}-${var.primary_location}-hub"
  location            = var.primary_location
  environment         = var.environment
  address_space       = var.hub_vnet_address_space
  enable_bastion      = var.enable_bastion
  tags                = var.tags
}

# 4. Central Azure Firewall Premium & Threat Intelligence
module "firewall" {
  source                     = "./modules/firewall"
  resource_group_name        = module.hub_network.resource_group_name
  location                   = var.primary_location
  environment                = var.environment
  sku_tier                   = var.firewall_sku_tier
  firewall_subnet_id         = module.hub_network.firewall_subnet_id
  log_analytics_workspace_id = module.monitoring.workspace_id
  tags                       = var.tags
}

# 5. Spoke 1: Application Workload VNet (Connected via Peering + UDR)
module "spoke_workload" {
  source                  = "./modules/spoke-network"
  resource_group_name     = "rg-${var.environment}-${var.primary_location}-spoke-app"
  location                = var.primary_location
  environment             = var.environment
  spoke_name              = "workload"
  address_space           = var.spoke_workload_address_space
  hub_vnet_id             = module.hub_network.vnet_id
  hub_vnet_name           = module.hub_network.vnet_name
  hub_resource_group_name = module.hub_network.resource_group_name
  firewall_private_ip     = module.firewall.firewall_private_ip
  tags                    = var.tags
}

# 6. Spoke 2: Shared DevOps & Runners VNet (Connected via Peering + UDR)
module "spoke_shared" {
  source                  = "./modules/spoke-network"
  resource_group_name     = "rg-${var.environment}-${var.primary_location}-spoke-shared"
  location                = var.primary_location
  environment             = var.environment
  spoke_name              = "shared"
  address_space           = var.spoke_shared_address_space
  hub_vnet_id             = module.hub_network.vnet_id
  hub_vnet_name           = module.hub_network.vnet_name
  hub_resource_group_name = module.hub_network.resource_group_name
  firewall_private_ip     = module.firewall.firewall_private_ip
  tags                    = var.tags
}

# 7. Private DNS Zones & Private Link Resolution
module "private_dns" {
  source              = "./modules/private-dns-endpoints"
  resource_group_name = module.hub_network.resource_group_name
  hub_vnet_id         = module.hub_network.vnet_id
  spoke_vnet_id       = module.spoke_workload.vnet_id
  tags                = var.tags
}

# 8. Azure Policy Governance (Assigned to Landing Zones Management Group)
module "governance_policy" {
  source              = "./modules/governance-policy"
  management_group_id = module.management_groups.landing_zones_id
  allowed_locations   = [var.primary_location, var.secondary_location]
}
