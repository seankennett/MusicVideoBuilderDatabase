@description('Name that will be used to build associated artifacts')
param resourceName string

@description('Location for all resources.')
param location string

@description('Which Pricing tier our App Service Plan to')
param webAppSkuName string

@description('How many instances of our app service will be scaled out to')
param webAppSkuCapacity int

@description('Application Inisghts connection string')
param appInsightsConnectionString string

@description('User Identity Name')
param userIdentityId string

@description('Private blob storage url')
param privateBlobStorageUrl string

@description('Private queue storage url')
param privateQueueStorageUrl string

@description('Upload layer queue')
param uploadLayerQueue string

@description('Build Instructor Queue')
param buildInstructorQueue string

@description('Database Connection String')
param databaseConnectionString string

@description('Managed Identity Client Id')
param managedIdentityClientId string

var appServicePlanName = resourceName
var webSiteName = resourceName
var keyvaultName = resourceName

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

resource appService 'Microsoft.Web/sites@2021-03-01' = {
  name: webSiteName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userIdentityId}': {}
    }
  }
  tags: {
    displayName: 'Website'
    ProjectName: resourceName
  }
  properties: {
    serverFarmId: appServicePlan.id
    keyVaultReferenceIdentity: userIdentityId
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'AzureAdB2C__Instance'
          value: 'https://musicvideobuilder.b2clogin.com'
        }
        {
          name: 'AzureAdB2C__ClientId'
          value: '77a830ed-796d-4bed-be76-a163f5a3ee79'
        }
        {
          name: 'AzureAdB2C__Domain'
          value: 'musicvideobuilder.onmicrosoft.com'
        }
        {
          name: 'AzureAdB2C__SignUpSignInPolicyId'
          value: 'B2C_1_signupsignin'
        }
        {
          name: 'AzureAdB2C__Scopes'
          value: 'access_as_user'
        }
        {
          name: 'AzureKeyVaultEndpoint'
          value: 'https://${keyvaultName}${environment().suffixes.keyvaultDns}/'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'WEBSITE_ENABLE_SYNC_UPDATE_SITE'
          value: 'true'
        }
        {
          name: 'PrivateBlobStorageUrl'
          value: privateBlobStorageUrl
        }
        {
          name: 'PrivateQueueStorageUrl'
          value: privateQueueStorageUrl
        }
        {
          name: 'ManagedIdentityClientId'
          value: '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=ManagedIdentityClientId)'
        }
        {
          name: 'UploadLayerQueueName'
          value: uploadLayerQueue
        }
        {
          name: 'BuildInstructorQueueName'
          value: buildInstructorQueue
        }
        {
          name: 'DatabaseConnectionString'
          value: databaseConnectionString
        }
        {
          name: 'ManagedIdentityClientId'
          value: managedIdentityClientId
        }
      ]
      cors: {
        allowedOrigins: [
          'https://musicvideobuilder.com'
        ]
      }
      netFrameworkVersion: 'v6.0'
    }
  }
}
