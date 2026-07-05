-- ============================================================
-- SpendWise - Sample Data
-- Version: 1.0
-- Phase: 2 - Database Design
-- ============================================================

USE spendwise_db;

-- ============================================================
-- ROLES
-- ============================================================
INSERT INTO roles (name, description) VALUES
('ROLE_ADMIN', 'System Administrator with full access'),
('ROLE_USER',  'Standard user with personal finance access');

-- ============================================================
-- USERS
-- Password is BCrypt of 'password123'
-- ============================================================
INSERT INTO users (full_name, email, password, is_active, is_verified) VALUES
('Arafat Hossain', 'arafat@email.com',
 '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/GKrJc3uMu', 1, 1),
('Admin User',     'admin@spendwise.com',
 '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/GKrJc3uMu', 1, 1);

-- ============================================================
-- USER ROLES
-- ============================================================
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 2),
(2, 1),
(2, 2);

-- ============================================================
-- USER PROFILES
-- ============================================================
INSERT INTO user_profiles (user_id, phone, university_name, student_id, occupation) VALUES
(1, '01712345678', 'BUET - Bangladesh University of Engineering & Technology', 'STU-2022-001', 'Student'),
(2, '01898765432', NULL, NULL, 'System Administrator');

-- ============================================================
-- USER SETTINGS
-- ============================================================
INSERT INTO user_settings (
    user_id, currency, currency_symbol, theme,
    budget_warning_percent, budget_alert_percent, budget_limit_percent,
    monthly_budget_limit
) VALUES
(1, 'BDT', '৳', 'LIGHT', 70, 90, 100, 20000.00),
(2, 'BDT', '৳', 'LIGHT', 70, 90, 100, 50000.00);

-- ============================================================
-- INCOME CATEGORIES
-- ============================================================
INSERT INTO income_categories (user_id, name, icon, color, is_default) VALUES
(1, 'Part-time Job',    'fa-briefcase',      '#10B981', 0),
(1, 'Freelancing',      'fa-laptop-code',    '#3B82F6', 0),
(1, 'Family Allowance', 'fa-home',           '#6C63FF', 0),
(1, 'Scholarship',      'fa-graduation-cap', '#F59E0B', 0),
(1, 'Other Income',     'fa-plus-circle',    '#9CA3AF', 1);

-- ============================================================
-- EXPENSE CATEGORIES (with subcategories)
-- ============================================================
INSERT INTO expense_categories (user_id, parent_id, name, icon, color, is_default) VALUES
-- Parent Categories
(1, NULL, 'Home',       'fa-home',           '#6C63FF', 1),
(1, NULL, 'Food',       'fa-utensils',       '#F59E0B', 1),
(1, NULL, 'University', 'fa-graduation-cap', '#3B82F6', 1),
(1, NULL, 'Travel',     'fa-bus',            '#10B981', 1),
(1, NULL, 'Others',     'fa-ellipsis-h',     '#9CA3AF', 1),
-- Food Subcategories (parent_id = 2)
(1, 2,    'Groceries',   'fa-shopping-basket','#F59E0B', 0),
(1, 2,    'Restaurant',  'fa-coffee',         '#EF4444', 0),
(1, 2,    'Snacks',      'fa-cookie',         '#FB923C', 0),
-- Travel Subcategories (parent_id = 4)
(1, 4,    'Bus Fare',    'fa-bus',            '#10B981', 0),
(1, 4,    'Rickshaw',    'fa-bicycle',        '#34D399', 0),
-- Home Subcategories (parent_id = 1)
(1, 1,    'Rent',        'fa-building',       '#8B5CF6', 0),
(1, 1,    'Internet',    'fa-wifi',           '#6C63FF', 0),
(1, 1,    'Electricity', 'fa-bolt',           '#FCD34D', 0);

-- ============================================================
-- INCOMES - January 2025
-- ============================================================
INSERT INTO incomes (user_id, category_id, title, amount, income_date, payment_method) VALUES
(1, 3, 'Family Monthly Allowance',   15000.00, '2025-01-01', 'BKASH'),
(1, 1, 'Part-time Tutoring - Week1',  2000.00, '2025-01-07', 'CASH'),
(1, 1, 'Part-time Tutoring - Week2',  2000.00, '2025-01-14', 'CASH'),
(1, 4, 'Scholarship Installment',     5000.00, '2025-01-10', 'BANK'),
(1, 2, 'Freelance Web Design',        3000.00, '2025-01-20', 'BKASH');

-- ============================================================
-- EXPENSES - January 2025
-- ============================================================
INSERT INTO expenses (user_id, category_id, subcategory_id, title, amount, expense_date, payment_method) VALUES
-- Food expenses
(1, 2, 6,    'Vegetables and Fruits',   500.00, '2025-01-15', 'CASH'),
(1, 2, 7,    'Lunch with friends',      350.00, '2025-01-14', 'CASH'),
(1, 2, 8,    'Evening Snacks',           80.00, '2025-01-08', 'CASH'),
-- Travel expenses
(1, 4, 9,    'Campus to Home Bus',       60.00, '2025-01-12', 'CASH'),
(1, 4, 10,   'Rickshaw to Market',       40.00, '2025-01-16', 'CASH'),
-- Home expenses
(1, 1, 11,   'January Rent',           6000.00, '2025-01-12', 'BANK'),
(1, 1, 12,   'WiFi Bill',               700.00, '2025-01-10', 'BKASH'),
-- University expenses
(1, 3, NULL, 'Semester Fee',           5000.00, '2025-01-09', 'BANK'),
(1, 3, NULL, 'DSA Book Purchase',       650.00, '2025-01-14', 'CASH'),
-- Others
(1, 5, NULL, 'Notes Printing',          120.00, '2025-01-09', 'CASH');

-- ============================================================
-- BUDGET - January 2025
-- ============================================================
INSERT INTO budgets (user_id, month, year, total_budget, total_spent, total_remaining, total_savings) VALUES
(1, 1, 2025, 20000.00, 12450.00, 7550.00, 3200.00);

-- ============================================================
-- BUDGET CATEGORIES
-- ============================================================
INSERT INTO budget_categories (budget_id, user_id, category_id, allocated_amount, spent_amount, remaining_amount) VALUES
(1, 1, 1, 6000.00, 5000.00,  1000.00),  -- Home: 83%
(1, 1, 2, 6000.00, 3125.00,  2875.00),  -- Food: 52%
(1, 1, 4, 2000.00, 1250.00,   750.00),  -- Travel: 62%
(1, 1, 3, 8000.00, 7200.00,   800.00),  -- University: 90% ← ALERT
(1, 1, 5, 3000.00, 1875.00,  1125.00);  -- Others: 63%

-- ============================================================
-- SAVINGS GOALS
-- ============================================================
INSERT INTO savings_goals (user_id, title, target_amount, saved_amount, color, target_date, status, priority) VALUES
(1, 'New Laptop',      50000.00, 15000.00, '#6C63FF', '2025-06-30', 'ACTIVE', 'HIGH'),
(1, 'Emergency Fund',  20000.00,  8000.00, '#10B981', '2025-12-31', 'ACTIVE', 'HIGH'),
(1, 'New Phone',       30000.00,  5000.00, '#F59E0B', '2025-09-30', 'ACTIVE', 'MEDIUM');

-- ============================================================
-- SAVINGS TRANSACTIONS
-- ============================================================
INSERT INTO savings_transactions (goal_id, user_id, amount, transaction_type, note, transaction_date) VALUES
(1, 1, 5000.00, 'DEPOSIT',    'Initial savings for laptop',   '2024-11-01'),
(1, 1, 5000.00, 'DEPOSIT',    'November savings',             '2024-11-30'),
(1, 1, 5000.00, 'DEPOSIT',    'December savings',             '2024-12-31'),
(2, 1, 3000.00, 'DEPOSIT',    'Emergency fund start',         '2024-12-01'),
(2, 1, 3000.00, 'DEPOSIT',    'Emergency fund January',       '2025-01-31'),
(2, 1, 2000.00, 'DEPOSIT',    'Emergency extra saving',       '2025-01-15'),
(3, 1, 5000.00, 'DEPOSIT',    'Phone savings start',          '2025-01-01');

-- ============================================================
-- UNIVERSITY CATEGORIES
-- ============================================================
INSERT INTO university_categories (user_id, name, icon, color, is_default) VALUES
(1, 'Tuition Fee',         'fa-university',      '#3B82F6', 1),
(1, 'Books & Materials',   'fa-book',            '#6C63FF', 1),
(1, 'Printing & Photocopy','fa-print',           '#F59E0B', 1),
(1, 'Stationery',          'fa-pen',             '#10B981', 1),
(1, 'Lab Fees',            'fa-flask',           '#EF4444', 0),
(1, 'Other Academic Costs','fa-ellipsis-h',      '#9CA3AF', 1);

-- ============================================================
-- UNIVERSITY EXPENSES - Spring 2025
-- ============================================================
INSERT INTO university_expenses (
    user_id, category_id, title, amount,
    semester, academic_year, expense_date, payment_status, payment_method
) VALUES
(1, 1, 'Tuition Fee - Spring 2025',       15000.00, 'Spring 2025', '2024-25', '2025-01-09', 'PAID',    'BANK'),
(1, 2, 'DSA Textbook',                     2500.00, 'Spring 2025', '2024-25', '2025-01-14', 'PAID',    'CASH'),
(1, 3, 'Assignment Printing',               800.00, 'Spring 2025', '2024-25', '2025-01-09', 'PAID',    'CASH'),
(1, 4, 'Stationery Supplies',               600.00, 'Spring 2025', '2024-25', '2025-01-10', 'PENDING', 'CASH'),
(1, 6, 'Other Academic Costs',             1000.00, 'Spring 2025', '2024-25', '2025-01-20', 'PENDING', 'CASH');

-- ============================================================
-- MONTHLY REPORTS
-- ============================================================
INSERT INTO monthly_reports (
    user_id, month, year,
    total_income, total_expense, total_savings,
    total_budget, budget_used_percent, net_balance, top_category
) VALUES
(1, 8,  2024, 18000.00, 16500.00, 1500.00, 18000.00, 91.67,  1500.00,  'Home'),
(1, 9,  2024, 19000.00, 14000.00, 5000.00, 19000.00, 73.68,  5000.00,  'University'),
(1, 10, 2024, 20000.00, 15500.00, 4500.00, 20000.00, 77.50,  4500.00,  'Home'),
(1, 11, 2024, 22000.00, 14500.00, 7500.00, 20000.00, 72.50,  7500.00,  'Food'),
(1, 12, 2024, 21000.00, 15200.00, 5800.00, 20000.00, 76.00,  5800.00,  'Home'),
(1, 1,  2025, 27000.00, 12450.00, 3200.00, 20000.00, 62.25,  14550.00, 'University');

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
INSERT INTO notifications (user_id, title, message, type, is_read, action_url) VALUES
(1,
 '⚠️ University Budget Alert',
 'You have used 90% of your University budget. Please manage your expenses carefully.',
 'BUDGET_ALERT', 0, '/budget'),
(1,
 '🎯 Laptop Goal Progress',
 'You are 30% of the way to your New Laptop goal! Keep saving!',
 'GOAL_REMINDER', 1, '/goals'),
(1,
 '💰 Monthly Budget Set',
 'Your January 2025 budget of ৳20,000 has been set successfully.',
 'SYSTEM', 1, '/budget'),
(1,
 '🎓 Tuition Fee Due',
 'Your Spring 2025 Tuition Fee payment is due. Please make the payment.',
 'UNIVERSITY_DUE', 0, '/university');

-- ============================================================
-- CALENDAR EVENTS
-- ============================================================
INSERT INTO calendar_events (user_id, title, event_type, amount, event_date, is_recurring, recurring_type, color) VALUES
(1, 'Family Allowance Day',     'INCOME',         15000.00, '2025-01-01', 1, 'MONTHLY',  '#10B981'),
(1, 'Rent Due',                 'BILL_DUE',        6000.00, '2025-01-12', 1, 'MONTHLY',  '#EF4444'),
(1, 'WiFi Bill',                'BILL_DUE',         700.00, '2025-01-10', 1, 'MONTHLY',  '#F59E0B'),
(1, 'Tutoring Payment',         'INCOME',          2000.00, '2025-01-07', 1, 'WEEKLY',   '#10B981'),
(1, 'Semester Fee Deadline',    'UNIVERSITY_FEE', 15000.00, '2025-01-15', 0,  NULL,       '#3B82F6'),
(1, 'Laptop Goal Deadline',     'GOAL_DEADLINE',  50000.00, '2025-06-30', 0,  NULL,       '#6C63FF');

-- ============================================================
-- AUDIT LOGS
-- ============================================================
INSERT INTO audit_logs (user_id, action, entity_type, entity_id, ip_address, status) VALUES
(1, 'USER_REGISTER', 'USER',    1, '192.168.1.1', 'SUCCESS'),
(1, 'USER_LOGIN',    'USER',    1, '192.168.1.1', 'SUCCESS'),
(1, 'EXPENSE_CREATE','EXPENSE', 1, '192.168.1.1', 'SUCCESS'),
(1, 'BUDGET_CREATE', 'BUDGET',  1, '192.168.1.1', 'SUCCESS'),
(1, 'GOAL_CREATE',   'GOAL',    1, '192.168.1.1', 'SUCCESS');
