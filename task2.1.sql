-- BigQuery SQL
-- Task 2.1: Number each transaction per user based on purchase date

SELECT
  *, 
  ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY purchase_date
  ) AS transaction_number
FROM
  `testtask-459616.test_dataset.file1`;
