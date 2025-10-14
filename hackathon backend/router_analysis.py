from imports import *

@router.get("/lol")
async def read_root(request: Request):
    return {"message": "Hello, World!"}

@router.get("/analysis-data")
async def read_all_items(request: Request):
    try:
        query = "SELECT * FROM analysis_data"
        db = request.app.state.client_postgres
        result = await db.fetch_all(query)
        return {"data": [dict(row) for row in result]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    