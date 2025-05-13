-- BigQuery SQL
-- Task 2.2: Identify users whose first transaction was not refunded, 
-- but their second transaction was refunded

-- Step 1: Number all transactions per user by purchase date
WITH numbered_transactions AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY purchase_date
    ) AS transaction_number
  FROM
    `testtask-459616.test_dataset.file1`
),

-- Step 2: Receive refund status of the first and second transaction for each user
first_and_second AS (
  SELECT
    user_id,
    MAX(CASE WHEN transaction_number = 1 THEN refunded END) AS first_refunded,
    MAX(CASE WHEN transaction_number = 2 THEN refunded END) AS second_refunded
  FROM
    numbered_transactions
  WHERE
    transaction_number IN (1, 2)
  GROUP BY
    user_id
)

-- Step 3: Return users with first transaction not refunded and second transaction refunded
SELECT
  user_id
FROM
  first_and_second
WHERE
  first_refunded = FALSE
  AND second_refunded = TRUE;
