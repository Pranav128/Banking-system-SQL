-- Make a deposit
CALL make_deposit(1, 500.00, 'Paycheck deposit');

-- Make a withdrawal
CALL make_withdrawal(1, 200.00, 'ATM withdrawal');

-- Transfer between accounts (same customer)
CALL transfer_money(2, 1, 1000.00, 'Savings to checking transfer');

-- Get account statement
SELECT * FROM account_statements WHERE account_id = 1;

-- Check daily transactions
SELECT * FROM daily_transaction_summary WHERE transaction_day = CURRENT_DATE();

-- View customer overview
SELECT * FROM customer_account_overview;
