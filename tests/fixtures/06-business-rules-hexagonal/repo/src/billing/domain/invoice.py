from enum import Enum


class InvoiceStatus(Enum):
    DRAFT = "DRAFT"
    ISSUED = "ISSUED"
    OVERDUE = "OVERDUE"
    PAID = "PAID"


MAX_DISCOUNT = 0.30  # sem documentação


class Invoice:
    def __init__(self, amount: float, status: InvoiceStatus = InvoiceStatus.DRAFT):
        self.amount = amount
        self.status = status

    def apply_discount(self, rate: float) -> None:
        if rate > MAX_DISCOUNT:
            raise ValueError("discount too high")
        self.amount = round(self.amount * (1 - rate), 2)

    def change_amount(self, amount: float) -> None:
        if self.status == InvoiceStatus.OVERDUE:
            raise ValueError("overdue invoice cannot be changed")
        self.amount = amount
