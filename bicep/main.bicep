param location string = resourceGroup().location
param appName string

var randomSuffix = substring(uniqueString(resourceGroup().name),0,4)

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'ASP-${appName}-${randomSuffix}'
  location: location
  kind: 'Linux'
  
  
  sku: {
    name: 'B1'
    tier: 'Basic'
    capacity: 1
  }

  properties: {
    reserved: true
  }

  tags: {}
}



