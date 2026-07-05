-- ============================================================
-- SpendWise - Database Documentation
-- Version: 1.0
-- Phase: 2 - Database Design
-- ============================================================

/*
====================================================================
DATABASE: spendwise_db
CHARACTER SET: utf8mb4 (supports Bengali & emoji)
COLLATION: utf8mb4_unicode_ci
NORMAL FORM: Third Normal Form (3NF)
====================================================================

TABLE SUMMARY
====================================================================
#   Table Name              Purpose                         Rows (Sample)
--------------------------------------------------------------------
1   roles                   System roles                    2
2   users                   Authentication / Login          2
3   user_roles              User ↔ Role mapping             3
4   user_profiles           Extended user info              2
5   user_settings           User preferences                2
6   income_categories       Income category types           5
7   incomes                 All income records              5
8   expense_categories      Expense types + subcategories   13
9   expenses                All expense records             10
10  budgets                 Monthly budget plans            1
11  budget_categories       Per-category budget allocation  5
12  savings_goals           Savings targets                 3
13  savings_transactions    Deposits/withdrawals per goal   7
14  university_categories   University expense types        6
15  university_expenses     University-related expenses     5
16  monthly_reports         Pre-aggregated monthly data     6
17  notifications           User notifications              4
18  calendar_events         Financial calendar entries      6
19  audit_logs              Security audit trail            5
====================================================================

RELATIONSHIPS
====================================================================

users (1) ─────────────── (N) user_roles (N) ─── (1) roles
users (1) ─────────────── (1) user_profiles
users (1) ─────────────── (1) user_settings
users (1) ─────────────── (N) income_categories
users (1) ─────────────── (N) incomes
              income_categories (1) ── (N) incomes

users (1) ─────────────── (N) expense_categories (self-ref for subcategory)
users (1) ─────────────── (N) expenses
              expense_categories (1) ── (N) expenses (category)
              expense_categories (1) ── (N) expenses (subcategory)

users (1) ─────────────── (N) budgets
              budgets (1) ── (N) budget_categories
              expense_categories (1) ── (N) budget_categories

users (1) ─────────────── (N) savings_goals
              savings_goals (1) ── (N) savings_transactions

users (1) ─────────────── (N) university_categories
users (1) ─────────────── (N) university_expenses
              university_categories (1) ── (N) university_expenses

users (1) ─────────────── (N) monthly_reports
users (1) ─────────────── (N) notifications
users (1) ─────────────── (N) calendar_events
users (1) ─────────────── (N) audit_logs

====================================================================

SOFT DELETE SUPPORT
====================================================================
Tables with soft delete (deleted_at column):
- users
- incomes
- expenses
- expense_categories
- income_categories
- savings_goals
- university_expenses
- notifications
- calendar_events

When deleted_at IS NOT NULL → record is soft deleted
All queries should include WHERE deleted_at IS NULL

====================================================================

INDEXES SUMMARY
====================================================================
Table               Index Column(s)             Purpose
--------------------------------------------------------------------
users               email                       Login lookup
users               is_active, deleted_at       Filter active users
incomes             user_id, income_date         User expense queries
expenses            user_id, expense_date        User expense queries
expenses            category_id                 Category filter
budget_categories   budget_id, user_id           Budget queries
savings_goals       user_id, status              Goal filter
university_expenses user_id, semester           Semester filter
notifications       user_id, is_read            Unread count
calendar_events     user_id, event_date         Date range query
audit_logs          user_id, entity_type        Security queries
monthly_reports     user_id, year, month        Analytics queries

====================================================================

DATA TYPES USED
====================================================================
BIGINT          → All primary keys and foreign keys
VARCHAR(n)      → Names, emails, URLs, tokens
TEXT            → Descriptions, notes, messages
DECIMAL(15,2)   → All monetary amounts (precision)
DATE            → Event dates, birth dates
DATETIME        → Timestamps (created_at, updated_at)
TINYINT(1)      → Boolean flags (0/1)
INT             → Month, year, percentages
ENUM            → Fixed options (status, type, method)
JSON            → Audit log old/new values

====================================================================

CONSTRAINTS
====================================================================
- All amounts: CHECK (amount > 0)
- Month: CHECK (month BETWEEN 1 AND 12)
- Year:  CHECK (year  BETWEEN 2000 AND 2100)
- Unique: users.email, budgets(user_id, month, year)
- Cascade DELETE on user_id FKs (delete user = delete data)
- RESTRICT on category FKs (cannot delete used category)
- SET NULL on audit_log user_id (keep logs even if user deleted)

====================================================================

PAYMENT METHODS SUPPORTED
====================================================================
CASH, BANK, BKASH, NAGAD, ROCKET, CARD, OTHER

====================================================================

NOTIFICATION TYPES
====================================================================
BUDGET_WARNING   → 70% budget used
BUDGET_ALERT     → 90% budget used
BUDGET_EXCEEDED  → 100% budget used
GOAL_ACHIEVED    → Savings goal reached
GOAL_REMINDER    → Goal deadline approaching
UNIVERSITY_DUE   → University fee due
SYSTEM           → System messages
GENERAL          → General notifications

====================================================================

VIEWS CREATED
====================================================================
vw_dashboard_summary        → Dashboard summary per user
vw_expense_by_category      → Expense grouped by category
vw_recent_transactions      → Combined income + expense list
vw_budget_category_status   → Budget status with % and alert level
vw_savings_progress         → Goal progress with % and days left
vw_university_summary       → University expenses per semester
vw_monthly_trend            → Last 6 months analytics data

====================================================================
*/
