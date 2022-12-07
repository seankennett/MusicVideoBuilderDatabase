@description('Storage account name')
param storageAccountName string

@description('Secret name')
param secretName string

@description('Location for all resources.')
param location string

@description('Account type')
param storageAccountType string

@description('Access Tier')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string

@description('Key vault name')
param keyvaultName string

@description('Custom domain name')
param customDomain string = ''

@description('list of containers')
param containers array = []

@description('list of containers')
param queues array = []

var baseProperties = {
  accessTier: accessTier
  allowBlobPublicAccess: true
  publicNetworkAccess: 'Enabled'
}

var customDomainProperties = {
  supportsHttpsTrafficOnly: false
  // customDomain: {
  //   name: customDomain
  // } Clouflare not good when being proxied
}

var allProperties = customDomain == '' ? baseProperties : union(baseProperties, customDomainProperties)

var defaultServiceName = 'default'

// nothing for setting up static website - manual
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: allProperties
}

resource queueServices 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' existing = {
  name: defaultServiceName
  parent: storageAccount
}

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-05-01' = [for queueName in queues: {
  name: queueName
  parent: queueServices
}]

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' existing = {
  name: defaultServiceName
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = [for container in containers: {
  name: container.Name
  parent: blobServices
  properties: {
    publicAccess: container.publicAccess
  }
}]

resource storageAccountProperties 'Microsoft.Storage/storageAccounts/blobServices@2018-07-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    cors: {
      corsRules: [
        {
          allowedMethods: [
            'GET'
            'HEAD'
            'OPTIONS'
            'PUT'
          ]
          allowedOrigins: [
            '*'
          ]
          allowedHeaders: [
            '*'
          ]
          exposedHeaders: [
            '*'
          ]
          maxAgeInSeconds: 0
        }
      ]
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

var connectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: secretName
  parent: keyvault
  properties: {
    value: connectionString
  }
}

output id string = storageAccount.id
