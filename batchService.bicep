@description('Resource name')
param resourceName string

@description('Location for all resources.')
param location string

@description('Storage account id')
param storageAccountId string

@description('Pool name')
param poolName string

@description('Job name')
param jobName string

var keyvaultName = resourceName

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

resource batchPool 'Microsoft.Batch/batchAccounts/pools@2022-10-01' = {
  name: poolName
  parent: batchService
  properties: {
    vmSize: 'STANDARD_F8S_V2'
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
        formula: 'startingNumberOfVMs = 0;maxNumberofVMs = 2;pendingTaskSamplePercent = $PendingTasks.GetSamplePercent(5 * TimeInterval_Minute);pendingTaskSamples = pendingTaskSamplePercent < 70 ? startingNumberOfVMs : avg($PendingTasks.GetSample(5 * TimeInterval_Minute));$TargetLowPriorityNodes=min(maxNumberofVMs, pendingTaskSamples);$NodeDeallocationOption = taskcompletion;'
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
    value: batchService.properties.accountEndpoint
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
  name: 'JobName'
  parent: keyvault
  properties: {
    value: jobName
  }
}
