# Underground Terminal - B2B Luxury Marketplace

A specialized B2B ecommerce platform for the luxury fashion and cosmetics sector, addressing market inefficiencies through secure transactions, real-time logistics, and comprehensive inventory management.

## 🎯 Project Overview

Underground Terminal is a modern B2B marketplace designed specifically for luxury fashion and cosmetics professionals. The platform connects suppliers, buyers, and designers in a secure, efficient environment optimized for high-value transactions and premium product management.

### Key Features

- **🔐 Secure Authentication**: JWT + OAuth2 Google integration
- **👥 Role-Based Access**: Supplier, Buyer, Designer user types
- **💎 Luxury Product Catalog**: High-end fashion and cosmetics
- **📱 Mobile-First Design**: Flutter app with professional dark theme
- **🛡️ Enterprise Security**: BCrypt encryption, JWT filter chain, CORS protection
- **📊 Real-time Data**: MySQL database with comprehensive product management

## 🏗️ Architecture

### Backend (Spring Boot 3.2.0)
- **Java 17** with Maven build system
- **MySQL 8.0+** / H2 in-memory database with JPA/Hibernate
- **Spring Security** with JWT authentication filter
- **OAuth2** Google integration
- **RESTful APIs** with OpenAPI documentation
- **Spring Profiles**: dev (H2), staging (MySQL), prod (MySQL)

### Frontend (Flutter 3.6.0)
- **Dart SDK 3.0+** mobile application
- **Provider** state management
- **Google Sign-In** integration
- **Material Design 3** with custom luxury theme
- **HTTP client** for API communication

## 🌿 Branching Strategy

```
prod (production - auto-deployed to Render)
  ↑
staging (pre-production testing - auto-deployed to Render staging)
  ↑
dev (development - built & tested on CI)
  ↑
feature/* (individual features or fixes)
```

### Workflow
1. **Feature branches** → Create from `dev`, merge back via PR
2. **Dev branch** → Continuous integration (build + test)
3. **Staging branch** → Pre-production deployment on Render
4. **Prod branch** → Production deployment on Render

## 🚀 Quick Start

### Prerequisites

#### Backend Requirements
- Java 17 or higher
- Maven 3.6+
- MySQL 8.0+ (for staging/prod) or H2 (for dev, no install needed)
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

2. **Switch to dev branch**
   ```bash
   git checkout dev
   ```

3. **Setup Backend (dev profile with H2 - no MySQL needed)**
   ```bash
   cd backend
   mvn clean compile
   mvn spring-boot:run
   # Or with explicit profile:
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

4. **Setup Flutter App**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

5. **Access the API**
   - API: `http://localhost:8080/api/products`
   - Swagger UI: `http://localhost:8080/swagger-ui.html`
   - H2 Console: `http://localhost:8080/h2-console`
   - Seed data: 9 users + 20+ luxury products loaded automatically

### Configuration

#### Environment Variables
Copy `.env.example` to `.env` and update values:
```bash
cp .env.example .env
```

#### Spring Profiles
```bash
# Development (H2 in-memory - default)
mvn spring-boot:run

# Staging (MySQL)
SPRING_PROFILES_ACTIVE=staging mvn spring-boot:run

# Production (MySQL)
SPRING_PROFILES_ACTIVE=prod mvn spring-boot:run
```

## 📱 Application Features

### Authentication System
- **Email/Password Registration & Login** with JWT
- **Google OAuth2 Single Sign-On**
- **JWT Token Management** with automatic validation
- **Role-based Access Control** (SUPPLIER, BUYER, DESIGNER)
- **Secure Session Handling** with stateless authentication

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
- **Search & Filter**: By name, supplier, price range

## 🔧 Development

### Backend Development

#### Running Tests
```bash
cd backend
mvn test
```

#### Building for Production
```bash
mvn clean package -DskipTests
java -jar target/underground-terminal-api-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
```

#### API Documentation
- **Swagger UI**: `http://localhost:8080/swagger-ui.html`
- **OpenAPI Spec**: `http://localhost:8080/api-docs`

### Frontend Development

#### Running on Mobile (Android/iOS)
```bash
cd mobile
flutter run
```

#### Running on Web (Edge / Chrome)

For local development, the frontend needs the API base URL set to `localhost` (not the Android emulator's `10.0.2.2`).

**Option 1 — Run directly in the browser (hot-reload enabled):**
```bash
# Terminal 1 — Start Backend
cd backend
mvn spring-boot:run

# Terminal 2 — Run Flutter Web on Edge
cd mobile
flutter run -d edge --dart-define=API_BASE_URL=http://localhost:8080/api
```

**Option 2 — Build and serve with Python (shareable build):**
```bash
# Terminal 1 — Start Backend
cd backend
mvn spring-boot:run

# Terminal 2 — Build Flutter Web
cd mobile
flutter build web --dart-define=API_BASE_URL=http://localhost:8080/api

# Terminal 3 — Serve with Python
cd mobile/build/web
python -m http.server 3000
# Then open http://localhost:3000 in your browser
```

> **Note:** Use `--dart-define=API_BASE_URL=https://your-domain.com/api` for production or Render deployment.

#### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --dart-define=API_BASE_URL=https://your-api-url.com/api
```

#### Testing
```bash
flutter test
```

## 🤝 Contributing

1. **Fork the repository**
2. **Create feature branch** from `dev` (`git checkout -b feature/amazing-feature dev`)
3. **Commit changes** (`git commit -m 'Add amazing feature'`)
4. **Push to branch** (`git push origin feature/amazing-feature`)
5. **Open Pull Request** to `dev`

## 📄 License

This project is proprietary software developed for Underground Terminal B2B Luxury Marketplace. All rights reserved.

---
