@description('Resource name')
param resourceName string

@description('Location for all resources.')
param location string

@description('Storage account id')
param storageAccountId string

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

resource symbolicname 'Microsoft.Batch/batchAccounts/pools@2022-10-01' = {
  name: 'builderPool'
  parent: batchService
  properties: {
    vmSize: 'STANDARD_F4S_V2'
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
