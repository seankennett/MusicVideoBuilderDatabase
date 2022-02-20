@description('Name that will be used to build associated artifacts')
param resourceName string

@description('Location for all resources.')
param location string

@description('App insights connection string')
param appInsightsConnectionString string

@description('Storage account to allow CORS to')
param storageAccountName string

@description('Storage account secret name')
param storageSecretName string

var functionAppServicePlanName = '${resourceName}function'
var functionAppName = '${resourceName}function'
var keyvaultName = resourceName

resource functionPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: functionAppServicePlanName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {}
}

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
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
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
          name:'AzureWebJobsStorage'
          value:'@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${storageSecretName})'
        }
      ]
      cors: {
        allowedOrigins: [
          '${storageAccountName}.z16.web.${environment().suffixes.storage}'
        ]
      }
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