-- BigQuery SQL
-- Task 2.0: Calculate the conversion rate from trial to second payment (rebill)

-- Step 1: Filter only purchases with 9.99 subscription and non-refunded
WITH filtered_purchases AS (
  SELECT
    user_id,
    purchase_date,
    refunded
  FROM
    `testtask-459616.test_dataset.file1`
  WHERE
    product_id = 'tenwords_1w_9.99_offer'
    AND refunded = FALSE
),

-- Step 2: Number purchases per user 
ranked_purchases AS (
  SELECT
    user_id,
    purchase_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY purchase_date) AS purchase_number
  FROM
    filtered_purchases
),

-- Step 3: Identify users who reached their second payment 
converted_users AS (
  SELECT
    user_id
  FROM
    ranked_purchases
  WHERE
    purchase_number = 2
),

-- Step 4: Identify all users who made at least one non-refunded payment
all_first_time_users AS (
  SELECT DISTINCT
    user_id
  FROM
    ranked_purchases
  WHERE
    purchase_number = 1
)

-- Step 5: Calculate conversion rate
SELECT
  SAFE_DIVIDE(COUNT(DISTINCT c.user_id), COUNT(DISTINCT a.user_id)) AS conversion_rate_to_second_payment
FROM
  all_first_time_users a
LEFT JOIN
  converted_users c
ON
  a.user_id = c.user_id;
