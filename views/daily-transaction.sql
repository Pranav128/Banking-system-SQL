-- Daily transaction summary
CREATE VIEW daily_transaction_summary AS
SELECT
    DATE(transaction_date) AS transaction_day,
    transaction_type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM
    transactions
WHERE
    status = 'completed'
GROUP BY
    DATE(transaction_date), transaction_type
ORDER BY
    DATE(transaction_date) DESC;
