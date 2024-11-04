# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

from openai import AzureOpenAI
from aiohttp import web
from aiohttp.web import Request, Response, StreamResponse


def file_routes(aoai_client: AzureOpenAI):
    async def get_assistant_file(req: Request) -> Response:
        file_id = req.match_info['file_id']
        content = aoai_client.files.content(file_id)
        response = StreamResponse()
        response.content_type = 'image/png'
        await response.prepare(req)
        await response.write(content.read())
        return response


    return [
        web.get(r"/api/files/{file_id:.*}", get_assistant_file)
    ]
