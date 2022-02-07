@description('Specifies sql admin login')
param sqlAdministratorLogin string

@description('Specifies sql admin password')
@secure()
param sqlAdministratorPassword string

@description('Which Pricing tier our App Service Plan to')
param webAppSkuName string = 'B1'

@description('How many instances of our app service will be scaled out to')
param webAppSkuCapacity int = 1

@description('Database sku')
param databaseSku string = 'Standard'

@description('Database Tier')
param databaseTier string = 'Standard'

@description('Database DTU capacity')
param databaseCapacity int = 10

@description('Location for all resources.')
param location string = 'North Europe'

@description('Name that will be used to build associated artifacts')
param resourceName string = 'musicvideobuilder'

@description('Storage Account type')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

var databaseName = resourceName
var appServicePlanName = resourceName
var webSiteName = resourceName
var appInsightName = resourceName
var logAnalyticsName = resourceName
var storageAccountNamePublic = '${resourceName}public'
var storageAccountNamePrivate = '${resourceName}private'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: webAppSkuName
    capacity: webAppSkuCapacity
  }
  tags: {
    displayName: 'HostingPlan'
    ProjectName: resourceName
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'Website'
    ProjectName: resourceName
  }
  dependsOn: [
    logAnalyticsWorkspace
  ]
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

resource appServiceLogging 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
    SqlConnectionString: 'Data Source=tcp:${sqlserver.properties.fullyQualifiedDomainName},1433;Initial Catalog=${sqlserver::database.name};User Id=${sqlserver.properties.administratorLogin}@${sqlserver.properties.fullyQualifiedDomainName};Password=${sqlAdministratorPassword};'
    PublicStorageAccountConnectionString: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountPublic.name};AccountKey=${listKeys(storageAccountPublic.id, storageAccountPublic.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
    PrivateStorageAccountConnectionString: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountPrivate.name};AccountKey=${listKeys(storageAccountPrivate.id, storageAccountPrivate.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
  }
  dependsOn: [
    appServiceAppSettings
  ]
}

resource appServiceAppSettings 'Microsoft.Web/sites/siteextensions@2020-06-01' = {
  parent: appService
  name: 'Microsoft.ApplicationInsights.AzureWebSites'
  dependsOn: [
    appInsights
  ]
}

resource appServiceSiteExtension 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'logs'
  properties: {
    applicationLogs: {
      fileSystem: {
        level: 'Warning'
      }
    }
    httpLogs: {
      fileSystem: {
        retentionInMb: 40
        enabled: true
      }
    }
    failedRequestsTracing: {
      enabled: true
    }
    detailedErrorMessages: {
      enabled: true
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightName
  location: location
  kind: 'string'
  tags: {
    displayName: 'AppInsight'
    ProjectName: resourceName
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: location
  tags: {
    displayName: 'Log Analytics'
    ProjectName: resourceName
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

resource sqlserver 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: resourceName
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
}

// nothing for setting up static website - manual
resource storageAccountPublic 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountNamePublic
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    
  }
}


resource storageAccountPrivate'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountNamePrivate
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
    allowBlobPublicAccess: true
    publicNetworkAccess:'Enabled'
  }
}
