SELECT 
    uc.id AS customer_id,
    CONCAT(uc.first_name, ' ', uc.last_name) AS name, 
    TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()) AS tenure_months, #we use Timestampdiff to calculate the difference between two dates. In this case, in months
    COUNT(ss.id) AS total_transactions,
    ROUND((COUNT(ss.id) / NULLIF(TIMESTAMPDIFF(MONTH, uc.date_joined, CURDATE()), 0)) * 12 * #We use NULLIF here to avoid division by zero incase tenure month is zero
        (0.001 * AVG(ss.confirmed_amount) / 100), 2 #We divide the confirmed amount by 100 to convert from kobo to naira and round up to 2 decimal point. profit per transaction here is 0.001(0.1%)
    ) AS estimated_clv 
FROM 
    users_customuser AS uc
LEFT JOIN 
    savings_savingsaccount AS ss #We use left join here to ensure we include all customers, even those without savings
ON uc.id = ss.owner_id AND ss.confirmed_amount > 0 #Since we want only the inflow, we set confirmed amount > 0
GROUP BY 
    customer_id, name
ORDER BY 
    estimated_clv DESC;
