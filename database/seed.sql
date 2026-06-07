-- ============================================================
-- SpendWise — Seed Data
-- Run AFTER schema.sql
-- ============================================================

USE spendwise_db;

-- ============================================================
-- SEED: categories (fixed master data)
-- ============================================================
INSERT INTO categories (id, name, icon, color_hex) VALUES
(1, 'Food',        'bi-cup-hot-fill',       '#f97316'),
(2, 'Home',        'bi-house-fill',         '#6366f1'),
(3, 'Travel',      'bi-bus-front-fill',     '#06b6d4'),
(4, 'University',  'bi-mortarboard-fill',   '#8b5cf6'),
(5, 'Others',      'bi-three-dots',         '#64748b');


-- ============================================================
-- SEED: demo user (password = 'password123' BCrypt hashed)
-- ============================================================
INSERT INTO users (id, full_name, email, password, currency, theme) VALUES
(1,
 'Arafat Hossain',
 'arafat@email.com',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhy8',
 'BDT',
 'light'
);


-- ============================================================
-- SEED: budgets for January 2025
-- ============================================================
INSERT INTO budgets (user_id, category_id, amount, month, year) VALUES
(1, 1, 6000.00,  1, 2025),   -- Food
(1, 2, 6000.00,  1, 2025),   -- Home
(1, 3, 2000.00,  1, 2025),   -- Travel
(1, 4, 8000.00,  1, 2025),   -- University
(1, 5, 3000.00,  1, 2025);   -- Others


-- ============================================================
-- SEED: sample expenses for January 2025
-- ============================================================
INSERT INTO expenses
    (user_id, category_id, subcategory, amount, description,
     payment_method, expense_date, month, year)
VALUES
(1, 1, 'Groceries',       500.00, 'Vegetables and fruits',   'Cash',  '2025-01-15', 1, 2025),
(1, 4, 'Books',           650.00, 'DSA Book',                'Cash',  '2025-01-14', 1, 2025),
(1, 3, 'Bus Fare',         60.00, 'Campus to Home',          'Cash',  '2025-01-13', 1, 2025),
(1, 2, 'Rent',           6000.00, 'January Rent',            'Bank',  '2025-01-12', 1, 2025),
(1, 5, 'Internet',        700.00, 'WiFi Bill',               'Bkash', '2025-01-10', 1, 2025),
(1, 4, 'Tuition Fee',    5000.00, 'Semester Fee',            'Bank',  '2025-01-09', 1, 2025),
(1, 5, 'Printing',        120.00, 'Notes Printing',          'Cash',  '2025-01-08', 1, 2025),
(1, 1, 'Snacks',           80.00, 'Evening Snacks',          'Cash',  '2025-01-07', 1, 2025),
(1, 3, 'Rickshaw',         45.00, 'Market trip',             'Cash',  '2025-01-06', 1, 2025),
(1, 1, 'Lunch',           350.00, 'Lunch and snacks',        'Cash',  '2025-01-05', 1, 2025),
(1, 1, 'Dinner',          280.00, 'Restaurant',              'Cash',  '2025-01-04', 1, 2025),
(1, 3, 'CNG',             200.00, 'Trip to market',          'Cash',  '2025-01-03', 1, 2025),
(1, 5, 'Stationery',      165.00, 'Pen and notebook',        'Cash',  '2025-01-02', 1, 2025);


-- ============================================================
-- SEED: university expenses Spring 2025
-- ============================================================
INSERT INTO university_expenses
    (user_id, semester, expense_type, amount, description,
     status, expense_date, month, year)
VALUES
(1, 'Spring 2025', 'Tuition Fee',           15000.00, 'Spring semester tuition',  'Paid',    '2025-01-09', 1, 2025),
(1, 'Spring 2025', 'Books',                  2500.00, 'Textbooks and references', 'Paid',    '2025-01-14', 1, 2025),
(1, 'Spring 2025', 'Printing & Photocopy',    800.00, 'Lecture notes printing',   'Paid',    '2025-01-08', 1, 2025),
(1, 'Spring 2025', 'Stationery',              600.00, 'Stationery supplies',      'Pending', '2025-01-20', 1, 2025),
(1, 'Spring 2025', 'Other Academic',         1000.00, 'Lab fees',                 'Pending', '2025-01-25', 1, 2025);


-- ============================================================
-- SEED: savings goals
-- ============================================================
INSERT INTO goals
    (user_id, goal_name, target_amount, current_amount, deadline, icon, status)
VALUES
(1, 'New Laptop',      50000.00, 15000.00, '2025-06-30', 'bi-laptop',       'Active'),
(1, 'Emergency Fund',  20000.00,  8000.00, '2025-12-31', 'bi-shield-check', 'Active'),
(1, 'New Phone',       30000.00,  5000.00, '2025-09-30', 'bi-phone',        'Active');


-- ============================================================
-- SEED: notifications
-- ============================================================
INSERT INTO notifications (user_id, budget_id, title, message, alert_type, is_read)
VALUES
(1, 4,
 '90% University Budget Used',
 'You have used 90% of your University budget for January 2025. Please manage your expenses carefully.',
 '90_PERCENT', 0),
(1, NULL,
 'Welcome to SpendWise!',
 'Your account is set up. Start by adding your monthly budgets and tracking your expenses.',
 'INFO', 1);

