param env_id string
param location string = resourceGroup().location
param vnet_id string

resource storageaccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'strbr${env_id}teste'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    isSftpEnabled: false
    publicNetworkAccess: 'SecuredByPerimeter'
    minimumTlsVersion: 'TLS1_2'
    networkAcls:{
      defaultAction: 'Deny'
      virtualNetworkRules:[
        {
          id: vnet_id
        }
      ]
    }
  }

}

resource storageAccountBlob 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageaccount
  name: 'default'
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccountBlob
  name: 'raw-data'
  properties: {
    publicAccess: 'None'
  }
}



output out_str_storage_id string = storageaccount.id
output out_str_storage_name string = storageaccount.name
