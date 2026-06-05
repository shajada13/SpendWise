# SpendWise — Student Budget & Expense Management System
## Complete Project Architecture Document
---

## 1. SYSTEM OVERVIEW

SpendWise is a full-stack web application that helps students manage their
budgets, track expenses, monitor university costs, and achieve savings goals.

- **Architecture Pattern:** MVC (Model-View-Controller)
- **Backend:** Java 21 + Spring Boot (REST API)
- **Frontend:** HTML5 + CSS3 + Bootstrap 5 + JavaScript
- **Database:** MySQL
- **Communication:** JSON over HTTP (REST)
- **Charts:** Chart.js

---

## 2. SYSTEM ARCHITECTURE DIAGRAM

```
┌─────────────────────────────────────────────────────────────┐
│                        FRONTEND LAYER                        │
│          HTML5 + CSS3 + Bootstrap 5 + JavaScript             │
│                       Chart.js                               │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP/JSON (REST API)
┌──────────────────────────▼──────────────────────────────────┐
│                       BACKEND LAYER                          │
│                  Java 21 + Spring Boot                       │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐    │
│   │ Controllers │→ │  Services   │→ │  Repositories   │    │
│   │ (REST API)  │  │ (Business)  │  │  (Data Access)  │    │
│   └─────────────┘  └─────────────┘  └────────┬────────┘    │
└───────────────────────────────────────────────┼─────────────┘
                                                │ JPA/JDBC
┌───────────────────────────────────────────────▼─────────────┐
│                       DATABASE LAYER                         │
│                     MySQL Database                           │
│   users | expenses | budgets | categories | goals | alerts  │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. SYSTEM MODULES

### Module 1: Authentication Module
- User Registration (name, email, password)
- User Login (email + password)
- Session Management
- Remember Me functionality
- Password Change

### Module 2: Dashboard Module
- Summary statistics (Total Budget, Spent, Remaining, Savings)
- Monthly budget progress bar
- Recent transactions (last 5)
- Budget alert notifications
- Expense trend mini chart
- Category spending pie chart

### Module 3: Expense Module
- Add new expense (amount, category, subcategory, date, description)
- Edit existing expense
- Delete expense
- Expense history with filters
- Search expenses by description
- Filter by month, category
- Sort by date, amount, category

### Module 4: Budget Module
- Set monthly budgets per category
- Home, Food, Travel, University, Others
- Progress bars per category
- Budget vs Actual comparison
- Alert thresholds: 70%, 90%, 100%

### Module 5: Analytics Module
- Monthly expense line chart (12 months)
- Category distribution pie chart
- Budget vs Expense bar chart
- Monthly comparison table
- Next month prediction (based on average)
- Spending insights

### Module 6: University Expense Module
- Semester selector
- Tuition fee tracker
- Books expenses
- Printing & photocopy
- Stationery
- Other academic costs
- Semester cost summary
- Payment status (Paid/Pending)

### Module 7: Goals & Savings Module
- Add savings goals (name, target amount, current amount)
- Goal progress bar
- Goal category (Laptop, Phone, Emergency Fund, etc.)
- Goal deadline
- Mark goal as complete

### Module 8: Profile & Settings Module
- View and edit profile info
- Change password
- Notification settings
- Currency setting (BDT)
- Theme setting (Light/Dark)

### Module 9: Notification & Alert Module
- Budget alert at 70% usage
- Budget alert at 90% usage
- Budget alert at 100% usage
- Notification bell in navbar
- Alert banner on dashboard

### Module 10: Month Filter Module
- Month selector (Jan–Dec)
- Year selector
- Apply filter across all pages
- Calendar archive view

---

## 4. FOLDER STRUCTURE

```
spendwise/
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── spendwise/
│   │   │           ├── SpendwiseApplication.java
│   │   │           │
│   │   │           ├── config/
│   │   │           │   ├── SecurityConfig.java
│   │   │           │   ├── WebConfig.java
│   │   │           │   └── CorsConfig.java
│   │   │           │
│   │   │           ├── controller/
│   │   │           │   ├── AuthController.java
│   │   │           │   ├── DashboardController.java
│   │   │           │   ├── ExpenseController.java
│   │   │           │   ├── BudgetController.java
│   │   │           │   ├── AnalyticsController.java
│   │   │           │   ├── UniversityController.java
│   │   │           │   ├── GoalController.java
│   │   │           │   └── ProfileController.java
│   │   │           │
│   │   │           ├── service/
│   │   │           │   ├── AuthService.java
│   │   │           │   ├── ExpenseService.java
│   │   │           │   ├── BudgetService.java
│   │   │           │   ├── AnalyticsService.java
│   │   │           │   ├── UniversityService.java
│   │   │           │   ├── GoalService.java
│   │   │           │   └── AlertService.java
│   │   │           │
│   │   │           ├── repository/
│   │   │           │   ├── UserRepository.java
│   │   │           │   ├── ExpenseRepository.java
│   │   │           │   ├── BudgetRepository.java
│   │   │           │   ├── CategoryRepository.java
│   │   │           │   ├── UniversityExpenseRepository.java
│   │   │           │   └── GoalRepository.java
│   │   │           │
│   │   │           ├── model/
│   │   │           │   ├── User.java
│   │   │           │   ├── Expense.java
│   │   │           │   ├── Budget.java
│   │   │           │   ├── Category.java
│   │   │           │   ├── UniversityExpense.java
│   │   │           │   └── Goal.java
│   │   │           │
│   │   │           └── dto/
│   │   │               ├── LoginRequest.java
│   │   │               ├── RegisterRequest.java
│   │   │               ├── ExpenseDTO.java
│   │   │               ├── BudgetDTO.java
│   │   │               ├── DashboardDTO.java
│   │   │               ├── AnalyticsDTO.java
│   │   │               └── ApiResponse.java
│   │   │
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── application-dev.properties
│   │       ├── static/
│   │       │   ├── css/
│   │       │   │   ├── style.css
│   │       │   │   ├── dashboard.css
│   │       │   │   ├── auth.css
│   │       │   │   └── components.css
│   │       │   ├── js/
│   │       │   │   ├── auth.js
│   │       │   │   ├── dashboard.js
│   │       │   │   ├── expense.js
│   │       │   │   ├── budget.js
│   │       │   │   ├── analytics.js
│   │       │   │   ├── university.js
│   │       │   │   ├── goals.js
│   │       │   │   └── utils.js
│   │       │   └── images/
│   │       │       ├── logo.png
│   │       │       ├── wallet-hero.png
│   │       │       └── avatar.png
│   │       └── templates/
│   │           ├── auth/
│   │           │   └── login.html
│   │           ├── dashboard/
│   │           │   └── index.html
│   │           ├── expense/
│   │           │   ├── add.html
│   │           │   └── history.html
│   │           ├── budget/
│   │           │   └── manage.html
│   │           ├── analytics/
│   │           │   └── reports.html
│   │           ├── university/
│   │           │   └── tracker.html
│   │           ├── goals/
│   │           │   └── savings.html
│   │           └── profile/
│   │               └── settings.html
│
├── pom.xml
├── README.md
└── database/
    ├── schema.sql
    └── seed.sql
```

---

## 5. PACKAGE STRUCTURE

```
com.spendwise
├── SpendwiseApplication.java       ← Main entry point
│
├── config/                         ← Configuration classes
│   ├── SecurityConfig.java         ← Spring Security (session-based)
│   ├── WebConfig.java              ← MVC configuration
│   └── CorsConfig.java             ← CORS settings
│
├── controller/                     ← REST Controllers (HTTP endpoints)
│   ├── AuthController.java         ← /api/auth/**
│   ├── DashboardController.java    ← /api/dashboard/**
│   ├── ExpenseController.java      ← /api/expenses/**
│   ├── BudgetController.java       ← /api/budgets/**
│   ├── AnalyticsController.java    ← /api/analytics/**
│   ├── UniversityController.java   ← /api/university/**
│   ├── GoalController.java         ← /api/goals/**
│   └── ProfileController.java      ← /api/profile/**
│
├── service/                        ← Business Logic Layer
│   ├── AuthService.java
│   ├── ExpenseService.java
│   ├── BudgetService.java
│   ├── AnalyticsService.java
│   ├── UniversityService.java
│   ├── GoalService.java
│   └── AlertService.java
│
├── repository/                     ← Data Access Layer (JPA)
│   ├── UserRepository.java
│   ├── ExpenseRepository.java
│   ├── BudgetRepository.java
│   ├── CategoryRepository.java
│   ├── UniversityExpenseRepository.java
│   └── GoalRepository.java
│
├── model/                          ← JPA Entity Classes
│   ├── User.java
│   ├── Expense.java
│   ├── Budget.java
│   ├── Category.java
│   ├── UniversityExpense.java
│   └── Goal.java
│
└── dto/                            ← Data Transfer Objects
    ├── LoginRequest.java
    ├── RegisterRequest.java
    ├── ExpenseDTO.java
    ├── BudgetDTO.java
    ├── DashboardDTO.java
    ├── AnalyticsDTO.java
    └── ApiResponse.java
```

---

## 6. DATABASE SCHEMA OVERVIEW

```
TABLE: users
  - id (PK, AUTO_INCREMENT)
  - full_name
  - email (UNIQUE)
  - password (hashed)
  - avatar_url
  - currency (default: BDT)
  - theme (default: light)
  - created_at

TABLE: categories
  - id (PK)
  - name (Food, Home, Travel, University, Others)
  - icon
  - color

TABLE: expenses
  - id (PK)
  - user_id (FK → users)
  - category_id (FK → categories)
  - subcategory
  - amount
  - description
  - payment_method (Cash/Bank/Bkash)
  - expense_date
  - month
  - year
  - created_at

TABLE: budgets
  - id (PK)
  - user_id (FK → users)
  - category_id (FK → categories)
  - amount
  - month
  - year
  - alert_70_sent
  - alert_90_sent
  - alert_100_sent

TABLE: university_expenses
  - id (PK)
  - user_id (FK → users)
  - semester
  - year
  - expense_type (Tuition/Books/Printing/Stationery/Other)
  - amount
  - status (Paid/Pending)
  - description
  - expense_date

TABLE: goals
  - id (PK)
  - user_id (FK → users)
  - goal_name
  - target_amount
  - current_amount
  - deadline
  - status (Active/Completed)
  - icon
  - created_at
```

---

## 7. REST API ENDPOINTS

```
AUTH
  POST   /api/auth/register        ← Register new user
  POST   /api/auth/login           ← Login user
  POST   /api/auth/logout          ← Logout user

DASHBOARD
  GET    /api/dashboard/summary    ← Get summary cards data
  GET    /api/dashboard/recent     ← Get recent transactions
  GET    /api/dashboard/alerts     ← Get budget alerts

EXPENSES
  GET    /api/expenses             ← Get all expenses (with filters)
  POST   /api/expenses             ← Add new expense
  PUT    /api/expenses/{id}        ← Update expense
  DELETE /api/expenses/{id}        ← Delete expense
  GET    /api/expenses/filter      ← Filter by month/category

BUDGETS
  GET    /api/budgets              ← Get all budgets
  POST   /api/budgets              ← Create/update budget
  GET    /api/budgets/progress     ← Budget progress per category

ANALYTICS
  GET    /api/analytics/monthly    ← Monthly trend data
  GET    /api/analytics/category   ← Category distribution
  GET    /api/analytics/comparison ← Budget vs Expense

UNIVERSITY
  GET    /api/university           ← Get university expenses
  POST   /api/university           ← Add university expense
  PUT    /api/university/{id}      ← Update
  DELETE /api/university/{id}      ← Delete

GOALS
  GET    /api/goals                ← Get all goals
  POST   /api/goals                ← Add new goal
  PUT    /api/goals/{id}           ← Update goal
  DELETE /api/goals/{id}           ← Delete goal

PROFILE
  GET    /api/profile              ← Get profile data
  PUT    /api/profile              ← Update profile
  PUT    /api/profile/password     ← Change password
```

---

## 8. PAGE LIST

| # | Page | URL | Description |
|---|------|-----|-------------|
| 1 | Login / Register | /login | Auth page with split layout |
| 2 | Dashboard | /dashboard | Main overview page |
| 3 | Add Expense | /expenses/add | Add new expense form |
| 4 | Expense History | /expenses/history | All expenses with filters |
| 5 | Budget Management | /budget | Set & manage budgets |
| 6 | Analytics & Reports | /analytics | Charts and insights |
| 7 | University Tracker | /university | Academic expense tracker |
| 8 | Goals & Savings | /goals | Savings goal tracking |
| 9 | Profile & Settings | /profile | User settings |

---

## 9. USER FLOW

```
[Landing / Login Page]
        │
        ├─── New User ──→ [Register Form] ──→ [Dashboard]
        │
        └─── Existing ──→ [Login Form] ──→ [Dashboard]
                                                │
                    ┌───────────────────────────┤
                    │                           │
              [Add Expense]             [View Dashboard]
                    │                           │
                    ▼                     ┌─────┴──────┐
              [Expense History]     [Budget Alert?]  [Charts]
                    │                     │
                    ▼                     ▼
              [Analytics]         [Budget Management]
                    │
                    ▼
          ┌─────────────────┐
          │                 │
    [University]        [Goals]
          │                 │
          └────────┬────────┘
                   │
              [Profile/Settings]
                   │
              [Logout]
```

---

## 10. DEVELOPMENT ROADMAP

### Phase 1 — Foundation (Step 1-2)
- [x] Project Architecture Design
- [ ] MySQL Database Schema
- [ ] Spring Boot Project Setup
- [ ] pom.xml dependencies
- [ ] application.properties

### Phase 2 — Backend Core (Step 3-5)
- [ ] Java Entity Models
- [ ] Repositories (JPA)
- [ ] Service Layer (Business Logic)
- [ ] REST API Controllers
- [ ] JSON Response Format

### Phase 3 — Frontend Pages (Step 6-13)
- [ ] Login & Register Page
- [ ] Dashboard Page
- [ ] Add Expense Page
- [ ] Expense History Page
- [ ] Budget Management Page
- [ ] Analytics Page
- [ ] University Tracker Page
- [ ] Profile & Settings Page

### Phase 4 — Integration (Step 14)
- [ ] Connect frontend to backend APIs
- [ ] Chart.js integration
- [ ] Session management
- [ ] Budget alert system
- [ ] Final testing & polish
- [ ] Full project ZIP

---

## 11. SECURITY APPROACH

- **Session-based authentication** (Spring Security)
- **Password hashing** with BCrypt
- **CSRF protection** enabled
- **Input validation** on all forms (frontend + backend)
- **SQL Injection prevention** via JPA/Prepared Statements
- **Unauthorized access redirect** to login page

---

## 12. KEY DESIGN DECISIONS

| Decision | Choice | Reason |
|----------|--------|--------|
| Auth | Session-based | Simpler for web app, no JWT complexity |
| Template | Thymeleaf | Server-side rendering, integrates well with Spring |
| ORM | Spring Data JPA | Clean repository pattern |
| CSS | Bootstrap 5 + Custom CSS | Rapid UI + custom purple theme |
| Charts | Chart.js | Lightweight, beautiful, easy to use |
| Currency | BDT (৳) | Student in Bangladesh context |

---

*Document Version: 1.0 | Project: SpendWise | Architecture Phase Complete*
