-- Customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX (email),
    INDEX (last_name, first_name)
);

-- Account types
CREATE TABLE account_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    interest_rate DECIMAL(5,2) DEFAULT 0.00,
    minimum_balance DECIMAL(15,2) DEFAULT 0.00
);

-- Accounts table
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    type_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    current_balance DECIMAL(15,2) DEFAULT 0.00,
    date_opened DATE NOT NULL,
    status ENUM('active', 'dormant', 'closed', 'frozen') DEFAULT 'active',
    last_activity_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (type_id) REFERENCES account_types(type_id),
    INDEX (account_number),
    INDEX (customer_id)
);

-- Transactions table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer_in', 'transfer_out', 'interest', 'fee') NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    reference_number VARCHAR(50),
    related_transaction_id INT,
    status ENUM('pending', 'completed', 'failed', 'reversed') DEFAULT 'completed',
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    INDEX (account_id),
    INDEX (transaction_date),
    INDEX (reference_number)
);

-- Transfers table (for tracking transfers between accounts)
CREATE TABLE transfers (
    transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    from_account_id INT NOT NULL,
    to_account_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference VARCHAR(100),
    status ENUM('pending', 'completed', 'failed', 'reversed') DEFAULT 'completed',
    from_transaction_id INT,
    to_transaction_id INT,
    FOREIGN KEY (from_account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (from_transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (to_transaction_id) REFERENCES transactions(transaction_id)
);

-- Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_id INT NOT NULL,
    loan_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    term_months INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    monthly_payment DECIMAL(15,2) NOT NULL,
    remaining_balance DECIMAL(15,2) NOT NULL,
    status ENUM('active', 'paid', 'defaulted') DEFAULT 'active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
