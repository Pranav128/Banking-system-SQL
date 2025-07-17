DELIMITER //
CREATE EVENT monthly_interest_calculation
ON SCHEDULE EVERY 1 MONTH
STARTS TIMESTAMP(DATE_FORMAT(DATE_ADD(CURRENT_DATE, INTERVAL 1 MONTH), '%Y-%m-01 00:00:00')
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_account_id INT;
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_type_id INT;
    DECLARE v_interest_rate DECIMAL(5,2);
    DECLARE v_interest_amount DECIMAL(15,2);

    -- Cursor for accounts with interest-bearing accounts
    DECLARE account_cursor CURSOR FOR
        SELECT a.account_id, a.current_balance, a.type_id, at.interest_rate
        FROM accounts a
        JOIN account_types at ON a.type_id = at.type_id
        WHERE at.interest_rate > 0 AND a.status = 'active';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN account_cursor;

    account_loop: LOOP
        FETCH account_cursor INTO v_account_id, v_balance, v_type_id, v_interest_rate;
        IF done THEN
            LEAVE account_loop;
        END IF;

        -- Calculate monthly interest (simple interest for example)
        SET v_interest_amount = ROUND(v_balance * (v_interest_rate / 100 / 12), 2);

        -- Only apply interest if it's more than $0.01
        IF v_interest_amount >= 0.01 THEN
            -- Record the interest calculation
            INSERT INTO interest_calculations (
                account_id,
                calculation_date,
                interest_rate,
                principal_balance,
                interest_amount
            )
            VALUES (
                v_account_id,
                CURRENT_DATE,
                v_interest_rate,
                v_balance,
                v_interest_amount
            );

            -- Create the interest transaction
            INSERT INTO transactions (
                account_id,
                transaction_type,
                amount,
                description
            )
            VALUES (
                v_account_id,
                'interest',
                v_interest_amount,
                CONCAT('Monthly interest at ', v_interest_rate, '%')
            );
        END IF;
    END LOOP;

    CLOSE account_cursor;
END //
DELIMITER ;
