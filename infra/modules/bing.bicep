param location string
param bingName string
param tags object = {}
// param privateEndpointSubnetId string
// param publicNetworkAccess string
// param bingPrivateDnsZoneId string
// param grantAccessTo array
// param allowedIpAddresses array = []
// param authMode string

resource bing 'Microsoft.Bing/accounts@2020-06-10' = {
  name: bingName
  location: 'global'
  tags: tags
  sku: {
    name: 'F1'
  }
  kind: 'Bing.Search.v7'
}

output bingID string = bing.id
output bingName string = bing.name
output bingApiEndpoint string = bing.properties.endpoint
