@description('Name that will be used to build associated artifacts')
param resourceName string

var staticSiteName = resourceName
var keyvaultName = resourceName

var staticSkuTier = 'Free'
var staticSkuName = 'Free'


resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
  name: staticSiteName
  location: 'West Europe'
  sku: {
    tier: staticSkuTier
    name: staticSkuName
  }
  properties:{
    repositoryUrl: 'https://dev.azure.com/musicvideobuilder/Music Video Builder/_git/MusicVideoBuilderSPA'
    branch: 'master'
    provider:'DevOps'
    buildProperties:{
      skipGithubActionWorkflowGeneration: true
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'StaticWebAppDeploymentToken'
  parent: keyvault
  properties: {
    value: listSecrets(staticSite.id, staticSite.apiVersion).properties.apiKey
  }
}
