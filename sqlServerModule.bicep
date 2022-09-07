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

@description('Location for all resources.')
param location string

@description('Name that will be used to build associated artifacts')
param resourceName string

var sqlServerName = resourceName
var databaseName = resourceName
var keyvaultName = resourceName

resource sqlserver 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorPassword
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
      maxSizeBytes: 268435456000
    }
  }

  resource firewallRule 'firewallRules@2020-11-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }

  resource firewallRuleLocal 'firewallRules@2020-11-01-preview' = {
    name: 'LocalIp'
    properties: {
      endIpAddress: '143.159.226.43'
      startIpAddress: '143.159.226.43'
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
