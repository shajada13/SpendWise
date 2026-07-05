-- ============================================================
-- SpendWise - Complete MySQL Database Schema
-- Version: 1.0
-- Phase: 2 - Database Design
-- Standard: Third Normal Form (3NF)
-- ============================================================

CREATE DATABASE IF NOT EXISTS spendwise_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE spendwise_db;

-- ============================================================
-- SECTION 1: AUTHENTICATION TABLES
-- ============================================================

-- ------------------------------------------------------------
-- Table: roles
-- Purpose: Stores system roles (ADMIN, USER)
-- ------------------------------------------------------------
CREATE TABLE roles (
    id          BIGINT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50)     NOT NULL,
    description VARCHAR(255)    DEFAULT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_roles PRIMARY KEY (id),
    CONSTRAINT uq_roles_name UNIQUE (name)
);

-- ------------------------------------------------------------
-- Table: users
-- Purpose: Core authentication table, stores login credentials
-- ------------------------------------------------------------
CREATE TABLE users (
    id                  BIGINT          NOT NULL AUTO_INCREMENT,
    full_name           VARCHAR(100)    NOT NULL,
    email               VARCHAR(150)    NOT NULL,
    password            VARCHAR(255)    NOT NULL,
    is_active           TINYINT(1)      NOT NULL DEFAULT 1,
    is_verified         TINYINT(1)      NOT NULL DEFAULT 0,
    last_login_at       DATETIME        DEFAULT NULL,
    password_reset_token VARCHAR(255)   DEFAULT NULL,
    token_expiry_at     DATETIME        DEFAULT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME        DEFAULT NULL,

    CONSTRAINT pk_users PRIMARY KEY (id),
    CONSTRAINT uq_users_email UNIQUE (email)
);

CREATE INDEX idx_users_email     ON users (email);
CREATE INDEX idx_users_is_active ON users (is_active);
CREATE INDEX idx_users_deleted_at ON users (deleted_at);

-- ------------------------------------------------------------
-- Table: user_roles
-- Purpose: Many-to-Many mapping between users and roles
-- ------------------------------------------------------------
CREATE TABLE user_roles (
    user_id     BIGINT  NOT NULL,
    role_id     BIGINT  NOT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_user_roles    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_ur_user_id    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_ur_role_id    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- ============================================================
-- SECTION 2: USER PROFILE & SETTINGS
-- ============================================================

-- ------------------------------------------------------------
-- Table: user_profiles
-- Purpose: Extended user information beyond authentication
-- ------------------------------------------------------------
CREATE TABLE user_profiles (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    phone           VARCHAR(20)     DEFAULT NULL,
    avatar_url      VARCHAR(500)    DEFAULT NULL,
    date_of_birth   DATE            DEFAULT NULL,
    gender          ENUM('MALE','FEMALE','OTHER') DEFAULT NULL,
    occupation      VARCHAR(100)    DEFAULT NULL,
    university_name VARCHAR(200)    DEFAULT NULL,
    student_id      VARCHAR(50)     DEFAULT NULL,
    bio             TEXT            DEFAULT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_user_profiles     PRIMARY KEY (id),
    CONSTRAINT uq_user_profiles_uid UNIQUE (user_id),
    CONSTRAINT fk_up_user_id        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Table: user_settings
-- Purpose: User preferences (currency, theme, notifications)
-- ------------------------------------------------------------
CREATE TABLE user_settings (
    id                          BIGINT          NOT NULL AUTO_INCREMENT,
    user_id                     BIGINT          NOT NULL,
    currency                    VARCHAR(10)     NOT NULL DEFAULT 'BDT',
    currency_symbol             VARCHAR(5)      NOT NULL DEFAULT '৳',
    theme                       ENUM('LIGHT','DARK') NOT NULL DEFAULT 'LIGHT',
    language                    VARCHAR(10)     NOT NULL DEFAULT 'en',
    notification_email          TINYINT(1)      NOT NULL DEFAULT 1,
    notification_budget_alert   TINYINT(1)      NOT NULL DEFAULT 1,
    notification_goal_alert     TINYINT(1)      NOT NULL DEFAULT 1,
    budget_warning_percent      INT             NOT NULL DEFAULT 70,
    budget_alert_percent        INT             NOT NULL DEFAULT 90,
    budget_limit_percent        INT             NOT NULL DEFAULT 100,
    monthly_budget_limit        DECIMAL(15,2)   DEFAULT NULL,
    created_at                  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_user_settings     PRIMARY KEY (id),
    CONSTRAINT uq_user_settings_uid UNIQUE (user_id),
    CONSTRAINT fk_us_user_id        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- SECTION 3: INCOME MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: income_categories
-- Purpose: Categories for income entries
-- ------------------------------------------------------------
CREATE TABLE income_categories (
    id          BIGINT          NOT NULL AUTO_INCREMENT,
    user_id     BIGINT          NOT NULL,
    name        VARCHAR(100)    NOT NULL,
    icon        VARCHAR(100)    DEFAULT 'fa-money-bill',
    color       VARCHAR(20)     DEFAULT '#10B981',
    is_default  TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME        DEFAULT NULL,

    CONSTRAINT pk_income_categories PRIMARY KEY (id),
    CONSTRAINT fk_ic_user_id        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_income_categories_user ON income_categories (user_id);

-- ------------------------------------------------------------
-- Table: incomes
-- Purpose: All income records per user
-- ------------------------------------------------------------
CREATE TABLE incomes (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    category_id     BIGINT          NOT NULL,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT            DEFAULT NULL,
    amount          DECIMAL(15,2)   NOT NULL,
    income_date     DATE            NOT NULL,
    payment_method  ENUM('CASH','BANK','BKASH','NAGAD','ROCKET','CARD','OTHER')
                                    NOT NULL DEFAULT 'BANK',
    reference_no    VARCHAR(100)    DEFAULT NULL,
    is_recurring    TINYINT(1)      NOT NULL DEFAULT 0,
    recurring_type  ENUM('DAILY','WEEKLY','MONTHLY','YEARLY') DEFAULT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME        DEFAULT NULL,

    CONSTRAINT pk_incomes       PRIMARY KEY (id),
    CONSTRAINT fk_inc_user_id   FOREIGN KEY (user_id)     REFERENCES users(id)             ON DELETE CASCADE,
    CONSTRAINT fk_inc_cat_id    FOREIGN KEY (category_id) REFERENCES income_categories(id)  ON DELETE RESTRICT,
    CONSTRAINT chk_income_amt   CHECK (amount > 0)
);

CREATE INDEX idx_incomes_user_id    ON incomes (user_id);
CREATE INDEX idx_incomes_date       ON incomes (income_date);
CREATE INDEX idx_incomes_category   ON incomes (category_id);
CREATE INDEX idx_incomes_deleted    ON incomes (deleted_at);

-- ============================================================
-- SECTION 4: EXPENSE MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: expense_categories
-- Purpose: Categories for expense entries (with subcategory support)
-- ------------------------------------------------------------
CREATE TABLE expense_categories (
    id          BIGINT          NOT NULL AUTO_INCREMENT,
    user_id     BIGINT          NOT NULL,
    parent_id   BIGINT          DEFAULT NULL,
    name        VARCHAR(100)    NOT NULL,
    icon        VARCHAR(100)    DEFAULT 'fa-receipt',
    color       VARCHAR(20)     DEFAULT '#6C63FF',
    is_default  TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME        DEFAULT NULL,

    CONSTRAINT pk_expense_categories    PRIMARY KEY (id),
    CONSTRAINT fk_ec_user_id            FOREIGN KEY (user_id)   REFERENCES users(id)              ON DELETE CASCADE,
    CONSTRAINT fk_ec_parent_id          FOREIGN KEY (parent_id) REFERENCES expense_categories(id)  ON DELETE SET NULL
);

CREATE INDEX idx_expense_categories_user   ON expense_categories (user_id);
CREATE INDEX idx_expense_categories_parent ON expense_categories (parent_id);

-- ------------------------------------------------------------
-- Table: expenses
-- Purpose: All expense records per user
-- ------------------------------------------------------------
CREATE TABLE expenses (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    category_id     BIGINT          NOT NULL,
    subcategory_id  BIGINT          DEFAULT NULL,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT            DEFAULT NULL,
    amount          DECIMAL(15,2)   NOT NULL,
    expense_date    DATE            NOT NULL,
    payment_method  ENUM('CASH','BANK','BKASH','NAGAD','ROCKET','CARD','OTHER')
                                    NOT NULL DEFAULT 'CASH',
    reference_no    VARCHAR(100)    DEFAULT NULL,
    receipt_url     VARCHAR(500)    DEFAULT NULL,
    is_recurring    TINYINT(1)      NOT NULL DEFAULT 0,
    recurring_type  ENUM('DAILY','WEEKLY','MONTHLY','YEARLY') DEFAULT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME        DEFAULT NULL,

    CONSTRAINT pk_expenses          PRIMARY KEY (id),
    CONSTRAINT fk_exp_user_id       FOREIGN KEY (user_id)        REFERENCES users(id)              ON DELETE CASCADE,
    CONSTRAINT fk_exp_cat_id        FOREIGN KEY (category_id)    REFERENCES expense_categories(id)  ON DELETE RESTRICT,
    CONSTRAINT fk_exp_subcat_id     FOREIGN KEY (subcategory_id) REFERENCES expense_categories(id)  ON DELETE SET NULL,
    CONSTRAINT chk_expense_amt      CHECK (amount > 0)
);

CREATE INDEX idx_expenses_user_id   ON expenses (user_id);
CREATE INDEX idx_expenses_date      ON expenses (expense_date);
CREATE INDEX idx_expenses_category  ON expenses (category_id);
CREATE INDEX idx_expenses_deleted   ON expenses (deleted_at);

-- ============================================================
-- SECTION 5: BUDGET MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: budgets
-- Purpose: Monthly budget plan per user
-- ------------------------------------------------------------
CREATE TABLE budgets (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    month           INT             NOT NULL,
    year            INT             NOT NULL,
    total_budget    DECIMAL(15,2)   NOT NULL,
    total_spent     DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    total_remaining DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    total_savings   DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    notes           TEXT            DEFAULT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_budgets           PRIMARY KEY (id),
    CONSTRAINT uq_budgets_user_month UNIQUE (user_id, month, year),
    CONSTRAINT fk_bud_user_id       FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_budget_month     CHECK (month BETWEEN 1 AND 12),
    CONSTRAINT chk_budget_year      CHECK (year BETWEEN 2000 AND 2100),
    CONSTRAINT chk_total_budget     CHECK (total_budget > 0)
);

CREATE INDEX idx_budgets_user_id ON budgets (user_id);
CREATE INDEX idx_budgets_year    ON budgets (year, month);

-- ------------------------------------------------------------
-- Table: budget_categories
-- Purpose: Per-category budget allocation within a monthly budget
-- ------------------------------------------------------------
CREATE TABLE budget_categories (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    budget_id       BIGINT          NOT NULL,
    user_id         BIGINT          NOT NULL,
    category_id     BIGINT          NOT NULL,
    allocated_amount DECIMAL(15,2)  NOT NULL,
    spent_amount    DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    remaining_amount DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    alert_sent      TINYINT(1)      NOT NULL DEFAULT 0,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_budget_categories     PRIMARY KEY (id),
    CONSTRAINT uq_budget_category       UNIQUE (budget_id, category_id),
    CONSTRAINT fk_bc_budget_id          FOREIGN KEY (budget_id)   REFERENCES budgets(id)            ON DELETE CASCADE,
    CONSTRAINT fk_bc_user_id            FOREIGN KEY (user_id)     REFERENCES users(id)              ON DELETE CASCADE,
    CONSTRAINT fk_bc_category_id        FOREIGN KEY (category_id) REFERENCES expense_categories(id)  ON DELETE RESTRICT,
    CONSTRAINT chk_bc_allocated         CHECK (allocated_amount > 0)
);

CREATE INDEX idx_budget_categories_budget ON budget_categories (budget_id);
CREATE INDEX idx_budget_categories_user   ON budget_categories (user_id);

-- ============================================================
-- SECTION 6: SAVINGS GOALS MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: savings_goals
-- Purpose: User savings targets with progress tracking
-- ------------------------------------------------------------
CREATE TABLE savings_goals (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT            DEFAULT NULL,
    target_amount   DECIMAL(15,2)   NOT NULL,
    saved_amount    DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    icon_url        VARCHAR(500)    DEFAULT NULL,
    color           VARCHAR(20)     DEFAULT '#6C63FF',
    target_date     DATE            DEFAULT NULL,
    status          ENUM('ACTIVE','COMPLETED','CANCELLED','PAUSED')
                                    NOT NULL DEFAULT 'ACTIVE',
    priority        ENUM('LOW','MEDIUM','HIGH') NOT NULL DEFAULT 'MEDIUM',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME        DEFAULT NULL,

    CONSTRAINT pk_savings_goals     PRIMARY KEY (id),
    CONSTRAINT fk_sg_user_id        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_sg_target        CHECK (target_amount > 0),
    CONSTRAINT chk_sg_saved         CHECK (saved_amount >= 0)
);

CREATE INDEX idx_savings_goals_user   ON savings_goals (user_id);
CREATE INDEX idx_savings_goals_status ON savings_goals (status);

-- ------------------------------------------------------------
-- Table: savings_transactions
-- Purpose: Individual deposits/withdrawals toward a savings goal
-- ------------------------------------------------------------
CREATE TABLE savings_transactions (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    goal_id         BIGINT          NOT NULL,
    user_id         BIGINT          NOT NULL,
    amount          DECIMAL(15,2)   NOT NULL,
    transaction_type ENUM('DEPOSIT','WITHDRAWAL') NOT NULL DEFAULT 'DEPOSIT',
    note            TEXT            DEFAULT NULL,
    transaction_date DATE           NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_savings_tx        PRIMARY KEY (id),
    CONSTRAINT fk_st_goal_id        FOREIGN KEY (goal_id)  REFERENCES savings_goals(id) ON DELETE CASCADE,
    CONSTRAINT fk_st_user_id        FOREIGN KEY (user_id)  REFERENCES users(id)         ON DELETE CASCADE,
    CONSTRAINT chk_st_amount        CHECK (amount > 0)
);

CREATE INDEX idx_savings_tx_goal ON savings_transactions (goal_id);
CREATE INDEX idx_savings_tx_user ON savings_transactions (user_id);
CREATE INDEX idx_savings_tx_date ON savings_transactions (transaction_date);

-- ============================================================
-- SECTION 7: UNIVERSITY MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: university_categories
-- Purpose: Categories specific to university-related expenses
-- ------------------------------------------------------------
CREATE TABLE university_categories (
    id          BIGINT          NOT NULL AUTO_INCREMENT,
    user_id     BIGINT          NOT NULL,
    name        VARCHAR(100)    NOT NULL,
    icon        VARCHAR(100)    DEFAULT 'fa-graduation-cap',
    color       VARCHAR(20)     DEFAULT '#F59E0B',
    is_default  TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_university_categories PRIMARY KEY (id),
    CONSTRAINT fk_uc_user_id            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_univ_categories_user ON university_categories (user_id);

-- ------------------------------------------------------------
-- Table: university_expenses
-- Purpose: University-specific expense tracking per semester
-- ------------------------------------------------------------
CREATE TABLE university_expenses (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    category_id     BIGINT          NOT NULL,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT            DEFAULT NULL,
    amount          DECIMAL(15,2)   NOT NULL,
    semester        VARCHAR(50)     NOT NULL,
    academic_year   VARCHAR(20)     NOT NULL,
    expense_date    DATE            NOT NULL,
    payment_status  ENUM('PAID','PENDING','OVERDUE') NOT NULL DEFAULT 'PENDING',
    payment_method  ENUM('CASH','BANK','BKASH','NAGAD','ROCKET','CARD','OTHER')
                                    NOT NULL DEFAULT 'CASH',
    receipt_url     VARCHAR(500)    DEFAULT NULL,
    due_date        DATE            DEFAULT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME        DEFAULT NULL,

    CONSTRAINT pk_university_expenses   PRIMARY KEY (id),
    CONSTRAINT fk_ue_user_id            FOREIGN KEY (user_id)     REFERENCES users(id)                  ON DELETE CASCADE,
    CONSTRAINT fk_ue_category_id        FOREIGN KEY (category_id) REFERENCES university_categories(id)   ON DELETE RESTRICT,
    CONSTRAINT chk_ue_amount            CHECK (amount > 0)
);

CREATE INDEX idx_univ_expenses_user     ON university_expenses (user_id);
CREATE INDEX idx_univ_expenses_semester ON university_expenses (semester, academic_year);
CREATE INDEX idx_univ_expenses_status   ON university_expenses (payment_status);
CREATE INDEX idx_univ_expenses_deleted  ON university_expenses (deleted_at);

-- ============================================================
-- SECTION 8: ANALYTICS MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: monthly_reports
-- Purpose: Pre-aggregated monthly summary for fast analytics
-- ------------------------------------------------------------
CREATE TABLE monthly_reports (
    id                  BIGINT          NOT NULL AUTO_INCREMENT,
    user_id             BIGINT          NOT NULL,
    month               INT             NOT NULL,
    year                INT             NOT NULL,
    total_income        DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    total_expense       DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    total_savings       DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    total_budget        DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    budget_used_percent DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    net_balance         DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    top_category        VARCHAR(100)    DEFAULT NULL,
    notes               TEXT            DEFAULT NULL,
    generated_at        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_monthly_reports       PRIMARY KEY (id),
    CONSTRAINT uq_monthly_reports_user  UNIQUE (user_id, month, year),
    CONSTRAINT fk_mr_user_id            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_mr_month             CHECK (month BETWEEN 1 AND 12),
    CONSTRAINT chk_mr_year              CHECK (year BETWEEN 2000 AND 2100)
);

CREATE INDEX idx_monthly_reports_user ON monthly_reports (user_id);
CREATE INDEX idx_monthly_reports_year ON monthly_reports (year, month);

-- ============================================================
-- SECTION 9: NOTIFICATIONS MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: notifications
-- Purpose: System and user notifications
-- ------------------------------------------------------------
CREATE TABLE notifications (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    title           VARCHAR(200)    NOT NULL,
    message         TEXT            NOT NULL,
    type            ENUM(
                        'BUDGET_WARNING',
                        'BUDGET_ALERT',
                        'BUDGET_EXCEEDED',
                        'GOAL_ACHIEVED',
                        'GOAL_REMINDER',
                        'UNIVERSITY_DUE',
                        'SYSTEM',
                        'GENERAL'
                    ) NOT NULL DEFAULT 'GENERAL',
    is_read         TINYINT(1)      NOT NULL DEFAULT 0,
    read_at         DATETIME        DEFAULT NULL,
    action_url      VARCHAR(500)    DEFAULT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME        DEFAULT NULL,

    CONSTRAINT pk_notifications     PRIMARY KEY (id),
    CONSTRAINT fk_notif_user_id     FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_notifications_user    ON notifications (user_id);
CREATE INDEX idx_notifications_is_read ON notifications (is_read);
CREATE INDEX idx_notifications_type    ON notifications (type);

-- ============================================================
-- SECTION 10: CALENDAR MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: calendar_events
-- Purpose: Financial events on calendar (bill due, salary day etc.)
-- ------------------------------------------------------------
CREATE TABLE calendar_events (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT            DEFAULT NULL,
    event_date      DATE            NOT NULL,
    event_type      ENUM(
                        'EXPENSE',
                        'INCOME',
                        'BILL_DUE',
                        'SALARY',
                        'UNIVERSITY_FEE',
                        'GOAL_DEADLINE',
                        'REMINDER',
                        'OTHER'
                    ) NOT NULL DEFAULT 'REMINDER',
    amount          DECIMAL(15,2)   DEFAULT NULL,
    is_completed    TINYINT(1)      NOT NULL DEFAULT 0,
    is_recurring    TINYINT(1)      NOT NULL DEFAULT 0,
    recurring_type  ENUM('DAILY','WEEKLY','MONTHLY','YEARLY') DEFAULT NULL,
    color           VARCHAR(20)     DEFAULT '#6C63FF',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      DATETIME        DEFAULT NULL,

    CONSTRAINT pk_calendar_events   PRIMARY KEY (id),
    CONSTRAINT fk_ce_user_id        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_calendar_events_user ON calendar_events (user_id);
CREATE INDEX idx_calendar_events_date ON calendar_events (event_date);

-- ============================================================
-- SECTION 11: SYSTEM MODULE
-- ============================================================

-- ------------------------------------------------------------
-- Table: audit_logs
-- Purpose: Track all important user actions for security
-- ------------------------------------------------------------
CREATE TABLE audit_logs (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          DEFAULT NULL,
    action          VARCHAR(100)    NOT NULL,
    entity_type     VARCHAR(100)    NOT NULL,
    entity_id       BIGINT          DEFAULT NULL,
    old_value       JSON            DEFAULT NULL,
    new_value       JSON            DEFAULT NULL,
    ip_address      VARCHAR(50)     DEFAULT NULL,
    user_agent      VARCHAR(500)    DEFAULT NULL,
    status          ENUM('SUCCESS','FAILURE') NOT NULL DEFAULT 'SUCCESS',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_audit_logs    PRIMARY KEY (id),
    CONSTRAINT fk_al_user_id    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_audit_logs_user        ON audit_logs (user_id);
CREATE INDEX idx_audit_logs_entity      ON audit_logs (entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at  ON audit_logs (created_at);
