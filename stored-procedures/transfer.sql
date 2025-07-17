-- Procedure to transfer money between accounts
DELIMITER //
CREATE PROCEDURE transfer_money(
    IN p_from_account_id INT,
    IN p_to_account_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_description TEXT
)
BEGIN
    DECLARE v_from_balance DECIMAL(15,2);
    DECLARE v_from_min_balance DECIMAL(15,2);
    DECLARE v_from_customer_id INT;
    DECLARE v_to_customer_id INT;
    DECLARE v_transfer_id INT;
    DECLARE v_from_transaction_id INT;
    DECLARE v_to_transaction_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Verify accounts belong to the same customer (optional)
    SELECT customer_id INTO v_from_customer_id FROM accounts WHERE account_id = p_from_account_id;
    SELECT customer_id INTO v_to_customer_id FROM accounts WHERE account_id = p_to_account_id;

    -- Get from account balance and minimum balance requirement
    SELECT a.current_balance, at.minimum_balance INTO v_from_balance, v_from_min_balance
    FROM accounts a
    JOIN account_types at ON a.type_id = at.type_id
    WHERE a.account_id = p_from_account_id
    FOR UPDATE;

    -- Check if transfer would go below minimum balance
    IF (v_from_balance - p_amount) < v_from_min_balance THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transfer would make source account go below minimum balance requirement';
    END IF;

    -- Create transfer record
    INSERT INTO transfers (from_account_id, to_account_id, amount, reference, status)
    VALUES (p_from_account_id, p_to_account_id, p_amount, p_description, 'pending');

    SET v_transfer_id = LAST_INSERT_ID();

    -- Create withdrawal transaction
    INSERT INTO transactions (account_id, transaction_type, amount, description, status)
    VALUES (p_from_account_id, 'transfer_out', p_amount, p_description, 'completed');

    SET v_from_transaction_id = LAST_INSERT_ID();

    -- Create deposit transaction
    INSERT INTO transactions (account_id, transaction_type, amount, description, status)
    VALUES (p_to_account_id, 'transfer_in', p_amount, p_description, 'completed');

    SET v_to_transaction_id = LAST_INSERT_ID();

    -- Update transfer record with transaction IDs
    UPDATE transfers
    SET from_transaction_id = v_from_transaction_id,
        to_transaction_id = v_to_transaction_id,
        status = 'completed'
    WHERE transfer_id = v_transfer_id;

    -- Update from account balance
    UPDATE accounts
    SET current_balance = current_balance - p_amount,
        last_activity_date = CURRENT_DATE
    WHERE account_id = p_from_account_id;

    -- Update to account balance
    UPDATE accounts
    SET current_balance = current_balance + p_amount,
        last_activity_date = CURRENT_DATE
    WHERE account_id = p_to_account_id;

    COMMIT;
END //
DELIMITER ;
