CREATE TABLE interest_calculations (
    calculation_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    calculation_date DATE,
    interest_rate DECIMAL(5,2),
    principal_balance DECIMAL(15,2),
    interest_amount DECIMAL(15,2),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
