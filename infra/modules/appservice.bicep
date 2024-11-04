param location string
param appServicePlanName string
param appServiceName string
param msiID string
param msiClientID string
param sku string = 'P0v3'
param tags object = {}
param deploymentName string

param aiServicesName string
param bingName string
param cosmosName string

param authMode string
param publicNetworkAccess string
param privateEndpointSubnetId string
param appSubnetId string
param privateDnsZoneId string
param allowedIpAddresses array = []

var allowedIpRestrictions = [
  for allowedIpAddressesArray in allowedIpAddresses: {
    ipAddress: '${allowedIpAddressesArray}/32'
    action: 'Allow'
    priority: 300
  }
]

var ipSecurityRestrictions = concat(allowedIpRestrictions, [
  { action: 'Allow', ipAddress: 'AzureBotService', priority: 100, tag: 'ServiceTag' }
  // Allow Teams Messaging IPs
  { action: 'Allow', ipAddress: '13.107.64.0/18', priority: 200 }
  { action: 'Allow', ipAddress: '52.112.0.0/14', priority: 201 }
  { action: 'Allow', ipAddress: '52.120.0.0/14', priority: 202 }
  { action: 'Allow', ipAddress: '52.238.119.141/32', priority: 203 }
])

resource aiServices 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: aiServicesName
}

resource bingAccount 'Microsoft.Bing/accounts@2020-06-10' existing = {
  name: bingName
}

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = {
  name: cosmosName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: 1
  }
  properties: {
    reserved: true
  }
  kind: 'linux'
}

resource backend 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName
  location: location
  tags: union(tags, { 'azd-service-name': 'genai-bot-app-backend' })
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msiID}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    virtualNetworkSubnetId: !empty(appSubnetId) ? appSubnetId : null
    siteConfig: {
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 35
      ipSecurityRestrictions: ipSecurityRestrictions
      publicNetworkAccess: 'Enabled'
      ipSecurityRestrictionsDefaultAction: 'Deny'
      scmIpSecurityRestrictionsDefaultAction: 'Allow'
      http20Enabled: true
      linuxFxVersion: 'PYTHON|3.10'
      webSocketsEnabled: true
      appCommandLine: 'gunicorn --bind 0.0.0.0 --timeout 600 app:app --worker-class aiohttp.GunicornWebWorker'
      alwaysOn: true
      appSettings: [
        {
          name: 'MicrosoftAppType'
          value: 'UserAssignedMSI'
        }
        {
          name: 'MicrosoftAppId'
          value: msiClientID
        }
        {
          name: 'MicrosoftAppTenantId'
          value: tenant().tenantId
        }
        {
          name: 'AZURE_CLIENT_ID'
          value: msiClientID
        }
        {
          name: 'AZURE_TENANT_ID'
          value: tenant().tenantId
        }
        {
          name: 'SSO_ENABLED'
          value: 'false'
        }
        {
          name: 'SSO_CONFIG_NAME'
          value: ''
        }
        {
          name: 'SSO_MESSAGE_TITLE'
          value: 'Please sign in to continue.'
        }
        {
          name: 'SSO_MESSAGE_PROMPT'
          value: 'Sign in'
        }
        {
          name: 'SSO_MESSAGE_SUCCESS'
          value: 'User logged in successfully! Please repeat your question.'
        }
        {
          name: 'SSO_MESSAGE_FAILED'
          value: 'Log in failed. Type anything to retry.'
        }
        {
          name: 'AZURE_OPENAI_API_ENDPOINT'
          value: aiServices.properties.endpoint
        }
        {
          name: 'AZURE_OPENAI_API_VERSION'
          value: '2024-05-01-preview'
        }
        {
          name: 'AZURE_OPENAI_DEPLOYMENT_NAME'
          value: deploymentName
        }
        {
          name: 'AZURE_OPENAI_ASSISTANT_ID'
          value: 'YOUR_ASSISTANT_ID'
        }
        {
          name: 'AZURE_OPENAI_STREAMING'
          value: 'true'
        }
        {
          name: 'AZURE_OPENAI_API_KEY'
          value: authMode == 'accessKey' ? aiServices.listKeys().key1 : ''
        }
        {
          name: 'AZURE_BING_API_ENDPOINT'
          value: 'https://api.bing.microsoft.com/'
        }
        {
          name: 'AZURE_BING_API_KEY'
          value: bingAccount.listKeys().key1
        }
        {
          name: 'AZURE_COSMOSDB_ENDPOINT'
          value: cosmos.properties.documentEndpoint
        }
        {
          name: 'AZURE_COSMOSDB_DATABASE_ID'
          value: 'GenAIBot'
        }
        {
          name: 'AZURE_COSMOSDB_CONTAINER_ID'
          value: 'Conversations'
        }
        {
          name: 'AZURE_COSMOSDB_AUTH_KEY'
          value: cosmos.listKeys().primaryMasterKey
        }
        {
          name: 'MAX_TURNS'
          value: '10'
        }
        {
          name: 'LLM_WELCOME_MESSAGE'
          value: 'Hello and welcome!'
        }
        {
          name: 'LLM_INSTRUCTIONS'
          value: 'Answer the questions as accurately as possible using the provided functions.'
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'ENABLE_ORYX_BUILD'
          value: 'true'
        }
        {
          name: 'DEBUG'
          value: 'true'
        }
      ]
    }
  }
}

resource backendAppPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = if (publicNetworkAccess == 'Disabled') {
  name: 'pl-${appServiceName}'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'private-endpoint-connection'
        properties: {
          privateLinkServiceId: backend.id
          groupIds: ['sites']
        }
      }
    ]
  }
  resource privateDnsZoneGroup 'privateDnsZoneGroups' = {
    name: 'zg-${appServiceName}'
    properties: {
      privateDnsZoneConfigs: [
        {
          name: 'default'
          properties: {
            privateDnsZoneId: privateDnsZoneId
          }
        }
      ]
    }
  }
}

output backendAppName string = backend.name
output backendHostName string = backend.properties.defaultHostName
