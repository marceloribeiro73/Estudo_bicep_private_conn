targetScope = 'subscription'

param param_env_id string

param param_location string

resource rgTeste 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-br-${param_env_id}-teste'
  location: param_location
}

module networking 'modules/networking.bicep' = {
  scope: rgTeste
  name: 'networking-deployment'
  params: {
    env_id: param_env_id
  }
}

module storage 'modules/storage.bicep' = {
  scope: rgTeste
  name: 'storage-deployment'
  params: {
    env_id: param_env_id
    vnet_id: networking.outputs.out_str_vnet_subnetStorage_id
  }
}

module datafactory 'modules/datafactory.bicep' = {
  scope: rgTeste
  name: 'datafactory-deployment'
  params:{
    env_id: param_env_id
    storage_account_id: storage.outputs.out_str_storage_id
  }
}

module privateNetworking 'modules/privateEndPoints.bicep' = {
  scope: rgTeste
  name: 'privateNetworking-deployment'
  params: {
    env_id: param_env_id
    storage_account_id: storage.outputs.out_str_storage_id
    subnet_storage_id: networking.outputs.out_str_vnet_subnetStorage_id
    vnet_id: networking.outputs.out_str_vnet_id
  }
}

module keyVault 'modules/keyvault.bicep' = {
  scope: rgTeste
  name: 'keyVault-deployment'
  params: {
    env_id: param_env_id
  }
}
