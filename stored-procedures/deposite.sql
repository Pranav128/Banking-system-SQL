-- Procedure to deposit money
DELIMITER //
CREATE PROCEDURE make_deposit(
    IN p_account_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_description TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Add the transaction record
    INSERT INTO transactions (account_id, transaction_type, amount, description, status)
    VALUES (p_account_id, 'deposit', p_amount, p_description, 'completed');

    -- Update account balance
    UPDATE accounts
    SET current_balance = current_balance + p_amount,
        last_activity_date = CURRENT_DATE
    WHERE account_id = p_account_id;

    COMMIT;
END //
DELIMITER ;
