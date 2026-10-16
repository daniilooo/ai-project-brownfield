import pytest

from billing.domain.invoice import Invoice, InvoiceStatus


def test_overdue_invoice_cannot_be_changed():
    invoice = Invoice(100.0, InvoiceStatus.OVERDUE)
    with pytest.raises(ValueError):
        invoice.change_amount(50.0)
