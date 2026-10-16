from fastapi import APIRouter

router = APIRouter()


@router.post("/invoices")
def create():
    return {}
