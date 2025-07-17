-- Customer account overview
CREATE VIEW customer_account_overview AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(a.account_id) AS account_count,
    SUM(a.current_balance) AS total_balance,
    MAX(a.last_activity_date) AS last_activity
FROM
    customers c
LEFT JOIN
    accounts a ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email;
