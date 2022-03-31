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
var storageAccountNamePublic = '${resourceName}public'
var storageAccountNamePrivate = '${resourceName}private'
var publicStorageSecretName = 'PublicStorageConnectionString'
var imageUploaderFunctionSecret = 'ImageUploaderFunctionUri'
var hostName = 'musicvideobuilder.com'



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
    functionSecretName: imageUploaderFunctionSecret
  }
  dependsOn: [
    storagePublic
  ]
}

module webApi 'webApi.bicep' ={
  name:'deployWebApi'
  params:{
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    functionSecret: imageUploaderFunctionSecret
    location: location
    resourceName: resourceName
    webAppSkuCapacity: webAppSkuCapacity
    webAppSkuName: webAppSkuName
  }
  dependsOn:[
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
    accessTier: 'Hot'
    location: location
    storageAccountName: storageAccountNamePublic
    storageAccountType: storageAccountType
    secretName: 'PublicStorageConnectionString'
    keyvaultName: keyvaultName
    customDomain: 'cdn.${hostName}'
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

module staticWebsite 'staticSite.bicep' = {
  name: 'deployStaticWebsite'
  params:{
    resourceName: staticSiteName
    location: location
  }
}