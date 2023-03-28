@description('Specifies sql admin login')
@secure()
param sqlAdministratorLogin string

@description('Specifies sql admin password')
@secure()
param sqlAdministratorPassword string

@description('Specifies sql application login password')
@secure()
param sqlLoginMusicVideoBuilderApplicationPassword string

@description('Database sku')
param databaseSku string

@description('Database Tier')
param databaseTier string

@description('Database DTU capacity')
param databaseCapacity int

@description('Database storage size in bytes')
param databaseMaxSizeBytes int

@description('Location for all resources.')
param location string

@description('Name that will be used to build associated artifacts')
param resourceName string

@description('User Identity Name')
param userIdentityId string

var sqlServerName = resourceName
var databaseName = resourceName
var keyvaultName = resourceName

resource sqlserver 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userIdentityId}': {}
    }
  }
  properties: {
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: 'musicvideobuilder-Music Video Builder-285ec89b-c6b0-46a6-9758-a0bce37bd2da'
      principalType: 'Application'
      sid: 'bfdbfe2a-f373-413f-b316-009b3a274fca'
      tenantId: tenant().tenantId
    }
    primaryUserAssignedIdentityId: userIdentityId
    version: '12.0'
  }

  resource database 'databases@2020-08-01-preview' = {
    name: databaseName
    location: location
    sku: {
      name: databaseSku
      tier: databaseTier
      capacity: databaseCapacity
    }
    properties: {
      collation: 'SQL_Latin1_General_CP1_CI_AS'
      maxSizeBytes: databaseMaxSizeBytes
    }
  }

  resource firewallRule 'firewallRules@2020-11-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'SqlConnectionString'
  parent: keyvault
  properties: {
    value: 'Data Source=tcp:${sqlserver.properties.fullyQualifiedDomainName},1433;Initial Catalog=${sqlserver::database.name};User Id=MusicVideoBuilderApplication@${sqlserver.properties.fullyQualifiedDomainName};Password=${sqlLoginMusicVideoBuilderApplicationPassword}'
  }
}
