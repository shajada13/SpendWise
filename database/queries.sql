-- ============================================================
-- SpendWise — Useful SQL Queries Reference
-- ============================================================

USE spendwise_db;

-- -----------------------------------------------
-- DASHBOARD QUERIES
-- -----------------------------------------------

-- 1. Total budget for current month
SELECT SUM(amount) AS total_budget
FROM budgets
WHERE user_id = 1 AND month = 1 AND year = 2025;

-- 2. Total spent for current month
SELECT SUM(amount) AS total_spent
FROM expenses
WHERE user_id = 1 AND month = 1 AND year = 2025;

-- 3. Remaining balance
SELECT
    (SELECT SUM(amount) FROM budgets  WHERE user_id=1 AND month=1 AND year=2025)
  - (SELECT SUM(amount) FROM expenses WHERE user_id=1 AND month=1 AND year=2025)
  AS remaining;

-- 4. Spending per category (current month)
SELECT
    c.name          AS category,
    c.color_hex,
    COALESCE(SUM(e.amount), 0) AS spent,
    b.amount        AS budget,
    ROUND((COALESCE(SUM(e.amount),0) / b.amount) * 100, 1) AS percent_used
FROM categories c
LEFT JOIN expenses e
    ON c.id = e.category_id
    AND e.user_id = 1 AND e.month = 1 AND e.year = 2025
LEFT JOIN budgets b
    ON c.id = b.category_id
    AND b.user_id = 1 AND b.month = 1 AND b.year = 2025
GROUP BY c.id, c.name, c.color_hex, b.amount
ORDER BY spent DESC;

-- 5. Recent 5 transactions
SELECT
    e.id,
    c.name          AS category,
    c.icon,
    e.subcategory,
    e.amount,
    e.description,
    e.payment_method,
    e.expense_date
FROM expenses e
JOIN categories c ON e.category_id = c.id
WHERE e.user_id = 1
ORDER BY e.expense_date DESC, e.created_at DESC
LIMIT 5;

-- -----------------------------------------------
-- EXPENSE HISTORY QUERIES
-- -----------------------------------------------

-- 6. All expenses with optional month/category filter
SELECT
    e.id,
    c.name          AS category,
    c.icon,
    e.subcategory,
    e.amount,
    e.description,
    e.payment_method,
    e.expense_date
FROM expenses e
JOIN categories c ON e.category_id = c.id
WHERE e.user_id = 1
  AND (1 = 0 OR e.month = 1)          -- swap 1=0 to skip filter
  AND (1 = 0 OR e.category_id = 1)    -- swap 1=0 to skip filter
ORDER BY e.expense_date DESC;

-- -----------------------------------------------
-- ANALYTICS QUERIES
-- -----------------------------------------------

-- 7. Monthly spending trend (last 6 months)
SELECT
    month,
    year,
    SUM(amount) AS total_spent
FROM expenses
WHERE user_id = 1
  AND (year = 2025 AND month <= 1
       OR year = 2024 AND month >= 8)
GROUP BY year, month
ORDER BY year ASC, month ASC;

-- 8. Category distribution (pie chart data)
SELECT
    c.name,
    c.color_hex,
    SUM(e.amount) AS total
FROM expenses e
JOIN categories c ON e.category_id = c.id
WHERE e.user_id = 1 AND e.month = 1 AND e.year = 2025
GROUP BY c.id, c.name, c.color_hex
ORDER BY total DESC;

-- 9. Budget vs Actual per category (bar chart)
SELECT
    c.name,
    COALESCE(b.amount, 0)          AS budget,
    COALESCE(SUM(e.amount), 0)     AS spent
FROM categories c
LEFT JOIN budgets b
    ON c.id = b.category_id
    AND b.user_id = 1 AND b.month = 1 AND b.year = 2025
LEFT JOIN expenses e
    ON c.id = e.category_id
    AND e.user_id = 1 AND e.month = 1 AND e.year = 2025
GROUP BY c.id, c.name, b.amount;

-- -----------------------------------------------
-- BUDGET ALERT QUERIES
-- -----------------------------------------------

-- 10. Check categories needing 90% alert
SELECT
    b.id,
    c.name,
    b.amount                        AS budget,
    COALESCE(SUM(e.amount), 0)      AS spent,
    ROUND((COALESCE(SUM(e.amount),0) / b.amount)*100, 1) AS pct
FROM budgets b
JOIN categories c ON b.category_id = c.id
LEFT JOIN expenses e
    ON b.user_id = e.user_id
    AND b.category_id = e.category_id
    AND b.month = e.month AND b.year = e.year
WHERE b.user_id = 1
  AND b.month = 1 AND b.year = 2025
  AND b.alert_90_sent = 0
GROUP BY b.id, c.name, b.amount
HAVING pct >= 90;

-- -----------------------------------------------
-- UNIVERSITY QUERIES
-- -----------------------------------------------

-- 11. Semester summary
SELECT
    expense_type,
    SUM(amount)     AS total,
    status
FROM university_expenses
WHERE user_id = 1 AND semester = 'Spring 2025'
GROUP BY expense_type, status;

-- 12. Total semester cost
SELECT
    SUM(amount)         AS total_cost,
    SUM(CASE WHEN status='Paid'    THEN amount ELSE 0 END) AS paid,
    SUM(CASE WHEN status='Pending' THEN amount ELSE 0 END) AS pending
FROM university_expenses
WHERE user_id = 1 AND semester = 'Spring 2025';

-- -----------------------------------------------
-- GOALS QUERIES
-- -----------------------------------------------

-- 13. All active goals with progress %
SELECT
    id,
    goal_name,
    target_amount,
    current_amount,
    ROUND((current_amount / target_amount) * 100, 1) AS progress_pct,
    deadline,
    icon,
    status
FROM goals
WHERE user_id = 1 AND status = 'Active'
ORDER BY progress_pct DESC;

-- -----------------------------------------------
-- NOTIFICATIONS QUERIES
-- -----------------------------------------------

-- 14. Unread notifications for user
SELECT id, title, message, alert_type, created_at
FROM notifications
WHERE user_id = 1 AND is_read = 0
ORDER BY created_at DESC;

-- 15. Mark notification as read
UPDATE notifications
SET is_read = 1
WHERE id = 1 AND user_id = 1;

