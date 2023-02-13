@description('Resource name')
param resourceName string

@description('Location for all resources.')
param location string

@description('Storage account id')
param storageAccountId string

@description('action group id')
param actionGroupId string

var keyvaultName = resourceName
var poolName = 'builderPoolD2ADSV5'
var vmSize = 'STANDARD_D2ADS_V5'

resource batchService 'Microsoft.Batch/batchAccounts@2022-10-01' = {
  name: resourceName
  location: location
  properties: {
    autoStorage: {
      storageAccountId: storageAccountId
      authenticationMode: 'StorageKeys'
    }
    poolAllocationMode: 'BatchService'
    publicNetworkAccess: 'Enabled'
  }
}

var taskFailEvent = 'TaskFailEvent'
resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: taskFailEvent
  location: 'global'
  properties:{
    criteria:{
      'odata.type':'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf:[{
        threshold: 0
        criterionType:'StaticThresholdCriterion'
        metricName:taskFailEvent
        name:taskFailEvent
        operator:'GreaterThan'
        timeAggregation:'Total'
        metricNamespace:batchService.type        
      }]
    }
    enabled:true
    evaluationFrequency:'PT1M'
    scopes:[
      batchService.id
    ]
    severity:0
    windowSize:'PT15M'
    actions:[{
      actionGroupId:actionGroupId
    }]
    description:'Alert for failing tasks. Means paying customer is not getting their video.'
  }
}

resource batchPool 'Microsoft.Batch/batchAccounts/pools@2022-10-01' = {
  name: poolName
  parent: batchService
  properties: {
    vmSize: vmSize
    interNodeCommunication: 'Disabled'
    deploymentConfiguration: {
      virtualMachineConfiguration: {
        imageReference: {
          publisher: 'Canonical'
          offer: '0001-com-ubuntu-server-focal'
          sku: '20_04-lts-gen2'
          version: 'latest'
        }
        nodeAgentSkuId: 'batch.node.ubuntu 20.04'
      }
    }
    scaleSettings: {
      autoScale: {
        formula: 'maxNumberofVMs = 4;pendingTaskSamplePercent = $PendingTasks.GetSamplePercent(1 * TimeInterval_Minute);pendingTaskSamples = pendingTaskSamplePercent < 50 ? $CurrentLowPriorityNodes : min($PendingTasks.GetSample(1 * TimeInterval_Minute));$TargetLowPriorityNodes=min(maxNumberofVMs, pendingTaskSamples);$NodeDeallocationOption = taskcompletion;'
        evaluationInterval: 'PT5M'
      }
    }
    startTask: {
      commandLine: '/bin/bash -c \'apt-get update;apt-get install -y ffmpeg\''
      userIdentity: {
        autoUser: {
          scope: 'Pool'
          elevationLevel: 'Admin'
        }
      }
      maxTaskRetryCount: 0
      waitForSuccess: true
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultName
  scope: resourceGroup()
}

resource secret1 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'BatchServiceName'
  parent: keyvault
  properties: {
    value: batchService.name
  }
}

resource secret2 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'BatchServiceEndpoint'
  parent: keyvault
  properties: {
    value: 'https://${batchService.properties.accountEndpoint}'
  }
}

resource secret3 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'BatchServiceKey'
  parent: keyvault
  properties: {
    value: listKeys(batchService.id, batchService.apiVersion).primary
  }
}

resource secret4 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'PoolName'
  parent: keyvault
  properties: {
    value: poolName
  }
}
