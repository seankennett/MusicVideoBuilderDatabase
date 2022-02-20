@description('Which Pricing tier our App Service Plan to')
param webAppSkuName string = 'F1'

@description('How many instances of our app service will be scaled out to')
param webAppSkuCapacity int = 1

@description('Database sku')
param databaseSku string = 'Standard'

@description('Database Tier')
param databaseTier string = 'Standard'

@description('Database DTU capacity')
param databaseCapacity int = 10

@description('Location for all resources.')
param location string = 'North Europe'

@description('Name that will be used to build associated artifacts')
param resourceName string = 'musicvideobuilder'

@description('Storage Account type')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

var keyvaultName = resourceName
var appServicePlanName = resourceName
var webSiteName = resourceName
var storageAccountNamePublic = '${resourceName}public'
var storageAccountNamePrivate = '${resourceName}private'
var publicStorageSecretName = 'PublicStorageConnectionString'

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: webAppSkuName
    capacity: webAppSkuCapacity
  }
  tags: {
    displayName: 'HostingPlan'
    ProjectName: resourceName
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'Website'
    ProjectName: resourceName
  }
  dependsOn: [
    appInsights
  ]
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

resource appServiceLogging 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'appsettings'
  properties: {
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.outputs.appInsightsConnectionString
  }
  dependsOn: [
    appServiceAppSettings
  ]
}

resource appServiceAppSettings 'Microsoft.Web/sites/siteextensions@2020-06-01' = {
  parent: appService
  name: 'Microsoft.ApplicationInsights.AzureWebSites'
  dependsOn: [
    appInsights
  ]
}

resource appServiceSiteExtension 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'logs'
  properties: {
    applicationLogs: {
      fileSystem: {
        level: 'Warning'
      }
    }
    httpLogs: {
      fileSystem: {
        retentionInMb: 40
        enabled: true
      }
    }
    failedRequestsTracing: {
      enabled: true
    }
    detailedErrorMessages: {
      enabled: true
    }
  }
}

module appInsights 'appInsights.bicep' = {
  name: 'deployAppInsights'
  params: {
    location: location
    resourceName: resourceName
  }
}

module imageUploaderFunction 'function.bicep' = {
  name: 'deployImageUploaderFunction'
  params: {
    location: location
    resourceName: resourceName
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    storageAccountName: storageAccountNamePublic
    storageSecretName: publicStorageSecretName
  }
  dependsOn:[
    storagePublic
  ]
}

module sql 'sqlServerModule.bicep' = {
  name: 'deploySQL'
  params: {
    sqlAdministratorLogin: keyvault.getSecret('SqlAdministratorLogin')
    sqlAdministratorPassword: keyvault.getSecret('SqlAdministratorPassword')
    sqlLoginMusicVideoBuilderApplicationPassword: keyvault.getSecret('SqlLoginMusicVideoBuilderApplicationPassword')
    databaseCapacity: databaseCapacity
    databaseSku: databaseSku
    databaseTier: databaseTier
    location: location
    resourceName: resourceName
  }
}

module storagePublic 'storageAccount.bicep' = {
  name: 'deployStoragePublic'
  params: {
    accessTier: 'Hot'
    location: location
    storageAccountName: storageAccountNamePublic
    storageAccountType: storageAccountType
    secretName: publicStorageSecretName
    keyvaultName: keyvaultName
  }
}

module storagePrivate 'storageAccount.bicep' = {
  name: 'deployStoragePrivate'
  params: {
    accessTier: 'Cool'
    location: location
    storageAccountName: storageAccountNamePrivate
    storageAccountType: storageAccountType
    secretName: 'PrivateStorageConnectionString'
    keyvaultName: keyvaultName
  }
}
