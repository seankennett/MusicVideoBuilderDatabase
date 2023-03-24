@description('User Identity Name')
param userIdentityName string

@description('Location for all resources.')
param location string

@description('Name that will be used to build associated artifacts')
param keyvaultName string

resource userIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userIdentityName
  location: location
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'ManagedIdentityClientId'
  parent: keyvault
  properties: {
    value: userIdentity.properties.clientId
  }
}

resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: 'add'
  parent: keyvault
  properties: {
    accessPolicies: [
      {
        tenantId: userIdentity.properties.tenantId
        objectId: userIdentity.properties.principalId
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

output id string = userIdentity.id
