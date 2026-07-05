# SpendWise 💰
**Personal Finance & Budget Management System**

## Tech Stack
- **Backend**: Java 21, Spring Boot 3, Spring Security, Spring Data JPA
- **Frontend**: HTML5, Tailwind CSS, Vanilla JavaScript, Chart.js
- **Database**: MySQL
- **Build**: Maven

## Getting Started

### Prerequisites
- Java 21
- Maven 3.9+
- MySQL 8.0+

### Database Setup
```sql
CREATE DATABASE spendwise_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
Run SQL files in order:
```
src/main/resources/db/01_schema.sql
src/main/resources/db/02_sample_data.sql
src/main/resources/db/03_views.sql
```

### Configuration
Edit `src/main/resources/application.properties`:
```properties
spring.datasource.username=YOUR_DB_USER
spring.datasource.password=YOUR_DB_PASSWORD
```

### Run
```bash
mvn spring-boot:run
```
Open: http://localhost:8080

## Development Phases
- ✅ Phase 1: Project Architecture
- ✅ Phase 2: Database Design
- ✅ Phase 3: Spring Boot Setup
- ⏳ Phase 4: Entity Layer
- ⏳ Phase 5: Security & JWT
- ...and more
