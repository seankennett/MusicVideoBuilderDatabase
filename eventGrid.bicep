@description('Resource name')
param resourceName string

@description('Location for all resources.')
param location string

@description('Storage account id')
param storageAccountId string

@description('Function id')
param functionId string

var topicName = '${resourceName}topic'
var subscriptionName = '${resourceName}newvid'

resource systemTopic 'Microsoft.EventGrid/systemTopics@2021-12-01' = {
  name: topicName
  location: location
  properties: {
    source: storageAccountId
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

resource eventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01' = {
  parent: systemTopic
  name: subscriptionName
  properties: {
    destination: {
      endpointType: 'AzureFunction'
      properties: {
        resourceId: functionId
      }
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
      ]
      advancedFilters:[
        {
          operatorType: 'StringContains'
          key: 'subject'
          values: [
            '/user-'
          ]
        }
        {
          operatorType: 'StringNotContains'
          key: 'subject'
          values: [
            '/temp/'
          ]
        }
        {
          operatorType: 'StringEndsWith'
          key: 'subject'
          values:[
            '.mp4'
            '.mov'
            '.avi'
          ]
        }
      ]
    }
    eventDeliverySchema: 'EventGridSchema'
    retryPolicy:{
      eventTimeToLiveInMinutes: 1440
      maxDeliveryAttempts: 5
    }
  }
}
