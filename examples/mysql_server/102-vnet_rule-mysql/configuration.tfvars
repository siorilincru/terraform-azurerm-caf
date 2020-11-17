resource_groups = {
  mysql_region1 = {
    name   = "mysql-re1"
    region = "region1"
    tags = {
      rgtag = "example"
    }
  }
  security_region1 = {
    name = "mysql-security-re1"
  }
}

mysql_servers = {
  sales-re1 = {
    name                          = "sales-re1"
    region                        = "region1"
    resource_group_key            = "mysql_region1"
    version                       = "5.7"
    sku_name                      = "GP_Gen5_2"
    storage_mb                    = 5120
    administrator_login           = "mysqlsalesadmin"
    administrator_login_password  = "Testpass@1"
    keyvault_key                  = "mysql-re1"
    system_msi                    = true
    public_network_access_enabled = true
    vnet_key           = "vnet_region1"
    subnet_key         = "mysql_subnet"
    
    mysql_firewall_rules = {
      mysql-firewall-rules = {
        name = "mysql_server_firewallrule"
        resource_group_name = "mysql_region1"
        server_name         = "sales-rg1"
        start_ip_address    = "52.163.80.201"
        end_ip_address      = "52.163.80.201"
      }
    }

    mysql_configuration = {
      mysql_configuration = {
        name                = "interactive_timeout"
        resource_group_name = "mysql_region1"
        server_name         = "sales-re1"
        value               = "600"
      }
    }
    
    mysql_vnet_rules = {
      mysql_vnet_rules = {
        name                = "mysql-vnet-rule"
      }
    }

    mysql_ad_admin = {
      mysql_ad_admin = {
        login               = "abhilash"
        object_id           = "28baece4-1803-4e9f-89e3-1ca0fe820b96"
        tenant_id           = "0873a9b0-a78c-47e6-b937-5a1c3053f4a7"
        
      }
    }

    mysql_database = {
      mysql_database = {
        name                = "mysql_server_sampledb"
        resource_group_name = "mysql_region1"
        server_name         = "sales-re1"
        charset             = "UTF8"
        collation           = "utf8_unicode_ci"
      }
    }
    
    auto_grow_enabled = true
    
    tags = {
      segment = "sales"
    }

    # Optional
    threat_detection_policy = {
      enabled = true
      disabled_alerts = [
        # "Sql_Injection",
        # "Sql_Injection_Vulnerability",
        # "Access_Anomaly",
        # "Data_Exfiltration",
        # "Unsafe_Action"
      ]
      email_account_admins = false
      email_addresses           = []
      retention_days            = 15
      storage_account_key = "security-re1"
    }

  }

}

## Networking configuration
vnets = {
  vnet_region1 = {
    resource_group_key = "mysql_region1"
        
    vnet = {
      name          = "mysql-vnet"
      address_space = ["10.150.100.0/24"]
      
    }
    #specialsubnets = {}
    subnets = {
      mysql_subnet = {
        name    = "mysql_subnet"
        cidr    = ["10.150.100.0/25"]
        service_endpoints   = ["Microsoft.Sql"]
      }
    }
    
  }
}



# vnets = {
#   vnet_region1 = {
#     resource_group_key = "agw_region1"
#     vnet = {
#       name          = "app_gateway_vnet"
#       address_space = ["10.100.100.0/24"]
#     }
#     specialsubnets = {}
#     subnets = {
#       app-gateway-subnet = {
#         name    = "app_gateway_subnet"
#         cidr    = ["10.100.100.0/25"]
#         nsg_key = "application_gateway"
#       }
#     }

#   }
# }

storage_accounts = {
  security-re1 = {
    name                     = "securityre1"
    resource_group_key       = "security_region1"
    region                   = "region1"
    account_kind             = "BlobStorage"
    account_tier             = "Standard"
    account_replication_type = "RAGRS"
  }
}

keyvaults = {
  mysql-re1 = {
    name               = "mysqlre1"
    resource_group_key = "security_region1"
    sku_name           = "standard"
  }
}

keyvault_access_policies = {
  # A maximum of 16 access policies per keyvault
  mysql-re1 = {
    logged_in_user = {
      secret_permissions = ["Set", "Get", "List", "Delete", "Purge"]
    }
    logged_in_aad_app = {
      secret_permissions = ["Set", "Get", "List", "Delete", "Purge"]
    }
  }
}


azuread_groups = {
  sales_admins = {
    name        = "sql-sales-admins"
    description = "Administrators of the sales MySQL server."
    members = {
      user_principal_names = []
      object_ids = [
      ]
      group_keys             = []
      service_principal_keys = []
    }
    owners = {
      user_principal_names = [
      ]
      service_principal_keys = []
      object_ids             = []
    }
    prevent_duplicate_name = false
  }
}