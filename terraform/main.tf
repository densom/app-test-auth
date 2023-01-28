terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
    backend "azurerm" {
        resource_group_name  = "rg-tfstate"
        storage_account_name = "tfstate499389720"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "rg-apptestauth"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "ASP-sandbox-b337"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  kind = "linux"
  reserved = true

  sku {
    tier = "Basic"
    size = "B1"
  }

  tags = {}
}

resource "azurerm_app_service" "appservice" {
  name                = "apptestauth"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
  https_only = true
  site_config {
    linux_fx_version = "NODE|18-lts"
    app_command_line = "npm start"
    default_documents = [ "Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php", "hostingstart.html" ]
    use_32_bit_worker_process = true
  }

  # app_settings = {
  #   "SOME_KEY" = "some-value"
  # }

  tags = {}
}
