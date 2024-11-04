import os
import io
import pytest
from unittest.mock import MagicMock
from botbuilder.integration.aiohttp import CloudAdapter, ConfigurationBotFrameworkAuthentication
from openai import AzureOpenAI
from openai.resources.files import Files

from config import DefaultConfig
from bots import AssistantBot
from app import create_app

current_directory = os.path.dirname(__file__)

aoai_client = MagicMock(spec=AzureOpenAI)
aoai_client.files = MagicMock(spec=Files)
aoai_client.files.content = MagicMock(return_value=io.FileIO(f"{current_directory}/../../data/fork.jpg", 'r'))
@pytest.fixture()
async def client(aiohttp_client):
    config = DefaultConfig()
    adapter = CloudAdapter(ConfigurationBotFrameworkAuthentication(config))
    bot = MagicMock(spec=AssistantBot)
    return await aiohttp_client(create_app(adapter, bot, aoai_client))

async def test_file_download(client):
    resp = await client.get('/api/files/MY_FILE')
    # resp = await client.get('/api/directline/token')
    # assert aoai_client.files.content.assert_called_with('my-file-id')
    assert resp.status == 200