"""create invoice"""
from alembic import op
import sqlalchemy as sa


def upgrade():
    op.create_table(
        "invoice",
        sa.Column("id", sa.Integer, primary_key=True),
        sa.Column("amount", sa.Numeric(12, 2), nullable=False),
        sa.CheckConstraint("amount >= 0", name="ck_invoice_amount_non_negative"),
    )
