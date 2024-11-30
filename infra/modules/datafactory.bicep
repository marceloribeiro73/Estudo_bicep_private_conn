param env_id string
param storage_account_id string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: 'adfbr${env_id}teste'
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    
  }
}

resource dataFactoryMVN 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: 'adf-mgvnet-br-${env_id}-teste'
  parent: dataFactory
  properties: {
    
  }
}

resource dataFactoryPE 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  parent: dataFactoryMVN
  name: 'pe-br-${env_id}-adf'
  properties: {
    privateLinkResourceId: storage_account_id
    groupId: 'blob'
  }
}
