-- ============================================================
-- SpendWise - Views & Useful Queries
-- Version: 1.0
-- Phase: 2 - Database Design
-- ============================================================

USE spendwise_db;

-- ============================================================
-- VIEW 1: Dashboard Summary per User per Month
-- ============================================================
CREATE OR REPLACE VIEW vw_dashboard_summary AS
SELECT
    u.id                                        AS user_id,
    u.full_name,
    MONTH(CURDATE())                            AS current_month,
    YEAR(CURDATE())                             AS current_year,
    COALESCE(b.total_budget, 0)                 AS total_budget,
    COALESCE(b.total_spent, 0)                  AS total_spent,
    COALESCE(b.total_remaining, 0)              AS total_remaining,
    COALESCE(b.total_savings, 0)                AS total_savings,
    CASE
        WHEN b.total_budget > 0
        THEN ROUND((b.total_spent / b.total_budget) * 100, 2)
        ELSE 0
    END                                         AS budget_used_percent
FROM users u
LEFT JOIN budgets b
    ON b.user_id = u.id
    AND b.month  = MONTH(CURDATE())
    AND b.year   = YEAR(CURDATE())
WHERE u.deleted_at IS NULL;

-- ============================================================
-- VIEW 2: Expense Summary by Category per User per Month
-- ============================================================
CREATE OR REPLACE VIEW vw_expense_by_category AS
SELECT
    e.user_id,
    ec.id                           AS category_id,
    ec.name                         AS category_name,
    ec.color                        AS category_color,
    MONTH(e.expense_date)           AS month,
    YEAR(e.expense_date)            AS year,
    COUNT(e.id)                     AS total_transactions,
    SUM(e.amount)                   AS total_amount
FROM expenses e
JOIN expense_categories ec ON ec.id = e.category_id
WHERE e.deleted_at IS NULL
GROUP BY e.user_id, ec.id, ec.name, ec.color,
         MONTH(e.expense_date), YEAR(e.expense_date);

-- ============================================================
-- VIEW 3: Recent Transactions (Expense + Income combined)
-- ============================================================
CREATE OR REPLACE VIEW vw_recent_transactions AS
SELECT
    'EXPENSE'                   AS transaction_type,
    e.id,
    e.user_id,
    ec.name                     AS category_name,
    ec.color                    AS category_color,
    ec.icon                     AS category_icon,
    e.title                     AS description,
    e.amount,
    e.expense_date              AS transaction_date,
    e.payment_method,
    e.created_at
FROM expenses e
JOIN expense_categories ec ON ec.id = e.category_id
WHERE e.deleted_at IS NULL

UNION ALL

SELECT
    'INCOME'                    AS transaction_type,
    i.id,
    i.user_id,
    ic.name                     AS category_name,
    ic.color                    AS category_color,
    ic.icon                     AS category_icon,
    i.title                     AS description,
    i.amount,
    i.income_date               AS transaction_date,
    i.payment_method,
    i.created_at
FROM incomes i
JOIN income_categories ic ON ic.id = i.category_id
WHERE i.deleted_at IS NULL;

-- ============================================================
-- VIEW 4: Budget Status per Category
-- ============================================================
CREATE OR REPLACE VIEW vw_budget_category_status AS
SELECT
    bc.id,
    bc.budget_id,
    bc.user_id,
    b.month,
    b.year,
    ec.name                             AS category_name,
    ec.color                            AS category_color,
    ec.icon                             AS category_icon,
    bc.allocated_amount,
    bc.spent_amount,
    bc.remaining_amount,
    ROUND((bc.spent_amount / bc.allocated_amount) * 100, 2)
                                        AS used_percent,
    CASE
        WHEN (bc.spent_amount / bc.allocated_amount) >= 1.0   THEN 'EXCEEDED'
        WHEN (bc.spent_amount / bc.allocated_amount) >= 0.9   THEN 'CRITICAL'
        WHEN (bc.spent_amount / bc.allocated_amount) >= 0.7   THEN 'WARNING'
        ELSE                                                        'NORMAL'
    END                                 AS budget_status
FROM budget_categories bc
JOIN budgets b           ON b.id  = bc.budget_id
JOIN expense_categories ec ON ec.id = bc.category_id;

-- ============================================================
-- VIEW 5: Savings Goals Progress
-- ============================================================
CREATE OR REPLACE VIEW vw_savings_progress AS
SELECT
    sg.id,
    sg.user_id,
    sg.title,
    sg.target_amount,
    sg.saved_amount,
    sg.target_date,
    sg.status,
    sg.priority,
    ROUND((sg.saved_amount / sg.target_amount) * 100, 2)   AS progress_percent,
    (sg.target_amount - sg.saved_amount)                    AS remaining_amount,
    DATEDIFF(sg.target_date, CURDATE())                     AS days_remaining
FROM savings_goals sg
WHERE sg.deleted_at IS NULL;

-- ============================================================
-- VIEW 6: University Expense Summary per Semester
-- ============================================================
CREATE OR REPLACE VIEW vw_university_summary AS
SELECT
    ue.user_id,
    ue.semester,
    ue.academic_year,
    COUNT(ue.id)                                AS total_items,
    SUM(ue.amount)                              AS total_cost,
    SUM(CASE WHEN ue.payment_status = 'PAID'    THEN ue.amount ELSE 0 END) AS paid_amount,
    SUM(CASE WHEN ue.payment_status = 'PENDING' THEN ue.amount ELSE 0 END) AS pending_amount,
    SUM(CASE WHEN ue.payment_status = 'OVERDUE' THEN ue.amount ELSE 0 END) AS overdue_amount
FROM university_expenses ue
WHERE ue.deleted_at IS NULL
GROUP BY ue.user_id, ue.semester, ue.academic_year;

-- ============================================================
-- VIEW 7: Monthly Spending Trend (last 6 months)
-- ============================================================
CREATE OR REPLACE VIEW vw_monthly_trend AS
SELECT
    user_id,
    year,
    month,
    total_income,
    total_expense,
    total_savings,
    budget_used_percent,
    net_balance
FROM monthly_reports
ORDER BY year DESC, month DESC;
