from fastapi import APIRouter, Request, Response
from ..config import MONOLITH_URL

router = APIRouter()

@router.api_route("/bonus", methods=["POST"], tags=["Bonus"])
@router.api_route("/bonus/{id}", methods=["GET"], tags=["Bonus"])
async def proxy(request: Request, id: str = None):
    url = f"{MONOLITH_URL}/bonus"
    if id:
        url += f"/{id}"
    
    client = request.app.state.client
    method = request.method
    if method == "POST":
        content = await request.body()
        response = await client.request(method, url, content=content, headers=request.headers.items())
    else:
        response = await client.request(method, url, headers=request.headers.items())
            
    return Response(content=response.content, status_code=response.status_code, headers=dict(response.headers))
