# Underground Terminal B2B Luxury Marketplace

A specialized B2B ecommerce platform for the luxury fashion and cosmetics sector, addressing market inefficiencies through secure transactions, real-time logistics, and comprehensive inventory management.

## 🎯 Project Overview

Underground Terminal is a modern B2B marketplace designed specifically for luxury fashion and cosmetics professionals. The platform connects suppliers, buyers, and designers in a secure, efficient environment optimized for high-value transactions and premium product management.

### Key Features

- **🔐 Secure Authentication**: JWT + OAuth2 Google integration
- **👥 Role-Based Access**: Supplier, Buyer, Designer user types
- **💎 Luxury Product Catalog**: High-end fashion and cosmetics
- **📱 Mobile-First Design**: Flutter app with professional dark theme
- **🛡️ Enterprise Security**: BCrypt encryption, CORS protection
- **📊 Real-time Data**: MySQL database with comprehensive product management

## 🏗️ Architecture

### Backend (Spring Boot 3.2.0)
- **Java 17** with Maven build system
- **MySQL 8.0+** database with JPA/Hibernate
- **Spring Security** with JWT authentication
- **OAuth2** Google integration
- **RESTful APIs** with OpenAPI documentation

### Frontend (Flutter 3.6.0)
- **Dart SDK 3.0+** mobile application
- **Provider** state management
- **Google Sign-In** integration
- **Material Design 3** with custom luxury theme
- **HTTP client** for API communication

## 🚀 Quick Start

### Prerequisites

#### Backend Requirements
- Java 17 or higher
- Maven 3.6+
- MySQL 8.0+
- Git

#### Frontend Requirements
- Flutter 3.6.0+
- Dart SDK 3.0+
- Android Studio or VS Code
- Android SDK (for emulator)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Underground_Terminal_Application
   ```

2. **Setup MySQL Database**
   ```sql
   CREATE DATABASE underground_terminal;
   CREATE USER 'underground_user'@'localhost' IDENTIFIED BY 'your_password';
   GRANT ALL PRIVILEGES ON underground_terminal.* TO 'underground_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. **Configure Backend**
   ```bash
   cd backend
   # Update application.properties with your MySQL credentials
   mvn clean install
   mvn spring-boot:run
   ```

4. **Setup Flutter App**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

### Configuration

#### Backend Configuration (`backend/src/main/resources/application.properties`)

```properties
# MySQL Database
spring.datasource.url=jdbc:mysql://localhost:3306/underground_terminal
spring.datasource.username=underground_user
spring.datasource.password=your_password

# JWT Configuration
jwt.secret=your_jwt_secret_key
jwt.expiration=86400000

# Google OAuth2
spring.security.oauth2.client.registration.google.client-id=your_google_client_id
spring.security.oauth2.client.registration.google.client-secret=your_google_client_secret
```

#### Frontend Configuration (`mobile/lib/services/auth_service.dart`)

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'your_google_client_id',
);
```

## 📱 Application Features

### Authentication System
- **Email/Password Registration & Login**
- **Google OAuth2 Single Sign-On**
- **JWT Token Management**
- **Role-based Access Control**
- **Secure Session Handling**

### User Roles

#### 🏪 Suppliers
- Manage luxury product catalogs
- Set pricing and inventory levels
- Communicate with buyers
- Track sales performance

#### 🛒 Buyers
- Browse exclusive product collections
- Place bulk orders
- Manage purchasing history
- Connect with verified suppliers

#### 🎨 Designers
- Showcase design portfolios
- Collaborate with suppliers
- Access exclusive materials
- Network with industry professionals

### Product Management
- **Luxury Fashion**: High-end clothing, accessories, jewelry
- **Premium Cosmetics**: Skincare, fragrances, beauty products
- **Real-time Inventory**: Stock level tracking and alerts
- **Image Management**: Unsplash-sourced luxury product images

## 🔧 Development

### Backend Development

#### Running Tests
```bash
cd backend
mvn test
```

#### Building for Production
```bash
mvn clean package
java -jar target/underground-terminal-api-0.0.1-SNAPSHOT.jar
```

#### API Documentation
- **Swagger UI**: `http://localhost:8080/swagger-ui.html`
- **OpenAPI Spec**: `http://localhost:8080/api-docs`

### Frontend Development

#### Running the App
```bash
cd mobile
flutter run
```

#### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

#### Testing
```bash
flutter test
```

## 📚 API Documentation

### Authentication Endpoints

#### POST `/api/auth/register`
Register a new user account.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "buyer",
  "bio": "Luxury fashion buyer"
}
```

**Response:**
```json
{
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "buyer"
  }
}
```

#### POST `/api/auth/login`
Authenticate existing user.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

#### POST `/api/auth/verify`
Verify JWT token validity.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

### Product Endpoints

#### GET `/api/products`
Retrieve all luxury products.

#### GET `/api/products/{id}`
Get specific product details.

#### POST `/api/products`
Create new product (Suppliers only).

### User Endpoints

#### GET `/api/users`
List all users (Admin only).

#### GET `/api/users/{id}`
Get user profile.

## 🎨 Design System

### Color Palette
- **Primary Gold**: `#FFD700` - Luxury brand accent
- **Background Dark**: `#121212` - Main background
- **Surface**: `#1E1E1E` - Card backgrounds
- **Text Primary**: `#FFFFFF` - Main text
- **Text Secondary**: `#B3B3B3` - Secondary text
- **Accent Purple**: `#BB86FC` - Feature highlights

### Typography
- **Headers**: Playfair Display (Serif)
- **Body Text**: Montserrat (Sans-serif)
- **Weights**: Regular (400), Medium (500), Bold (700)

### Component Library
- **Material Design 3** components
- **Custom luxury theme** with gold accents
- **Dark mode optimized** for professional use
- **Responsive design** for mobile devices

## 🗃️ Database Schema

### Users Table
```sql
CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('SUPPLIER', 'BUYER', 'DESIGNER') NOT NULL,
  image_url TEXT,
  bio TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Products Table
```sql
CREATE TABLE products (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  image_url TEXT,
  supplier_id BIGINT NOT NULL,
  description TEXT,
  stock_level INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (supplier_id) REFERENCES users(id)
);
```

## 🚀 Deployment

### Backend Deployment

#### Docker
```dockerfile
FROM openjdk:17-jdk-slim
COPY target/underground-terminal-api-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
```

#### Environment Variables
```bash
SPRING_DATASOURCE_URL=jdbc:mysql://production-db:3306/underground_terminal
SPRING_DATASOURCE_USERNAME=prod_user
SPRING_DATASOURCE_PASSWORD=secure_password
JWT_SECRET=production_jwt_secret_key_here
GOOGLE_CLIENT_ID=production_google_client_id
GOOGLE_CLIENT_SECRET=production_google_client_secret
```

### Frontend Deployment

#### Android Release
```bash
flutter build apk --release --target-platform android-arm64
```

#### iOS Release
```bash
flutter build ios --release
```

## 🔒 Security Considerations

### Authentication Security
- **JWT tokens** with configurable expiration
- **BCrypt password hashing** with salt rounds
- **OAuth2 integration** with Google
- **CORS protection** for API endpoints

### Data Protection
- **Input validation** on all API endpoints
- **SQL injection prevention** with JPA
- **XSS protection** in frontend
- **Secure token storage** in mobile app

### API Security
- **Rate limiting** (planned)
- **Request size limits** configured
- **HTTPS enforcement** in production
- **Audit logging** capabilities

## 🧪 Testing

### Backend Testing
```bash
# Unit tests
mvn test

# Integration tests
mvn verify

# Test coverage
mvn jacoco:report
```

### Frontend Testing
```bash
# Unit tests
flutter test

# Widget tests
flutter test --coverage

# Integration tests
flutter driver test_driver/app.dart
```

## 📈 Performance

### Backend Optimization
- **Database indexing** on frequently queried fields
- **Connection pooling** for MySQL
- **JPA lazy loading** for relationships
- **Caching strategy** (planned)

### Frontend Optimization
- **Image optimization** with network caching
- **State management** with Provider
- **Lazy loading** for product lists
- **Offline capability** (planned)

## 🤝 Contributing

1. **Fork the repository**
2. **Create feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit changes** (`git commit -m 'Add amazing feature'`)
4. **Push to branch** (`git push origin feature/amazing-feature`)
5. **Open Pull Request**

### Code Style
- **Backend**: Follow Google Java Style Guide
- **Frontend**: Follow Dart style guide with `flutter format`
- **Git**: Use conventional commit messages

## 📞 Support

### Documentation
- **API Docs**: Available at `/swagger-ui.html`
- **Architecture**: See `PROJECT_CAPABILITIES.md`
- **Setup Guide**: See `SETUP.md`

### Contact
- **Project Manager**: Underground Terminal Team
- **Technical Lead**: Development Team
- **Issues**: GitHub Issues page

## 📄 License

This project is proprietary software developed for Underground Terminal B2B Luxury Marketplace. All rights reserved.

---

**Built with ❤️ for the luxury fashion and cosmetics industry**
