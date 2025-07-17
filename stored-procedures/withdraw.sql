-- Procedure to withdraw money
DELIMITER //
CREATE PROCEDURE make_withdrawal(
    IN p_account_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_description TEXT
)
BEGIN
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_min_balance DECIMAL(15,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Get current balance and minimum balance requirement
    SELECT a.current_balance, at.minimum_balance INTO v_balance, v_min_balance
    FROM accounts a
    JOIN account_types at ON a.type_id = at.type_id
    WHERE a.account_id = p_account_id
    FOR UPDATE;

    -- Check if withdrawal would go below minimum balance
    IF (v_balance - p_amount) < v_min_balance THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Withdrawal would go below minimum balance requirement';
    END IF;

    -- Add the transaction record
    INSERT INTO transactions (account_id, transaction_type, amount, description, status)
    VALUES (p_account_id, 'withdrawal', p_amount, p_description, 'completed');

    -- Update account balance
    UPDATE accounts
    SET current_balance = current_balance - p_amount,
        last_activity_date = CURRENT_DATE
    WHERE account_id = p_account_id;

    COMMIT;
END //
DELIMITER ;
