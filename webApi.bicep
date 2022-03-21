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

@description('Name of the image uploader function secret')
param functionSecret string

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
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'Website'
    ProjectName: resourceName
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
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
          name: 'ReverseProxy__Routes__route1__ClusterId'
          value: 'cluster1'
        }
        {
          name: 'ReverseProxy__Routes__route1__AuthorizationPolicy'
          value: 'AuthorRolePolicy'
        }
        {
          name: 'ReverseProxy__Routes__route1__Match__Path'
          value: '/Upload'
        }
        {
          name: 'ReverseProxy__Routes__route1__Transforms__0__PathRemovePrefix'
          value: '/Upload'
        }
        {
          name: 'ReverseProxy__Clusters__cluster1__Destinations__destination1__Address'
          value: '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${functionSecret})'
        }
      ]
      cors:{
        allowedOrigins: [
          'https://musicvideobuilder.com'
        ]
      }
      netFrameworkVersion:'v6.0'
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
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
