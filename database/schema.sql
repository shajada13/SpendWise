-- ============================================================
-- SpendWise - Student Budget & Expense Management System
-- Database Schema
-- Version: 1.0
-- Engine: MySQL 8.0+
-- Character Set: utf8mb4
-- ============================================================

CREATE DATABASE IF NOT EXISTS spendwise_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE spendwise_db;

-- ============================================================
-- TABLE 1: users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    password        VARCHAR(255)    NOT NULL,
    avatar_url      VARCHAR(255)    DEFAULT NULL,
    currency        VARCHAR(10)     NOT NULL DEFAULT 'BDT',
    theme           ENUM('light','dark') NOT NULL DEFAULT 'light',
    is_active       TINYINT(1)      NOT NULL DEFAULT 1,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_users             PRIMARY KEY (id),
    CONSTRAINT uq_users_email       UNIQUE (email)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Stores registered user accounts';

CREATE INDEX idx_users_email     ON users (email);
CREATE INDEX idx_users_is_active ON users (is_active);


-- ============================================================
-- TABLE 2: categories
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    id          INT             NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50)     NOT NULL,
    icon        VARCHAR(50)     NOT NULL DEFAULT 'bi-tag',
    color_hex   VARCHAR(7)      NOT NULL DEFAULT '#6366f1',
    is_active   TINYINT(1)      NOT NULL DEFAULT 1,
    CONSTRAINT pk_categories    PRIMARY KEY (id),
    CONSTRAINT uq_categories_name UNIQUE (name)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Predefined expense categories';


-- ============================================================
-- TABLE 3: expenses
-- ============================================================
CREATE TABLE IF NOT EXISTS expenses (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    category_id     INT             NOT NULL,
    subcategory     VARCHAR(100)    DEFAULT NULL,
    amount          DECIMAL(12,2)   NOT NULL,
    description     VARCHAR(255)    DEFAULT NULL,
    payment_method  ENUM('Cash','Bank','Bkash','Nagad','Card','Other')
                                    NOT NULL DEFAULT 'Cash',
    expense_date    DATE            NOT NULL,
    month           TINYINT         NOT NULL,
    year            SMALLINT        NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_expenses              PRIMARY KEY (id),
    CONSTRAINT fk_expenses_user         FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_expenses_category     FOREIGN KEY (category_id)
        REFERENCES categories(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_expenses_amount      CHECK (amount > 0),
    CONSTRAINT chk_expenses_month       CHECK (month BETWEEN 1 AND 12),
    CONSTRAINT chk_expenses_year        CHECK (year BETWEEN 2000 AND 2100)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Individual expense transactions per user';

CREATE INDEX idx_expenses_user_id     ON expenses (user_id);
CREATE INDEX idx_expenses_category_id ON expenses (category_id);
CREATE INDEX idx_expenses_date        ON expenses (expense_date);
CREATE INDEX idx_expenses_month_year  ON expenses (user_id, month, year);
CREATE INDEX idx_expenses_user_cat    ON expenses (user_id, category_id);


-- ============================================================
-- TABLE 4: budgets
-- ============================================================
CREATE TABLE IF NOT EXISTS budgets (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    category_id     INT             NOT NULL,
    amount          DECIMAL(12,2)   NOT NULL,
    month           TINYINT         NOT NULL,
    year            SMALLINT        NOT NULL,
    alert_70_sent   TINYINT(1)      NOT NULL DEFAULT 0,
    alert_90_sent   TINYINT(1)      NOT NULL DEFAULT 0,
    alert_100_sent  TINYINT(1)      NOT NULL DEFAULT 0,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_budgets                   PRIMARY KEY (id),
    CONSTRAINT uq_budgets_user_cat_month    UNIQUE (user_id, category_id, month, year),
    CONSTRAINT fk_budgets_user              FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_budgets_category          FOREIGN KEY (category_id)
        REFERENCES categories(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_budgets_amount           CHECK (amount > 0),
    CONSTRAINT chk_budgets_month            CHECK (month BETWEEN 1 AND 12),
    CONSTRAINT chk_budgets_year             CHECK (year BETWEEN 2000 AND 2100)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Monthly budget allocations per category per user';

CREATE INDEX idx_budgets_user_id    ON budgets (user_id);
CREATE INDEX idx_budgets_month_year ON budgets (user_id, month, year);
CREATE INDEX idx_budgets_category   ON budgets (category_id);


-- ============================================================
-- TABLE 5: university_expenses
-- ============================================================
CREATE TABLE IF NOT EXISTS university_expenses (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    semester        VARCHAR(50)     NOT NULL,
    expense_type    ENUM(
                        'Tuition Fee',
                        'Books',
                        'Printing & Photocopy',
                        'Stationery',
                        'Other Academic'
                    )               NOT NULL,
    amount          DECIMAL(12,2)   NOT NULL,
    description     VARCHAR(255)    DEFAULT NULL,
    status          ENUM('Paid','Pending') NOT NULL DEFAULT 'Pending',
    expense_date    DATE            NOT NULL,
    month           TINYINT         NOT NULL,
    year            SMALLINT        NOT NULL,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_university_expenses   PRIMARY KEY (id),
    CONSTRAINT fk_university_user       FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_univ_amount          CHECK (amount > 0),
    CONSTRAINT chk_univ_month           CHECK (month BETWEEN 1 AND 12),
    CONSTRAINT chk_univ_year            CHECK (year BETWEEN 2000 AND 2100)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='University and academic expense tracking per semester';

CREATE INDEX idx_univ_user_id    ON university_expenses (user_id);
CREATE INDEX idx_univ_semester   ON university_expenses (user_id, semester);
CREATE INDEX idx_univ_status     ON university_expenses (status);
CREATE INDEX idx_univ_month_year ON university_expenses (user_id, month, year);


-- ============================================================
-- TABLE 6: goals
-- ============================================================
CREATE TABLE IF NOT EXISTS goals (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    goal_name       VARCHAR(100)    NOT NULL,
    target_amount   DECIMAL(12,2)   NOT NULL,
    current_amount  DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    deadline        DATE            DEFAULT NULL,
    icon            VARCHAR(50)     NOT NULL DEFAULT 'bi-piggy-bank',
    status          ENUM('Active','Completed','Cancelled')
                                    NOT NULL DEFAULT 'Active',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_goals             PRIMARY KEY (id),
    CONSTRAINT fk_goals_user        FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_goals_target     CHECK (target_amount > 0),
    CONSTRAINT chk_goals_current    CHECK (current_amount >= 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='User savings goals and progress tracking';

CREATE INDEX idx_goals_user_id ON goals (user_id);
CREATE INDEX idx_goals_status  ON goals (status);


-- ============================================================
-- TABLE 7: notifications
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    user_id         BIGINT          NOT NULL,
    budget_id       BIGINT          DEFAULT NULL,
    title           VARCHAR(150)    NOT NULL,
    message         TEXT            NOT NULL,
    alert_type      ENUM('70_PERCENT','90_PERCENT','100_PERCENT','INFO')
                                    NOT NULL DEFAULT 'INFO',
    is_read         TINYINT(1)      NOT NULL DEFAULT 0,
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_notifications         PRIMARY KEY (id),
    CONSTRAINT fk_notifications_user    FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_notifications_budget  FOREIGN KEY (budget_id)
        REFERENCES budgets(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Budget alert and system notifications per user';

CREATE INDEX idx_notif_user_id ON notifications (user_id);
CREATE INDEX idx_notif_is_read ON notifications (user_id, is_read);

