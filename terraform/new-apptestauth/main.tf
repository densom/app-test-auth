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

module "app" {
    source = "../sandbox-apptestauth"
    environment = "dev"
    appname = "tftest"
}

module "app2" {
    source = "../sandbox-apptestauth"
    environment = "dev"
    appname = "tftest2"
}