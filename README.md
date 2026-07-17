# SpendWise 💙

Smart Expense Tracker for University Students — built with Spring Boot, Thymeleaf, and MySQL.

## Features (Planned)

- 📊 Financial Dashboard
- 💸 Expense Tracking
- 💰 Income Tracking
- 📅 Monthly Budgeting
- 🎯 Savings Goals
- 📈 Analytics & Reports
- 🔔 Budget Alerts
- 👤 Profile & Settings

## Tech Stack

| Layer      | Technology                          |
|------------|--------------------------------------|
| Backend    | Java 21, Spring Boot, Spring MVC, Spring Data JPA, Hibernate |
| Frontend   | HTML5, CSS3, JavaScript, Bootstrap 5, Thymeleaf |
| Database   | MySQL                               |
| Build Tool | Maven                               |
| IDE        | IntelliJ IDEA                       |

## Project Status

🚧 **Foundation Phase** — project structure, design system, and static pages are in place.
Business logic, authentication, and database integration will be added in upcoming steps.

## Getting Started

### Prerequisites
- Java 21+
- Maven 3.9+
- MySQL 8+

### Configure the Database
Create a MySQL database named `spendwise_db`, then update credentials in:
`src/main/resources/application-dev.properties`

### Run the Application
```bash
mvn spring-boot:run
```

The app will be available at `http://localhost:8080`.

## Project Structure

See `docs/` for architecture diagrams and the full technical specification.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
