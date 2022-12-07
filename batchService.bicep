@description('Resource name')
param resourceName string

@description('Location for all resources.')
param location string

@description('Storage account id')
param storageAccountId string

resource batchService 'Microsoft.Batch/batchAccounts@2022-10-01' = {
  name: resourceName
  location: location
  properties: {
    autoStorage: {
      storageAccountId: storageAccountId
      authenticationMode: 'StorageKeys'
    }
    poolAllocationMode: 'BatchService'
    publicNetworkAccess: 'Enabled'
  }
}
