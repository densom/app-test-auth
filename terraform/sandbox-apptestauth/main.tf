terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
    # backend "azurerm" {
    #     resource_group_name  = "rg-tfstate"
    #     storage_account_name = "tfstate499389720"
    #     container_name       = "tfstate"
    #     key                  = "terraform.tfstate"
    # }

}

provider "azurerm" {
  features {}
}

resource "random_string" "random4" {
  length = 4
  special = false
}

resource "azurerm_resource_group" "rg" {
  name = "rg-${var.appname}"
  location = "East US"
}

resource "azurerm_app_service_plan" "apptestauth" {
  name                = "ASP-${var.appname}-${random_string.random4.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = "linux"
  reserved = true

  sku {
    tier = "Basic"
    size = "B1"
  }

  tags = {}
}

resource "azurerm_app_service" "appservice" {
  name                = "${var.appname}-${random_string.random4.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.apptestauth.id
  https_only = true

  site_config {
    linux_fx_version = "NODE|18-lts"
    app_command_line = "npm start"
    default_documents = [ "Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "iisstart.htm", "default.aspx", "index.php", "hostingstart.html" ]
    use_32_bit_worker_process = true
  }

  logs {

  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.apptestauth.instrumentation_key}",
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.apptestauth.connection_string,
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3",
    XDT_MicrosoftApplicationInsights_Mode = "default",
    # MICROSOFT_PROVIDER_AUTHENTICATION_SECRET = "",
    PORT = "80"
  }

  # auth_settings {
  #   enabled = true
  # }

  # application_logs {}


  tags = {}
}

resource "azurerm_application_insights" "apptestauth" {
  name                = "app-insights-${var.appname}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  sampling_percentage = 0
  
  tags = {}

}

# resource "azurerm_app_service_custom_hostname_binding" "apptestauth" {
#   hostname            = "apptestauth.dennissomerville.net"
#   app_service_name    = azurerm_app_service.appservice.name
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

