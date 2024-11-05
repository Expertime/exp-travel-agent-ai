# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

import os
from azure.identity import DefaultAzureCredential, get_bearer_token_provider
from azure.cosmos.cosmos_client import CosmosClient
from aiohttp import web
from botbuilder.azure import (
    CosmosDbPartitionedStorage,
    CosmosDbPartitionedConfig,
)
from botbuilder.core import (
    ActivityHandler,
    ConversationState,
    MemoryStorage,
    UserState,
)
from botbuilder.core.integration import aiohttp_error_middleware
from botbuilder.integration.aiohttp import CloudAdapter, ConfigurationBotFrameworkAuthentication

from openai import AzureOpenAI
from dotenv import load_dotenv

from dialogs import LoginDialog
from bots import AssistantBot
from services.bing import BingClient
from services.graph import GraphClient
from config import DefaultConfig

from routes.api.messages import messages_routes
from routes.api.directline import directline_routes
from routes.api.files import file_routes
from routes.static.static import static_routes

load_dotenv()

def create_app(adapter: CloudAdapter, bot: ActivityHandler, aoai_client: AzureOpenAI) -> web.Application:
    app = web.Application(middlewares=[aiohttp_error_middleware])
    app.add_routes(messages_routes(adapter, bot))
    app.add_routes(directline_routes())
    app.add_routes(file_routes(aoai_client))
    app.add_routes(static_routes())
    return app

config = DefaultConfig()

# Create adapter.
# See https://aka.ms/about-bot-adapter to learn more about how bots work.
adapter = CloudAdapter(ConfigurationBotFrameworkAuthentication(config))

# Set up service authentication
credential = DefaultAzureCredential(managed_identity_client_id=os.getenv("MicrosoftAppId"))

# Azure AI Services
aoai_client = AzureOpenAI(
    api_version=os.getenv("AZURE_OPENAI_API_VERSION"),
    azure_endpoint=os.getenv("AZURE_OPENAI_API_ENDPOINT"),
    api_key=os.getenv("AZURE_OPENAI_API_KEY"),
    azure_ad_token_provider=get_bearer_token_provider(
        credential, 
        "https://cognitiveservices.azure.com/.default"
    )
)

bing_client = BingClient(os.getenv("AZURE_BING_API_KEY"))
graph_client = GraphClient()

# Conversation history storage
storage = None
if os.getenv("AZURE_COSMOSDB_ENDPOINT"):
    storage = CosmosDbPartitionedStorage(
        CosmosDbPartitionedConfig(
            cosmos_db_endpoint=os.getenv("AZURE_COSMOSDB_ENDPOINT"),
            database_id=os.getenv("AZURE_COSMOSDB_DATABASE_ID"),
            container_id=os.getenv("AZURE_COSMOSDB_CONTAINER_ID"),
            auth_key=os.getenv("AZURE_COSMOSDB_AUTH_KEY"),
        )
    )
    # storage.client = CosmosClient(os.getenv("AZURE_COSMOSDB_ENDPOINT"), auth=credential)
else:
    storage = MemoryStorage()

# Create conversation and user state
user_state = UserState(storage)
conversation_state = ConversationState(storage)

# Create the bot
dialog = LoginDialog()
bot = AssistantBot(conversation_state, user_state, aoai_client, os.getenv("AZURE_OPENAI_ASSISTANT_ID"), bing_client, graph_client, dialog)
app = create_app(adapter, bot, aoai_client)

if __name__ == "__main__":
    web.run_app(app, host="localhost", port=8080)