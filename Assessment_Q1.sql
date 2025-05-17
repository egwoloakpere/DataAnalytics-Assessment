SELECT 
	uc.id AS owner_id,  
    CONCAT(uc.first_name, ' ', uc.last_name) AS name, #Since the name column is NULL, we join the first and last name to get the full name using concat
    COUNT(DISTINCT 
				CASE 
					WHEN pp.is_regular_savings = 1 AND ss.confirmed_amount > 0 THEN pp.id
				END) AS savings_count, #Here, We count the unique funded savings plan 
	COUNT(DISTINCT 
				CASE
					WHEN pp.is_a_fund = 1 AND ss.confirmed_amount > 0 THEN pp.id
				END) AS investment_count, #Here, We count the unique funded investment plan 
	ROUND(SUM(CASE 
				  WHEN ss.confirmed_amount > 0 THEN ss.confirmed_amount
			  END) / 100, 2) AS total_deposits #We use case statement here to ensure we calculate only deposits with actual value. We also converted kobo to naira and rounded to 2 Decimal point 
FROM 
	users_customuser uc
JOIN 
	plans_plan pp
ON uc.id = pp.owner_id 
JOIN 
	savings_savingsaccount ss
ON pp.id = ss.plan_id 
WHERE 
	pp.is_deleted = 0 #This ensures we display only active accounts. We can ignore this if we also want inactive accounts.
GROUP BY
	uc.id, name
HAVING 
	savings_count > 0 AND
    investment_count > 0 #We ensure only users with at least 1 savings and investment plan is displayed in our final result
ORDER BY 
	total_deposits DESC; 