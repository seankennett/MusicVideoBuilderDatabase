@description('Which Pricing tier our App Service Plan to')
param webAppSkuName string = 'F1'

@description('How many instances of our app service will be scaled out to')
param webAppSkuCapacity int = 1

@description('Database sku')
param databaseSku string = 'GP_S_Gen5'

@description('Database Tier')
param databaseTier string = 'GeneralPurpose'

@description('Database DTU capacity')
param databaseCapacity int = 1

@description('Database DTU capacity')
param databaseMaxSizeBytes int = 1073741824

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
var sqlServerName = resourceName
var databaseName = resourceName
var storageAccountNamePublic = '${resourceName}public'
var storageAccountNamePrivate = '${resourceName}private'
var PrivateBlobStorageUrl = 'https://${storageAccountNamePrivate}.blob.${environment().suffixes.storage}'
var PrivateQueueStorageUrl = 'https://${storageAccountNamePrivate}.queue.${environment().suffixes.storage}'

var eventGridName = storageAccountNamePrivate
var newVideoFunctionAppName = 'newvideofunction'
var newVideoConnectionSecretName = 'NewVideoConnectionString'
var builderFunctionAppName = 'freebuilderfunction'
var builderConnectionSecretName = 'BuilderConnectionString'
var builderHdFunctionAppName = 'hdbuilderfunction'
var builderHdConnectionSecretName = 'BuilderHdConnectionString'
var buildInstructorFunctionAppName = 'buildinstructorfunction'
var buildInstructorConnectionSecretName = 'BuildInstructorConnectionString'
var buildCleanFunctionAppName = 'buildcleanfunction'
var buildCleanConnectionSecretName = 'BuildCleanConnectionString'
var publicApiFunctionAppName = 'musicvideobuilderpublic'
var publicApiConnectionSecretName = 'PublicApiConnectionSecretName'

var freeBuilderQueue = 'free-builder'
var hdBuilderQueue = 'hd-builder'
var buildInstructorQueue = 'build-instructor'

var userIdentityName = resourceName

module userIdentity 'userIdentity.bicep' = {
  name: 'deployUserIdentity'
  params: {
    keyvaultName: keyvaultName
    location: location
    userIdentityName: userIdentityName
  }
}

var databaseConnectionString = 'Server=${sqlServerName}${environment().suffixes.sqlServerHostname}; Authentication=Active Directory Managed Identity; Database=${databaseName}; User Id=${userIdentity.outputs.clientId}'

module appInsights 'appInsights.bicep' = {
  name: 'deployAppInsights'
  params: {
    location: location
    resourceName: resourceName
  }
}

module newVideoFunction 'function.bicep' = {
  name: 'deployNewVideoFunction'
  params: {
    location: location
    storageAccountName: newVideoFunctionAppName
    storageSecretName: newVideoConnectionSecretName
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    functionAppName: newVideoFunctionAppName
    userIdentityId: userIdentity.outputs.id
    keyvaultName: keyvaultName
    databaseConnectionString: databaseConnectionString
    managedIdentityClientId: userIdentity.outputs.clientId
    additionalAppSettings: [
      {
        name: 'PrivateBlobStorageUrl'
        value: PrivateBlobStorageUrl
      }
      {
        name: 'AzureKeyVaultEndpoint'
        value: 'https://${keyvaultName}${environment().suffixes.keyvaultDns}/'
      }
      {
        name: 'AZURE_CLIENT_ID'
        value: userIdentity.outputs.clientId
      }
    ]
  }
  dependsOn: [
    storageNewVideo
  ]
}

module storageNewVideo 'storageAccount.bicep' = {
  name: 'deployStorageNewVideo'
  params: {
    location: location
    storageAccountName: newVideoFunctionAppName
    storageAccountType: storageAccountType
    secretName: newVideoConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module freeBuilderFunction 'function.bicep' = {
  name: 'deployFreeBuilderFunction'
  params: {
    location: location
    triggerStorageQueueUri: PrivateQueueStorageUrl
    storageAccountName: builderFunctionAppName
    storageSecretName: builderConnectionSecretName
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    functionAppName: builderFunctionAppName
    runFromPackage: false
    managedIdentityClientId: userIdentity.outputs.clientId
    additionalAppSettings: [
      {
        name: 'QueueName'
        value: freeBuilderQueue
      }
      {
        name: 'PrivateBlobStorageUrl'
        value: PrivateBlobStorageUrl
      }
      {
        name: 'AzureFunctionsJobHost__extensions__durableTask__maxConcurrentActivityFunctions'
        value: 4
      }
      {
        name: 'AZURE_CLIENT_ID'
        value: userIdentity.outputs.clientId
      }
    ]
    keyvaultName: keyvaultName
    userIdentityId: userIdentity.outputs.id
  }
  dependsOn: [
    storageFreeBuilder
  ]
}

module storageFreeBuilder 'storageAccount.bicep' = {
  name: 'deployStorageFreeBuilder'
  params: {
    location: location
    storageAccountName: builderFunctionAppName
    storageAccountType: storageAccountType
    secretName: builderConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module hdBuilderFunction 'function.bicep' = {
  name: 'deployHdBuilderFunction'
  params: {
    location: location
    triggerStorageQueueUri: PrivateQueueStorageUrl
    storageAccountName: builderHdFunctionAppName
    storageSecretName: builderHdConnectionSecretName
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    functionAppName: builderHdFunctionAppName
    runFromPackage: false
    managedIdentityClientId: userIdentity.outputs.clientId
    additionalAppSettings: [
      {
        name: 'QueueName'
        value: hdBuilderQueue
      }
      {
        name: 'PrivateBlobStorageUrl'
        value: PrivateBlobStorageUrl
      }
      {
        name: 'AzureFunctionsJobHost__extensions__durableTask__maxConcurrentActivityFunctions'
        value: 1
      }
      {
        name: 'AZURE_CLIENT_ID'
        value: userIdentity.outputs.clientId
      }
    ]
    keyvaultName: keyvaultName
    userIdentityId: userIdentity.outputs.id
  }
  dependsOn: [
    storageHdBuilder
  ]
}

module storageHdBuilder 'storageAccount.bicep' = {
  name: 'deployStorageHdBuilder'
  params: {
    location: location
    storageAccountName: builderHdFunctionAppName
    storageAccountType: storageAccountType
    secretName: builderHdConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module buildInstructorFunction 'function.bicep' = {
  name: 'deployBuildInstructorFunction'
  params: {
    location: location
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    triggerStorageQueueUri: PrivateQueueStorageUrl
    storageAccountName: buildInstructorFunctionAppName
    storageSecretName: buildInstructorConnectionSecretName
    functionAppName: buildInstructorFunctionAppName
    userIdentityId: userIdentity.outputs.id
    keyvaultName: keyvaultName
    databaseConnectionString: databaseConnectionString
    managedIdentityClientId: userIdentity.outputs.clientId
    additionalAppSettings: [
      {
        name: 'QueueName'
        value: buildInstructorQueue
      }
      {
        name: 'PrivateBlobStorageUrl'
        value: PrivateBlobStorageUrl
      }
      {
        name: 'PrivateQueueStorageUrl'
        value: PrivateQueueStorageUrl
      }
      {
        name: 'AZURE_CLIENT_ID'
        value: userIdentity.outputs.id
      }
      {
        name: 'AzureKeyVaultEndpoint'
        value: 'https://${keyvaultName}${environment().suffixes.keyvaultDns}/'
      }
      {
        name: 'ManagedIdentityClientId'
        value: userIdentity.outputs.clientId
      }
      {
        name: 'FreeBuilderQueueName'
        value: freeBuilderQueue
      }
      {
        name: 'HdBuilderQueueName'
        value: hdBuilderQueue
      }
    ]
  }
  dependsOn: [
    storagePrivate
    storageBuildInstructor
  ]
}

module storageBuildInstructor 'storageAccount.bicep' = {
  name: 'deployStorageBuildInstructor'
  params: {
    location: location
    storageAccountName: buildInstructorFunctionAppName
    storageAccountType: storageAccountType
    secretName: buildInstructorConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module buildCleanFunction 'function.bicep' = {
  name: 'deployBuildCleanFunction'
  params: {
    location: location
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    storageAccountName: buildCleanFunctionAppName
    storageSecretName: buildCleanConnectionSecretName
    functionAppName: buildCleanFunctionAppName
    userIdentityId: userIdentity.outputs.id
    keyvaultName: keyvaultName
    databaseConnectionString: databaseConnectionString
    managedIdentityClientId: userIdentity.outputs.clientId
  }
  dependsOn: [
    storageBuildClean
  ]
}

module storageBuildClean 'storageAccount.bicep' = {
  name: 'deployStorageBuildClean'
  params: {
    location: location
    storageAccountName: buildCleanFunctionAppName
    storageAccountType: storageAccountType
    secretName: buildCleanConnectionSecretName
    keyvaultName: keyvaultName
  }
}

module publicApiFunction 'function.bicep' = {
  name: 'deployPublicApiFunction'
  params: {
    location: location
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    storageAccountName: publicApiFunctionAppName
    storageSecretName: publicApiConnectionSecretName
    functionAppName: publicApiFunctionAppName
    userIdentityId: userIdentity.outputs.id
    keyvaultName: keyvaultName
    databaseConnectionString: databaseConnectionString
    managedIdentityClientId: userIdentity.outputs.clientId
  }
  dependsOn: [
    storagePublicApi
  ]
}

module storagePublicApi 'storageAccount.bicep' = {
  name: 'deployStoragePublicApi'
  params: {
    location: location
    storageAccountName: publicApiFunctionAppName
    storageAccountType: storageAccountType
    secretName: publicApiConnectionSecretName
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
    userIdentityId: userIdentity.outputs.id
    privateBlobStorageUrl: PrivateBlobStorageUrl
    privateQueueStorageUrl: PrivateQueueStorageUrl
    buildInstructorQueue: buildInstructorQueue
    databaseConnectionString: databaseConnectionString
    managedIdentityClientId: userIdentity.outputs.clientId
  }
  dependsOn: [
  ]
}

module sql 'sqlServerModule.bicep' = {
  name: 'deploySQL'
  params: {
    databaseCapacity: databaseCapacity
    databaseSku: databaseSku
    databaseTier: databaseTier
    databaseMaxSizeBytes: databaseMaxSizeBytes
    location: location
    sqlServerName: sqlServerName
    databaseName: databaseName
    userIdentityId: userIdentity.outputs.id
  }
}

module storagePublic 'storageAccount.bicep' = {
  name: 'deployStoragePublic'
  params: {
    location: location
    storageAccountName: storageAccountNamePublic
    storageAccountType: storageAccountType
    supportHttpsOnly: false // workaround for cert issue cdn will call http not great but you have to use azure cdn for this to work
    enableCors: true
    customDomainName: 'cdn.musicvideobuilder.com'
  }
}

module storagePrivate 'storageAccount.bicep' = {
  name: 'deployStoragePrivate'
  params: {
    location: location
    storageAccountName: storageAccountNamePrivate
    storageAccountType: storageAccountType
    queues: [
      freeBuilderQueue
      hdBuilderQueue
      buildInstructorQueue
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
    actionGroupId: appInsights.outputs.actionGroupId
    userIdentityId: userIdentity.outputs.id
  }
}

var functionInsideNamespace = '${newVideoFunction.outputs.id}/functions/NewVideoFunction'
module eventGrid 'eventGrid.bicep' = {
  name: 'deployEventGrid'
  params: {
    resourceName: eventGridName
    location: location
    storageAccountId: storagePrivate.outputs.id
    functionId: functionInsideNamespace
  }
}
