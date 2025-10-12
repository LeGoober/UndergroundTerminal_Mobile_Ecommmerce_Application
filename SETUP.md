# Underground Terminal - Setup Guide

Complete setup instructions for the Underground Terminal B2B Luxury Marketplace platform.

## 🔧 System Requirements

### Minimum Requirements
- **RAM**: 8GB (16GB recommended)
- **Storage**: 10GB free space
- **OS**: Windows 10/11, macOS 10.14+, Ubuntu 18.04+
- **Internet**: Stable connection for dependencies

### Development Tools
- **Java**: OpenJDK 17 or Oracle JDK 17+
- **Node.js**: 16.x+ (for npm packages)
- **Git**: Latest version
- **IDE**: IntelliJ IDEA, VS Code, or Android Studio

## 📦 Installation Steps

### Step 1: Environment Setup

#### Install Java 17
```bash
# Windows (using Chocolatey)
choco install openjdk17

# macOS (using Homebrew)
brew install openjdk@17

# Ubuntu
sudo apt update
sudo apt install openjdk-17-jdk
```

#### Install Maven
```bash
# Windows
choco install maven

# macOS
brew install maven

# Ubuntu
sudo apt install maven
```

#### Install MySQL
```bash
# Windows
choco install mysql

# macOS
brew install mysql

# Ubuntu
sudo apt install mysql-server mysql-client
```

#### Install Flutter
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install
# Add to PATH environment variable

# Verify installation
flutter doctor
```

### Step 2: Database Configuration

#### Start MySQL Service
```bash
# Windows
net start mysql80

# macOS/Linux
sudo systemctl start mysql
# or
brew services start mysql
```

#### Create Database
```sql
-- Connect to MySQL as root
mysql -u root -p

-- Create database and user
CREATE DATABASE underground_terminal;
CREATE USER 'underground_user'@'localhost' IDENTIFIED BY 'Underground2024!';
GRANT ALL PRIVILEGES ON underground_terminal.* TO 'underground_user'@'localhost';
FLUSH PRIVILEGES;

-- Verify database creation
SHOW DATABASES;
USE underground_terminal;
```

### Step 3: Backend Setup

#### Clone and Configure
```bash
# Navigate to backend directory
cd backend

# Copy and edit configuration
cp src/main/resources/application.properties.example src/main/resources/application.properties
```

#### Update Configuration File
Edit `backend/src/main/resources/application.properties`:

```properties
# MySQL Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/underground_terminal?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.username=underground_user
spring.datasource.password=Underground2024!

# JPA Configuration
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true

# Security Configuration
spring.security.user.name=admin
spring.security.user.password=admin
spring.security.user.roles=ADMIN

# JWT Configuration
jwt.secret=UndergroundTerminalSecretKey2024!@#$%^&*()_+1234567890
jwt.expiration=86400000

# OAuth2 Google Configuration (Replace with your values)
spring.security.oauth2.client.registration.google.client-id=YOUR_GOOGLE_CLIENT_ID
spring.security.oauth2.client.registration.google.client-secret=YOUR_GOOGLE_CLIENT_SECRET
spring.security.oauth2.client.registration.google.scope=openid,profile,email
spring.security.oauth2.client.registration.google.redirect-uri={baseUrl}/login/oauth2/code/{registrationId}

# Server Configuration
server.port=8080

# OpenAPI Documentation
springdoc.api-docs.path=/api-docs
springdoc.swagger-ui.path=/swagger-ui.html

# CORS Configuration
spring.web.cors.allowed-origins=*
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
spring.web.cors.allowed-headers=*

# Logging
logging.level.com.undergroundterminal=INFO
logging.level.org.springframework.web=WARN
```

#### Build and Run Backend
```bash
# Clean and compile
mvn clean compile

# Run tests
mvn test

# Start the application
mvn spring-boot:run

# Verify backend is running
curl http://localhost:8080/api-docs
```

### Step 4: Frontend Setup

#### Configure Flutter Environment
```bash
# Navigate to mobile directory
cd mobile

# Get dependencies
flutter pub get

# Verify Flutter configuration
flutter doctor

# Check for any issues and resolve
flutter doctor --android-licenses
```

#### Update API Configuration
Edit `mobile/lib/services/api_service.dart`:

```dart
class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Android emulator
  // For iOS simulator use: 'http://localhost:8080/api'
  // For physical device use your computer's IP: 'http://192.168.1.XXX:8080/api'
```

#### Configure Google Sign-In
Edit `mobile/lib/services/auth_service.dart`:

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
);
```

#### Run Flutter App
```bash
# Start Android emulator or connect device
flutter devices

# Run the app
flutter run

# For release build
flutter build apk --release
```

## 🔑 Google OAuth2 Setup

### Step 1: Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API and Google OAuth2 API

### Step 2: Configure OAuth Consent Screen
1. Go to **APIs & Services > OAuth consent screen**
2. Choose **External** user type
3. Fill in application details:
   - App name: Underground Terminal
   - User support email: your-email@domain.com
   - Developer contact: your-email@domain.com

### Step 3: Create OAuth2 Credentials
1. Go to **APIs & Services > Credentials**
2. Click **Create Credentials > OAuth client ID**
3. Application type: **Web application**
4. Authorized redirect URIs:
   - `http://localhost:8080/login/oauth2/code/google`
   - `http://localhost:8080/api/auth/oauth2/success`

### Step 4: Configure Mobile OAuth
1. Create another credential for **Android** (if building for Android)
2. Add your app's SHA-1 fingerprint
3. Package name: `com.undergroundterminal.mobile`

### Step 5: Update Configuration
Copy the client ID and secret to your configuration files.

## 🛠️ Development Environment

### IDE Setup

#### IntelliJ IDEA (Recommended for Backend)
1. Install **Spring Boot plugin**
2. Import Maven project
3. Configure JDK 17
4. Set up run configuration for Spring Boot

#### VS Code (Recommended for Frontend)
1. Install **Flutter extension**
2. Install **Dart extension**
3. Open mobile folder
4. Configure Flutter SDK path

#### Android Studio (Alternative)
1. Install **Flutter plugin**
2. Create virtual device for testing
3. Configure Android SDK

### Database Management

#### MySQL Workbench
1. Install MySQL Workbench
2. Connect to localhost:3306
3. Username: underground_user
4. Password: Underground2024!

#### Command Line Tools
```bash
# Connect to database
mysql -u underground_user -p underground_terminal

# View tables
SHOW TABLES;

# Check sample data
SELECT * FROM users LIMIT 5;
SELECT * FROM products LIMIT 5;
```

## 🧪 Testing Setup

### Backend Testing
```bash
cd backend

# Run unit tests
mvn test

# Run integration tests
mvn verify

# Generate test coverage report
mvn jacoco:report
# Report available at: target/site/jacoco/index.html
```

### Frontend Testing
```bash
cd mobile

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### API Testing with Postman

#### Import Collection
1. Download Postman
2. Import the API collection (if available)
3. Set environment variables:
   - `base_url`: http://localhost:8080
   - `auth_token`: (obtained from login)

#### Test Authentication
```bash
# Register new user
POST {{base_url}}/api/auth/register
Content-Type: application/json

{
  "name": "Test User",
  "email": "test@example.com",
  "password": "password123",
  "role": "buyer"
}

# Login
POST {{base_url}}/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}
```

## 🔄 Hot Reload Development

### Backend Hot Reload
```bash
# Use Spring Boot DevTools (already included)
mvn spring-boot:run

# Changes to Java files will auto-reload
```

### Frontend Hot Reload
```bash
# Flutter hot reload is built-in
flutter run

# Press 'r' for hot reload
# Press 'R' for hot restart
```

## 📱 Device Testing

### Android Emulator
```bash
# List available emulators
flutter emulators

# Start emulator
flutter emulators --launch <emulator_id>

# Run app on emulator
flutter run
```

### Physical Device Testing

#### Android
1. Enable Developer Options
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

#### iOS (macOS only)
1. Connect iPhone/iPad
2. Trust computer
3. Run: `flutter run`

## 🚨 Troubleshooting

### Common Backend Issues

#### Port Already in Use
```bash
# Find process using port 8080
netstat -ano | findstr :8080
# Kill process
taskkill /PID <process_id> /F
```

#### MySQL Connection Issues
```bash
# Check MySQL service status
systemctl status mysql

# Reset MySQL password
sudo mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
```

### Common Frontend Issues

#### Flutter Doctor Issues
```bash
# Accept Android licenses
flutter doctor --android-licenses

# Update Flutter
flutter upgrade

# Clear cache
flutter clean
flutter pub get
```

#### Gradle Build Issues
```bash
cd mobile/android
./gradlew clean

cd ..
flutter clean
flutter pub get
flutter run
```

### Network Issues

#### API Connection from Mobile
- **Android Emulator**: Use `10.0.2.2` instead of `localhost`
- **iOS Simulator**: Use `localhost` or computer IP
- **Physical Device**: Use computer's IP address in network

#### CORS Issues
Ensure CORS is properly configured in `application.properties`

## 📊 Monitoring and Logs

### Backend Logs
```bash
# Application logs
tail -f logs/underground-terminal.log

# Spring Boot actuator endpoints
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/info
```

### Frontend Debugging
```bash
# Flutter logs
flutter logs

# Debug in Chrome (web)
flutter run -d chrome --web-renderer html
```

### Database Monitoring
```sql
-- Check active connections
SHOW PROCESSLIST;

-- Monitor slow queries
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
```

## 🎯 Next Steps

After completing setup:

1. **Verify all endpoints** using Swagger UI: `http://localhost:8080/swagger-ui.html`
2. **Test authentication flow** in mobile app
3. **Check sample data** in database
4. **Configure Google OAuth** with your credentials
5. **Set up production environment** for deployment

## 📞 Support

If you encounter issues during setup:

1. Check the **troubleshooting section** above
2. Verify **system requirements** are met
3. Review **error logs** for specific issues
4. Consult **project documentation**
5. Contact the development team

---

**Setup completed successfully? 🎉 Start exploring the Underground Terminal B2B Luxury Marketplace!**
