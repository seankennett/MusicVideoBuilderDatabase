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
param location string = 'West Europe'

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
var staticSiteName = resourceName
var batchServiceName = resourceName
var actionGroupName = resourceName
var storageAccountNamePublic = '${resourceName}public'
var storageAccountNamePrivate = '${resourceName}private'
var publicStorageSecretName = 'PublicStorageConnectionString'
var privateStorageSecretName = 'PrivateStorageConnectionString'
var eventGridName = storageAccountNamePrivate
var imageProcessFunctionAppName = 'imageprocessfunction'
var imageUploaderConnectionSecretName = 'ImageUploaderConnectionString'
var videoNotifyFunctionAppName = 'videonotifyfunction'
var videoNotifyConnectionSecretName = 'VideoNotifyConnectionString'
var builderFunctionAppName = 'builderfunction'
var builderConnectionSecretName = 'BuilderConnectionString'

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
    keyvaultName: keyvaultName
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    storageConnectionString: keyvault.getSecret(imageUploaderConnectionSecretName)
    triggerConnectionString: keyvault.getSecret(privateStorageSecretName)
    functionAppName: imageProcessFunctionAppName
  }
  dependsOn: [
    storagePrivate
    storageImageUploader
  ]
}

module storageImageUploader 'storageAccount.bicep' = {
  name: 'deployStorageImageUploader'
  params: {
    location: location
    storageAccountName: imageProcessFunctionAppName
    storageAccountType: storageAccountType
    secretName: imageUploaderConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module videoNotifyFunction 'function.bicep' = {
  name: 'deployVideoNotifyFunction'
  params: {
    location: location
    keyvaultName: keyvaultName
    storageConnectionString: keyvault.getSecret(videoNotifyConnectionSecretName)
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    functionAppName: videoNotifyFunctionAppName
  }
  dependsOn: [
    storageVideoNotify
  ]
}

module storageVideoNotify 'storageAccount.bicep' = {
  name: 'deployStorageVideoNotify'
  params: {
    location: location
    storageAccountName: videoNotifyFunctionAppName
    storageAccountType: storageAccountType
    secretName: videoNotifyConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module musicVideoBuilderFunction 'function.bicep' = {
  name: 'deployMusicVideoBuilderFunction'
  params: {
    location: location
    keyvaultName: keyvaultName
    triggerConnectionString: keyvault.getSecret(privateStorageSecretName)
    storageConnectionString: keyvault.getSecret(builderConnectionSecretName)
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    functionAppName: builderFunctionAppName
    additionalAppSettings: [
      {
        name: 'ContentDeliveryNetworkBaseUrl'
        value: 'https://cdn.musicvideobuilder.com'
      }
    ]
  }
  dependsOn: [
    storageMusicVideoBuilder
  ]
}

module storageMusicVideoBuilder 'storageAccount.bicep' = {
  name: 'deployStorageMusicVideoBuilder'
  params: {
    location: location
    storageAccountName: builderFunctionAppName
    storageAccountType: storageAccountType
    secretName: builderConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module webApi 'webApi.bicep' = {
  name: 'deployWebApi'
  params: {
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    location: location
    resourceName: resourceName
    webAppSkuCapacity: webAppSkuCapacity
    webAppSkuName: webAppSkuName
  }
  dependsOn: [
    imageUploaderFunction
  ]
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
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
    location: location
    storageAccountName: storageAccountNamePublic
    storageAccountType: storageAccountType
    secretName: publicStorageSecretName
    keyvaultName: keyvaultName
    supportHttpsOnly: false // workaround for cert issue cdn will call http not great but you have to use azure cdn for this to work
    enableCors: true
  }
}

module storagePrivate 'storageAccount.bicep' = {
  name: 'deployStoragePrivate'
  params: {
    location: location
    storageAccountName: storageAccountNamePrivate
    storageAccountType: storageAccountType
    secretName: privateStorageSecretName
    keyvaultName: keyvaultName
    queues: [
      'image-process'
      'music-video-builder'
    ]
    enableCors: true
    enableUserDeleteLifeCycle: true
  }
}

module staticWebsite 'staticSite.bicep' = {
  name: 'deployStaticWebsite'
  params: {
    resourceName: staticSiteName
    location: location
  }
}

module batchService 'batchService.bicep' = {
  name: 'deployBatchService'
  params: {
    resourceName: batchServiceName
    location: location
    storageAccountId: storagePrivate.outputs.id
    poolName: 'builderPoolF8SV2'
    actionGroupId: appInsights.outputs.actionGroupId
  }
}

var functionInsideNamespace = '${videoNotifyFunction.outputs.id}/functions/VideoNotifyFunction'
module eventGrid 'eventGrid.bicep' = {
  name: 'deployEventGrid'
  params: {
    resourceName: eventGridName
    location: location
    storageAccountId: storagePrivate.outputs.id
    functionId: functionInsideNamespace
  }
}
