@description('Name that will be used to build associated artifacts')
param keyvaultName string

@description('Location for all resources.')
param location string

@description('App insights connection string')
param appInsightsConnectionString string

@description('Storage account connection string')
@secure()
param storageConnectionString string

@description('Trigger connection string')
@secure()
param triggerConnectionString string = ''

@description('Run from package')
param runFromPackage bool = true

@description('Function App name')
param functionAppName string

@description('AdditionalAppSettings')
param additionalAppSettings array = []

var functionAppServicePlanName = functionAppName

resource functionPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: functionAppServicePlanName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {}
}

var baseAppsettings = union([
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'dotnet'
    }
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }    
    {
      name: 'WEBSITE_ENABLE_SYNC_UPDATE_SITE'
      value: 'true'
    }
    {
      name: 'AzureKeyVaultEndpoint'
      value: 'https://${keyvaultName}${environment().suffixes.keyvaultDns}/'
    }
    {
      name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
      value: appInsightsConnectionString
    }
    {
      name: 'AzureWebJobsStorage'
      value: storageConnectionString
    }
    {
      name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
      value: storageConnectionString
    }
    {
      name: 'WEBSITE_CONTENTSHARE'
      value: toLower(functionAppName)
    }
  ], additionalAppSettings)

var runFromPackageSetting = [
  {
    name: 'WEBSITE_RUN_FROM_PACKAGE'
    value: '1'
  }
]

var triggerConnectionSetting = [ {
    name: 'ConnectionString'
    value: triggerConnectionString
  } ]

var triggerAndBaseSettings = triggerConnectionString == '' ? baseAppsettings : union(baseAppsettings, triggerConnectionSetting)
var allAppSettings = runFromPackage ? union(triggerAndBaseSettings, runFromPackageSetting) : triggerAndBaseSettings

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: functionPlan.id
    siteConfig: {
      appSettings: allAppSettings
    }
    httpsOnly: true
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: 'add'
  parent: keyvault
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: functionApp.identity.principalId
        permissions: {
          secrets: [
            'list'
            'get'
          ]
        }
      }
    ]
  }
}

output id string = functionApp.id
