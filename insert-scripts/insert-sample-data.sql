-- Insert account types
INSERT INTO account_types (type_name, description, interest_rate, minimum_balance) VALUES
('Savings', 'Regular savings account', 1.25, 100.00),
('Checking', 'Basic checking account', 0.10, 25.00),
('Premium', 'Premium account with benefits', 2.50, 5000.00);

-- Insert customers
INSERT INTO customers (first_name, last_name, email, phone, date_of_birth) VALUES
('John', 'Smith', 'john.smith@example.com', '555-0101', '1985-07-15'),
('Sarah', 'Johnson', 'sarah.j@example.com', '555-0102', '1990-11-22'),
('Michael', 'Williams', 'michael.w@example.com', '555-0103', '1978-03-08');

-- Insert accounts
INSERT INTO accounts (customer_id, type_id, account_number, current_balance, date_opened) VALUES
(1, 2, 'CHK10001', 2500.00, '2020-01-15'),
(1, 1, 'SAV10001', 10000.00, '2020-01-15'),
(2, 2, 'CHK20001', 3500.00, '2021-03-10'),
(3, 3, 'PRM30001', 25000.00, '2019-11-05');

-- Insert sample transactions
INSERT INTO transactions (account_id, transaction_type, amount, description) VALUES
(1, 'deposit', 1000.00, 'Initial deposit'),
(1, 'withdrawal', 200.00, 'ATM withdrawal'),
(2, 'deposit', 5000.00, 'Initial deposit'),
(2, 'interest', 12.50, 'Monthly interest'),
(3, 'deposit', 2000.00, 'Paycheck deposit'),
(4, 'deposit', 25000.00, 'Account opening');
