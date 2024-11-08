# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

from aiohttp import web
from aiohttp.web import Request, Response, StreamResponse
from azure.ai.projects import AIProjectClient


def file_routes(project_client: AIProjectClient):
    agent_client = project_client.agents
    async def get_assistant_file(req: Request) -> Response:
        file_id = req.match_info['file_id']
        content = agent_client.get_file_content(file_id)
        response = StreamResponse()
        response.content_type = 'image/png'
        await response.prepare(req)
        for bytes in content:
            await response.write(bytes)
        return response


    return [
        web.get(r"/api/files/{file_id:.*}", get_assistant_file)
    ]
