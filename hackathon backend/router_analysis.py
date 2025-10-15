from imports import *

@router.get("/lol")
async def read_root(request: Request):
    return {"message": "Hello, World!"}

from fastapi import Form

@router.post("/analysis-data")
async def read_all_items(request: Request, table_name: str = Form()):
    try:
        query = f"SELECT * FROM {table_name}"
        db = request.app.state.client_postgres
        result = await db.fetch_all(query)
        return {"data": [dict(row) for row in result]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    