# SpendWise — Student Budget & Expense Management System

## Tech Stack
- Java 21 + Spring Boot 3.2.5
- MySQL 8.0
- Thymeleaf + Bootstrap 5
- Chart.js | Spring Security

## Quick Start
```bash
# 1. Setup database
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed.sql

# 2. Update credentials in src/main/resources/application.properties

# 3. Run
mvn spring-boot:run

# 4. Open
http://localhost:8080/login
```

## Project Structure
```
spendwise/
├── src/main/java/com/spendwise/
│   ├── SpendwiseApplication.java
│   ├── config/         SecurityConfig, WebConfig
│   ├── controller/     Auth, Dashboard, Expense, Budget,
│   │                   Analytics, University, Goal, Profile
│   ├── service/        Auth, Expense, Budget, Analytics,
│   │                   University, Goal, Alert
│   ├── repository/     User, Expense, Budget, Category,
│   │                   UniversityExpense, Goal, Notification
│   ├── model/          User, Expense, Budget, Category,
│   │                   UniversityExpense, Goal, Notification
│   ├── dto/            ApiResponse, LoginRequest, RegisterRequest,
│   │                   ExpenseDTO, BudgetDTO, DashboardDTO, AnalyticsDTO
│   └── exception/      GlobalExceptionHandler, ResourceNotFoundException
├── src/main/resources/
│   ├── templates/      auth/, dashboard/, expense/, budget/,
│   │                   analytics/, university/, goals/, profile/, fragments/
│   ├── static/
│   │   ├── css/        style.css + page-specific CSS files
│   │   ├── js/         page-specific JS files + utils.js
│   │   └── images/
│   └── application.properties
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   └── queries.sql
└── pom.xml
```

## Demo Login (after seed.sql)
- Email: arafat@email.com
- Password: password123
