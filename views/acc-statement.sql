-- Account statement view
CREATE VIEW account_statements AS
SELECT
    a.account_id,
    a.account_number,
    c.first_name,
    c.last_name,
    t.transaction_id,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    t.description,
    a.current_balance
FROM
    accounts a
JOIN
    customers c ON a.customer_id = c.customer_id
JOIN
    transactions t ON a.account_id = t.account_id
ORDER BY
    a.account_id, t.transaction_date DESC;
