-- Distribution of financing Amounts

SELECT 
    loan_amount, 
    COUNT(*) AS frequency
FROM 
    finance
GROUP BY 
    loan_amount
ORDER BY 
    loan_amount;

-- Relationship Between Loan Duration and Interest Rates

SELECT 
    loan_term_months, 
    interest_rate
FROM 
    finance
ORDER BY 
    loan_term_months, 
    interest_rate;

-- Consultant-Wise Analysis
-- Total Sales Per Consultant

SELECT 
    consultant_id, 
    SUM(sale_price) AS total_sales
FROM 
    sales
GROUP BY 
    consultant_id
ORDER BY 
    total_sales DESC;

-- Total Profit Per Consultant

SELECT 
    consultant_id, 
    SUM(profit) AS total_profit
FROM 
    sales
GROUP BY 
    consultant_id
ORDER BY 
    total_profit DESC;

-- Customer Credit Score Distribution

SELECT 
    credit_score, 
    COUNT(*) AS frequency
FROM 
    customers
GROUP BY 
    credit_score
ORDER BY 
    credit_score;

-- Consultant Performance: Evaluate Sales Performance Tied To Financing Metrics

-- Financed Amount Per Consultant

SELECT 
    s.consultant_id, 
    SUM(f.loan_amount) AS total_financed_amount
FROM 
    sales s
JOIN 
    finance f ON s.customer_id = f.customer_id
GROUP BY 
    s.consultant_id
ORDER BY 
    total_financed_amount DESC;

-- Total Sales and Profit Per Consultant

SELECT 
    consultant_id, 
    SUM(sale_price) AS total_sales, 
    SUM(profit) AS total_profit
FROM 
    sales
GROUP BY 
    consultant_id
ORDER BY 
    total_sales DESC, total_profit DESC;

-- Customer Insights: Segment Customers Based On financing Patterns

-- High0Value Loan (Top 10%)

WITH LoanPercentiles AS (
    SELECT 
        f.customer_id,
        f.loan_amount,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY f.loan_amount) 
            OVER () AS percentile_90
    FROM 
        finance f
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    lp.loan_amount
FROM 
    customers c
JOIN 
    LoanPercentiles lp ON c.customer_id = lp.customer_id
WHERE 
    lp.loan_amount > lp.percentile_90
ORDER BY 
    lp.loan_amount DESC;

-- Customers At Risk (Low Credit Score And High Debt-To-Income Ratio)

SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.credit_score, 
    c.debt_to_income_ratio
FROM 
    customers c
WHERE 
    c.credit_score < 600 
    AND c.debt_to_income_ratio > 0.5
ORDER BY 
    c.credit_score, c.debt_to_income_ratio DESC;

-- Financial Insights: Trends In Interest rates, Loan Durations, And Payments

-- Interest Rates And Loan Duration Trends

SELECT 
    loan_term_months, 
    AVG(interest_rate) AS avg_interest_rate
FROM 
    finance
GROUP BY 
    loan_term_months
ORDER BY 
    loan_term_months;

-- Monthly Payment Distribution

SELECT 
    monthly_payment, 
    COUNT(*) AS frequency
FROM 
    finance
GROUP BY 
    monthly_payment
ORDER BY 
    frequency DESC;
