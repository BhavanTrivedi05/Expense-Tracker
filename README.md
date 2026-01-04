# 💰 Expense Tracker - Spring Boot Application

A full-stack expense management system built with **Spring Boot**, **JSP**, **MySQL**, and **Bootstrap**. Track your expenses, manage accounts, generate reports, and gain insights into your spending patterns.

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.2-brightgreen)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 🚀 Features

### ✨ Core Functionality
- **User Authentication**: Secure signup/login with BCrypt password encryption
- **Role-Based Access**: Admin and User roles with different permissions
- **Expense Management**: Create, read, update, and delete expenses
- **Account Management**: Track multiple accounts (bank accounts, credit cards, cash)
- **Category & Subcategory**: Organize expenses with custom categories
- **Vendor Tracking**: Keep records of vendors/merchants
- **Report Generation**: Filter expenses by date range and category
- **Dashboard Analytics**: View spending summaries and statistics

### 🔐 Security
- Password encryption using BCrypt
- OTP-based password reset
- Session management
- Multi-tenant data isolation (users only see their own data)

### 📧 Email Features
- Welcome email on registration
- OTP email for password recovery
- SMTP integration with Gmail

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Spring Boot 3.4.2** | Backend framework |
| **Spring Data JPA** | Database ORM |
| **MySQL 8.0** | Relational database |
| **JSP** | Frontend templating |
| **Bootstrap 5.3** | UI framework |
| **Hibernate** | ORM implementation |
| **JavaMail** | Email service |
| **Maven** | Build tool |

---

## 📦 Installation & Setup

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- MySQL 8.0+
- Gmail account (for email features)

### 1. Clone the Repository
```bash
git clone https://github.com/BhavanTrivedi05/Expense-Tracker.git
cd Expense-Tracker
```

### 2. Setup MySQL Database
```sql
-- Login to MySQL
mysql -u root -p

-- Create database
CREATE DATABASE Expense_Tracker;

-- Exit MySQL
EXIT;
```

### 3. Configure Application Properties
Update `src/main/resources/application.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/Expense_Tracker 
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD

# Email Configuration (Optional)
spring.mail.username=your_email@gmail.com
spring.mail.password=your_app_password
```

### 4. Build and Run
```bash
# Clean and compile
mvn clean install

# Run the application
mvn spring-boot:run
```

### 5. Access the Application
```
http://localhost:9999
```

---

## 📁 Project Structure
```
expense-tracker/
├── src/
│   ├── main/
│   │   ├── java/com/grownited/
│   │   │   ├── controller/        # REST controllers
│   │   │   ├── entity/            # JPA entities
│   │   │   ├── repository/        # Data access layer
│   │   │   ├── service/           # Business logic
│   │   │   └── ExpenseTrackerApplication.java
│   │   ├── resources/
│   │   │   └── application.properties
│   │   └── webapp/WEB-INF/views/  # JSP views
├── pom.xml
└── README.md
```

---

## 🎯 Usage Guide

### For Users
1. **Register**: Create an account at `/signup`
2. **Login**: Access your dashboard
3. **Create Account**: Add financial accounts
4. **Add Categories**: Organize expenses
5. **Track Expenses**: Record transactions
6. **Generate Reports**: Analyze spending

### For Admins
1. **Access Admin Dashboard**: View system statistics
2. **Manage Users**: Administer user accounts
3. **View Reports**: Comprehensive analytics

---

## 🌐 Key Endpoints

- `GET /signup` - Registration page
- `GET /login` - Login page
- `GET /home` - User dashboard
- `GET /admindashboard` - Admin dashboard
- `GET /listexpense` - View all expenses
- `GET /reports` - Generate reports

---

## 🐛 Known Issues & Future Enhancements

### Planned Features
- [ ] Chart.js integration for analytics
- [ ] PDF report generation
- [ ] Budget alerts
- [ ] Recurring expenses
- [ ] Multi-currency support
- [ ] Receipt uploads

---

## 🤝 Contributing

Contributions welcome! Please submit a Pull Request.

---

## 👤 Author

**Bhavan Trivedi**
- GitHub: [@BhavanTrivedi05](https://github.com/BhavanTrivedi05)
- Email: bhavantrivedi05@gmail.com
- University: Northeastern University (MS in Computer Science)

---

## 📝 License

This project is licensed under the MIT License.

---

⭐ **If you find this project useful, please star it!** ⭐
