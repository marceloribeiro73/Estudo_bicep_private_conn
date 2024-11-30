param env_id string
param object_id_adm string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'akv-br-${env_id}-teste'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    enabledForDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 30
    networkAcls:{
      defaultAction:'Deny'
      bypass: 'AzureServices'
    }
    tenantId: tenant().tenantId
    accessPolicies:[
      {
        tenantId: tenant().tenantId
        objectId: object_id_adm
        permissions: {
          keys:[
            'list'
          ]
          secrets: [
            'list'
          ]
        }
      }
    ]
  }
}

output out_str_keyVault_name string = keyVault.name
