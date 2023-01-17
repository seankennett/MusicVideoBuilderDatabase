@description('Name that will be used to build associated artifacts')
param resourceName string

@description('Location for all resources.')
param location string

var appInsightName = resourceName
var logAnalyticsName = resourceName
var actionGroupName = resourceName

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

resource actionGroup 'Microsoft.Insights/actionGroups@2022-06-01' = {
  name: actionGroupName
  location: 'Global'
  properties:{
    groupShortName: 'emailme'
    enabled:true
    emailReceivers:[{
      emailAddress: 'seankennettwork@gmail.com'
      name: 'emailme'
      useCommonAlertSchema: false
    }]
  }
}

var builderFunctionOrchastratorFail = 'BuilderFunctionOrchastratorFail'
resource metricAlert 'Microsoft.Insights/scheduledQueryRules@2022-06-15' = {
  name: builderFunctionOrchastratorFail
  location: location
  properties:{
    displayName: builderFunctionOrchastratorFail
    severity:0
    enabled:true
    evaluationFrequency:'PT15M'
    scopes:[
      appInsights.id
    ]
    windowSize:'PT15M'
    criteria:{
      allOf:[{
        query: 'requests\n| where timestamp > ago(15m)\n| where name=="MusicVideoBuilderOrchastrator"\n| where cloud_RoleName == "builderfunction"\n| where success == false\n| sort by timestamp desc'
        timeAggregation:'Total'
        metricMeasureColumn:'itemCount'
        operator:'GreaterThan'
        threshold:0
        failingPeriods:{
          minFailingPeriodsToAlert: 1
          numberOfEvaluationPeriods: 1
        }
      }]
    }
    actions:{
      actionGroups:[
        actionGroup.id
      ]
    }
    description:'Alert for failing tasks. Means paying customer is not getting their video.'
  }
}

output appInsightsConnectionString string = appInsights.properties.ConnectionString
output actionGroupId string = actionGroup.id
