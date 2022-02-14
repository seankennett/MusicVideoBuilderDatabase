@description('Storage account name')
param storageAccountName string

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

// nothing for setting up static website - manual
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: true
    publicNetworkAccess:'Enabled'
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: '${storageAccountName}ConnectionString'
  parent: keyvault
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
  }
}
