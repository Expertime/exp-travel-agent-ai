# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

import os
import requests
from aiohttp import web
from aiohttp.web import Request, Response, json_response


def directline_routes():
    async def get_directline_token(req: Request) -> Response:
        user_id = f"dl_{os.urandom(16).hex()}"
        headers = {
            "Authorization": f"Bearer {os.getenv('AZURE_DIRECT_LINE_SECRET')}",
            "Content-type": "application/json"
        }
        body = {
            "User": { "Id": user_id }
        }
        response = requests.post("https://directline.botframework.com/v3/directline/tokens/generate", headers=headers, json=body)
        token_response = response
        return json_response(token_response.json(), status=token_response.status_code)


    return [
        web.get("/api/directline/token", get_directline_token)
    ]
