SELECT 
	pp.id AS plan_id,
    pp.owner_id AS owner_id,
    CASE
		WHEN pp.is_regular_savings = 1 THEN 'Savings'
        WHEN pp.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
	END AS type, 
    MAX(ss.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(ss.transaction_date)) AS inactivity_days
FROM 
	plans_plan pp
LEFT JOIN savings_savingsaccount ss #We use left join here to ensure we include all plans, even those without transactions
ON pp.id = ss.plan_id AND ss.confirmed_amount > 0 #Since we want only the inflow, we set confirmed amount > 0
WHERE 
	pp.is_deleted = 0 
GROUP BY
	pp.id, pp.owner_id, type
HAVING 
	MAX(ss.transaction_date) IS NULL OR #This ensures we display only inactive accounts
    DATEDIFF(CURRENT_DATE(), MAX(ss.transaction_date)) > 365 #This ensures we display only accounts that has been inactive for over 365 days
ORDER BY 
    inactivity_days DESC;