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

var baseProperties = {
  accessTier: accessTier
  allowBlobPublicAccess: true
  publicNetworkAccess: 'Enabled'
}

var customDomainProperties = {
  supportsHttpsTrafficOnly: false
  customDomain: {
    name: customDomain
  }
}

var allProperties = customDomain == '' ? baseProperties : union(baseProperties, customDomainProperties)

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
