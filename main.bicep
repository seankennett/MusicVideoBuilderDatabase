@description('Which Pricing tier our App Service Plan to')
param webAppSkuName string = 'F1'

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

var keyvaultName = resourceName
var appServicePlanName = resourceName
var webSiteName = resourceName
var storageAccountNamePublic = '${resourceName}public'
var storageAccountNamePrivate = '${resourceName}private'
var publicStorageSecretName = 'PublicStorageConnectionString'

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

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
    appInsights
  ]
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: 'add'
  parent: keyvault
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: appService.identity.principalId
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

resource appServiceLogging 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'appsettings'
  properties: {
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.outputs.appInsightsConnectionString
    AzureB2C__Instance: 'https://musicvideobuilder.b2clogin.com'
    AzureB2C__Domain: 'musicvideobuilder.onmicrosoft.com'
    AzureB2C__ClientId: '36b06244-f6ad-46c3-95e0-9b1baecbd025'
    AzureB2C__SignUpSignInPolicyId: 'B2C_1_signupsignin'
    AzureB2C__TenantId: subscription().tenantId
    AzureKeyVaultEndpoint: 'https://${keyvaultName}${environment().suffixes.keyvaultDns}/'
    WEBSITE_RUN_FROM_PACKAGE: '1'
    WEBSITE_ENABLE_SYNC_UPDATE_SITE: 'true'
    ReverseProxy__Routes__route1__ClusterId: 'cluster1'
    ReverseProxy__Routes__route1__Match__Path: '/Upload'
    ReverseProxy__Routes__route1__Transforms__0__PathRemovePrefix: '/Upload'
    ReverseProxy__Clusters__cluster1__Destinations__destination1__Address: 'https://musicvideobuilderfunction.azurewebsites.net/api/ImageUploaderFunction?code=bV2tz2DK%2FPEnaIdK76lbaCmPtGMJUOkrflw5bwO0iQS6E4ODsNqXfQ%3D%3D'
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

module appInsights 'appInsights.bicep' = {
  name: 'deployAppInsights'
  params: {
    location: location
    resourceName: resourceName
  }
}

module imageUploaderFunction 'function.bicep' = {
  name: 'deployImageUploaderFunction'
  params: {
    location: location
    resourceName: resourceName
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    storageSecretName: publicStorageSecretName
  }
  dependsOn:[
    storagePublic
  ]
}

module sql 'sqlServerModule.bicep' = {
  name: 'deploySQL'
  params: {
    sqlAdministratorLogin: keyvault.getSecret('SqlAdministratorLogin')
    sqlAdministratorPassword: keyvault.getSecret('SqlAdministratorPassword')
    sqlLoginMusicVideoBuilderApplicationPassword: keyvault.getSecret('SqlLoginMusicVideoBuilderApplicationPassword')
    databaseCapacity: databaseCapacity
    databaseSku: databaseSku
    databaseTier: databaseTier
    location: location
    resourceName: resourceName
  }
}

module storagePublic 'storageAccount.bicep' = {
  name: 'deployStoragePublic'
  params: {
    accessTier: 'Hot'
    location: location
    storageAccountName: storageAccountNamePublic
    storageAccountType: storageAccountType
    secretName: publicStorageSecretName
    keyvaultName: keyvaultName
  }
}

module storagePrivate 'storageAccount.bicep' = {
  name: 'deployStoragePrivate'
  params: {
    accessTier: 'Cool'
    location: location
    storageAccountName: storageAccountNamePrivate
    storageAccountType: storageAccountType
    secretName: 'PrivateStorageConnectionString'
    keyvaultName: keyvaultName
  }
}
