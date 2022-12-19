@description('Name that will be used to build associated artifacts')
param resourceName string

@description('Location for all resources.')
param location string

var appInsightName = resourceName
var logAnalyticsName = resourceName
var keyvaultName = resourceName

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightName
  location: location
  kind: 'string'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: location
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

output appInsightsConnectionString string = appInsights.properties.ConnectionString
