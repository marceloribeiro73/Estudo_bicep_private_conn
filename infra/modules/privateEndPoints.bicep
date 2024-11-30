param env_id string
param vnet_id string

//Storage
param subnet_storage_id string
param storage_account_id string
param storage_account_name string

//KeyVault
param vault_name string
param subnet_vault_id string


module privateEndpointStorage 'factories/privateEndpoints.bicep' ={
  name: 'privateEndpointStorage'
  params: {
    env_id: env_id
    private_DNS_zone_name: 'privatelink.${environment().suffixes.storage}'
    resource_id: storage_account_id
    subnet_id: subnet_storage_id
    tipo_de_recurso: 'blob'
    vnet_id: vnet_id
    nome_do_recurso: storage_account_name
  }
}

module privateEndpointVault 'factories/privateEndpoints.bicep' ={
  name: 'privateEndpointkeyVault'
  params: {
    env_id: env_id
    private_DNS_zone_name: 'privatelink.${environment().suffixes.keyvaultDns}'
    resource_id: resourceId('Microsoft.KeyVault/vaults',vault_name)
    subnet_id: subnet_vault_id
    tipo_de_recurso: 'vault'
    vnet_id: vnet_id
    nome_do_recurso: vault_name
  }
}

