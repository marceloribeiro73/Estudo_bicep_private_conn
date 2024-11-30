param env_id string
param subnet_storage_id string
param storage_account_id string
param vnet_id string

var private_DNS_zone_storage_name = 'privatelink.${environment().suffixes.storage}'

resource privateDNSZoneStorage 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: private_DNS_zone_storage_name
  location: 'global'
  properties: {}
  
}

resource privateDnsZoneLinkStorage 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: '${private_DNS_zone_storage_name}-link'
  parent: privateDNSZoneStorage
  location: 'global'
  properties: {

    registrationEnabled: false
    virtualNetwork: {
      id: vnet_id
    }
  }
}

resource privateEndPointDnsGroupStr 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-03-01' = {
  name: '${private_DNS_zone_storage_name}-privateEndPointDnsGroupStr'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'configStrorage'
        properties: {
          privateDnsZoneId: privateDNSZoneStorage.id

        }
      }
    ]
  }
  parent: PEStrorageAccountTeste
}


resource PEStrorageAccountTeste 'Microsoft.Network/privateEndpoints@2024-03-01' = {
  name: 'pe-br-${env_id}-strteste'
  location: resourceGroup().location
  properties: {
    subnet: {
      id: subnet_storage_id
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-br-${env_id}-strteste'
        properties: {
          privateLinkServiceId: storage_account_id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}
