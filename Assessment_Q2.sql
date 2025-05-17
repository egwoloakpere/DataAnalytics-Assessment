# This solution is splitted into 3 parts
WITH monthly_transaction AS
(
	SELECT 
		uc.id AS customer_id,
        COUNT(ss.id) AS transaction_count,
		DATE_FORMAT(ss.transaction_date, '%Y-%m') AS month_year
	FROM 
		users_customuser uc
	JOIN
		savings_savingsaccount ss 
	ON uc.id = ss.owner_id
	GROUP BY
		uc.id, month_year
), #This first CTE calculates the count of the monthly transactions
avg_transaction AS
(
	 SELECT 
		customer_id,
		avg(transaction_count) AS avg_transaction_per_month
	FROM
		monthly_transaction
	GROUP BY
    customer_id
) #This second CTE calculates the average monthly transaction
SELECT 
	CASE 
		WHEN avg_transaction_per_month >= 10 THEN "High frequency"
        WHEN avg_transaction_per_month BETWEEN 3 AND 9 THEN "Medium frequency"
        ELSE "Low frequency"
	END AS frequency_category, #We use CASE statement here to split teansaction frequency into different categories
	COUNT(customer_id) AS customer_count,
	ROUND(avg(avg_transaction_per_month), 1) AS avg_transaction_per_month 
FROM 
	avg_transaction
GROUP BY 
	frequency_category
ORDER BY
	FIELD(frequency_category, 'High frequency', 'Medium frequency', 'Low frequency'); #FIELD enables us sort our categories based on our preference. Unlike the regular alphabetic sort