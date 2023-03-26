@description('Storage account name')
param storageAccountName string

@description('Secret name')
param secretName string = ''

@description('Location for all resources.')
param location string

@description('Account type')
param storageAccountType string

@description('Key vault name')
param keyvaultName string = ''

@description('Custom domain name')
param supportHttpsOnly bool = true

@description('list of containers')
param containers array = []

@description('list of containers')
param queues array = []

@description('enable cors')
param enableCors bool = false

@description('enable lifecyle for deleting user assets')
param enableUserDeleteLifeCycle bool = false

var defaultServiceName = 'default'

// nothing for setting up static website - manual
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: supportHttpsOnly
  }
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

resource storageAccountProperties 'Microsoft.Storage/storageAccounts/blobServices@2018-07-01' = if (enableCors) {
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

resource deleteUserManagementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2022-05-01' = if (enableUserDeleteLifeCycle) {
  name: 'default'
  parent: storageAccount
  properties: {
    policy: {
      rules: [
        {
          enabled: true
          name: 'deleteUserAssetRule'
          type: 'Lifecycle'
          definition: {
            actions: {
              baseBlob: {
                delete: {
                  daysAfterCreationGreaterThan: 7
                }
              }
            }
            filters: {
              blobTypes: [
                'blockBlob'
              ]
              prefixMatch: [
                'user-'
              ]
            }
          }
        }
      ]
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = if (keyvaultName != '' && secretName != '') {
  name: keyvaultName
  scope: resourceGroup()
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = if (keyvaultName != '' && secretName != '') {
  name: '${keyvault}/${secretName}'
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
  }
  dependsOn:[
    keyvault
  ]
}

output id string = storageAccount.id
