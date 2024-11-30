param env_id string
param subnet_storage_id string
param storage_account_id string
param storage_account_name string
param vnet_id string


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

