package ledger

// Balance must never be negative.
func Debit(balance, amount int64) (int64, bool) {
	if amount > balance {
		return balance, false
	}
	return balance - amount, true
}
