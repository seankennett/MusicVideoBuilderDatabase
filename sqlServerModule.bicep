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

@description('Sql Server Name')
param sqlServerName string

@description('Database Name')
param databaseName string

@description('User Identity Name')
param userIdentityId string

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
      autoPauseDelay: 60
      minCapacity: json('0.5')
      collation: 'SQL_Latin1_General_CP1_CI_AS'
      maxSizeBytes: databaseMaxSizeBytes
      zoneRedundant: false
      storageAccountType: 'LRS'
      useFreeLimit: true
      freeLimitExhaustionBehavior: 'AutoPause'
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
