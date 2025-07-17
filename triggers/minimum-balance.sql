DELIMITER //
CREATE TRIGGER before_withdrawal_transfer
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE v_current_balance DECIMAL(15,2);
    DECLARE v_min_balance DECIMAL(15,2);
    DECLARE v_account_status VARCHAR(20);

    -- Only check for withdrawal or transfer out transactions
    IF NEW.transaction_type IN ('withdrawal', 'transfer_out') THEN
        -- Get current balance, minimum balance, and account status
        SELECT a.current_balance, at.minimum_balance, a.status
        INTO v_current_balance, v_min_balance, v_account_status
        FROM accounts a
        JOIN account_types at ON a.type_id = at.type_id
        WHERE a.account_id = NEW.account_id;

        -- Check if account is active
        IF v_account_status != 'active' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot perform transaction on inactive account';
        END IF;

        -- Check if withdrawal would go below minimum balance
        IF (v_current_balance - NEW.amount) < v_min_balance THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transaction would violate minimum balance requirement';
        END IF;
    END IF;
END //
DELIMITER ;
