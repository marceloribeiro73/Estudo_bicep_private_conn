@description('Codigo do Ambiente:')
@allowed([
  'dev'
  'tes'
  'prd'
])
@maxLength(3)
param env_id string

@description('Id da subnet onde o PrivateEndPoint sera criado:')
param subnet_id string

@description('Id do recurso vinculado ao PrivateEndpoint')
param resource_id string

@description('Tipo de recurso a ser vinculado ao privateEndpoint, exemplo: blob')
@allowed([
  'blob'
  'sqlServer'
])
param tipo_de_recurso string

@description('Id da virtual network onde a o endpoint esta sendo criado: ')
param vnet_id string

@description('Nome da zona de dns privada:')
param private_DNS_zone_name string 

@description('Nome do recurso: (Sera usado para criar o nome do endpoint, por exemplo, strteste (storage do projeto teste))')
param nome_do_recurso string

var privateEndPointName = 'pe-br-${env_id}-${nome_do_recurso}'

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: private_DNS_zone_name
  location: 'global'
  properties: {}
  
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: '${private_DNS_zone_name}-link'
  parent: privateDNSZone
  location: 'global'
  properties: {

    registrationEnabled: false
    virtualNetwork: {
      id: vnet_id
    }
  }
}

resource privateEndPointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-03-01' = {
  name: '${private_DNS_zone_name}-privateEndPointDnsGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'configStrorage'
        properties: {
          privateDnsZoneId: privateDNSZone.id

        }
      }
    ]
  }
  parent: privateEndpoint
}


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-03-01' = {
  name: privateEndPointName
  location: resourceGroup().location
  properties: {
    subnet: {
      id: subnet_id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndPointName
        properties: {
          privateLinkServiceId: resource_id
          groupIds: [
            tipo_de_recurso
          ]
        }
      }
    ]
  }
}

