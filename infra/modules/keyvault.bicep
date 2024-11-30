param env_id string

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
  }
}

output out_str_keyVault_id string = keyVault.id
