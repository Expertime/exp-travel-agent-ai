param location string
param botServiceName string
param keyVaultName string
param endpoint string
param msiID string
param msiClientID string
param sku string = 'F0'
param kind string = 'azurebot'
param tags object = {}
param publicNetworkAccess string


resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
  
  resource secret 'secrets' = {
    name: 'DIRECT_LINE_SECRET'
    properties: {
      value: botservice::directline.listChannelWithKeys().setting.extensionKey1
    }
  }
}

resource botservice 'Microsoft.BotService/botServices@2022-09-15' = {
  name: botServiceName
  location: location
  tags: tags
  sku: {
    name: sku
  }
  kind: kind
  properties: {
    displayName: botServiceName
    endpoint: endpoint
    msaAppMSIResourceId: msiID
    msaAppId: msiClientID
    msaAppType: 'UserAssignedMSI'
    msaAppTenantId: tenant().tenantId
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: true
  }

  resource directline 'channels' = {
    name: 'directline'
    properties: {
      channelName: 'DirectLineChannel'
    }
  }

}

output name string = botservice.name
