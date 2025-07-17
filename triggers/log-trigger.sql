DELIMITER //
CREATE TRIGGER transaction_audit
AFTER UPDATE ON transactions
FOR EACH ROW
BEGIN
    -- Only log if amount or status changed
    IF NEW.amount != OLD.amount OR NEW.status != OLD.status THEN
        INSERT INTO transaction_audit_log (
            transaction_id,
            account_id,
            action_type, 
            old_amount,
            new_amount,
            old_status,
            new_status,
            changed_by
        )
        VALUES (
            NEW.transaction_id,
            NEW.account_id,
            'UPDATE',
            OLD.amount,
            NEW.amount,
            OLD.status,
            NEW.status,
            CURRENT_USER()
        );
    END IF;
END //
DELIMITER ;
