# Underground Terminal B2B Luxury Fashion & Cosmetics Platform

## Project Overview

Underground Terminal is a specialized B2B ecommerce platform designed for the luxury fashion and cosmetics sector. The platform addresses market inefficiencies through secure transactions, real-time logistics, and comprehensive inventory management.

## Current Technical Architecture

### Backend (Spring Boot)

#### Database Configuration
- **Database**: MySQL (migrated from H2)
- **Connection**: `jdbc:mysql://localhost:3306/underground_terminal`
- **ORM**: Spring Data JPA with Hibernate
- **Schema**: Auto-managed with `hibernate.ddl-auto=update`

#### Core Entities
1. **User Entity**
   - Fields: id, name, email, password (encrypted), role, imageUrl, bio
   - Roles: SUPPLIER, BUYER, DESIGNER
   - Relationships: One-to-many with Products

2. **Product Entity**
   - Fields: id, name, price, imageUrl, supplierId, description, stockLevel
   - Relationships: Many-to-one with User (supplier)

#### Authentication & Security
- **JWT Token-based Authentication**
- **OAuth2 Google Integration** configured
- **BCrypt Password Encryption**
- **CORS Configuration** for cross-origin requests
- **API Endpoints**:
  - `/api/auth/login` - Email/password login
  - `/api/auth/register` - User registration
  - `/api/auth/verify` - Token verification
  - `/api/auth/oauth2/success` - OAuth2 callback

#### API Controllers
- **AuthController**: Authentication, registration, OAuth2 handling
- **ProductController**: Product CRUD operations
- **UserController**: User management

#### Data Initialization
- **MySQL Script**: Pre-populated with luxury fashion and cosmetics data
- **Sample Data**: 9 users (suppliers/buyers/designers), 20+ luxury products
- **Product Categories**: High-end fashion, premium cosmetics, luxury accessories
- **Image URLs**: Unsplash-sourced luxury product images

### Frontend (Flutter)

#### Architecture
- **Framework**: Flutter 3.6.0
- **State Management**: Provider pattern
- **HTTP Client**: Built-in http package
- **Local Storage**: SharedPreferences for token/user data

#### Authentication Services
- **AuthService**: Handles login, registration, token management
- **Google Sign-In**: Integrated with google_sign_in package
- **Token Persistence**: Automatic storage and retrieval
- **Session Management**: Token validation and auto-logout

#### Screen Structure
1. **SplashScreen**: App initialization and auto-login check
2. **LoginScreen**: 
   - Dual-mode (Sign In/Sign Up)
   - Email/password authentication
   - Google OAuth integration
   - Role selection for registration (Supplier/Buyer/Designer)
3. **DashboardScreen**: Main app interface post-login

#### Design System
- **Color Palette**: 
  - Primary Gold: #FFD700 (luxury brand accent)
  - Background: #121212 (dark theme)
  - Surface: #1E1E1E (elevated components)
- **Typography**: Google Fonts (Playfair Display + Montserrat)
- **Theme**: Consistent dark luxury aesthetic

#### API Integration
- **Base URL**: `http://10.0.2.2:8080/api` (Android emulator)
- **Endpoints**: Authentication, user management, product retrieval
- **Error Handling**: Comprehensive try-catch with user feedback

## Current Capabilities

### ✅ Completed Features

1. **User Authentication System**
   - Email/password registration and login
   - JWT token-based security
   - Google OAuth2 integration
   - Role-based account types (Supplier, Buyer, Designer)
   - Secure password encryption (BCrypt)

2. **Database Architecture**
   - MySQL database with proper relationships
   - User and Product entities with full CRUD operations
   - Luxury fashion/cosmetics sample data pre-loaded
   - Supplier-product relationship management

3. **Security Implementation**
   - CORS configuration for mobile app
   - JWT token validation and refresh
   - Protected API endpoints
   - OAuth2 integration with Google

4. **Mobile App Foundation**
   - Responsive Flutter UI with luxury design
   - Authentication screens (login/register)
   - Local token management and persistence
   - Google Sign-In integration
   - Professional dark theme with gold accents

5. **API Infrastructure**
   - RESTful API endpoints
   - Comprehensive error handling
   - Token-based authentication middleware
   - OpenAPI/Swagger documentation

### 🚧 In Progress

1. **Documentation**: This capability overview document

### 📋 Planned Features

1. **Product Management**
   - Advanced product search and filtering
   - Image gallery and product variants
   - Inventory tracking and low-stock alerts
   - Bulk product operations

2. **Order Management**
   - Shopping cart functionality
   - Order placement and tracking
   - Invoice generation
   - Payment integration

3. **Real-time Features**
   - Live chat between buyers and suppliers
   - Real-time notifications
   - Inventory updates
   - Order status tracking

4. **Advanced Security**
   - Multi-factor authentication
   - API rate limiting
   - Audit logging
   - Data encryption at rest

5. **Analytics & Reporting**
   - Sales analytics dashboard
   - Inventory reports
   - User activity tracking
   - Performance metrics

## Technical Setup Requirements

### Backend Prerequisites
- Java 17+
- Maven 3.6+
- MySQL 8.0+
- Spring Boot 3.2.0

### Frontend Prerequisites
- Flutter 3.6.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Android SDK (for emulator)

### Environment Configuration
1. **MySQL Database**: Create `underground_terminal` database
2. **Google OAuth**: Configure client ID/secret in application.properties
3. **JWT Secret**: Update secret key in application.properties
4. **Flutter Dependencies**: Run `flutter pub get`

## Testing & Deployment

### Development Testing
- **Backend**: Maven test suite
- **Frontend**: Flutter test framework
- **Integration**: API endpoint testing via Swagger UI

### Deployment Readiness
- **Backend**: Spring Boot executable JAR
- **Frontend**: Android APK/iOS IPA build capability
- **Database**: Production MySQL configuration ready

## Market Alignment

The platform specifically addresses luxury fashion and cosmetics B2B requirements:

- **Exclusive Product Catalogs**: High-end fashion and premium cosmetics
- **Professional User Roles**: Suppliers, buyers, and designers
- **Quality Assurance**: Verified supplier system
- **Luxury Branding**: Professional dark theme with gold accents
- **Mobile-First**: Responsive design for on-the-go business professionals

This foundation provides a solid base for expanding into a comprehensive B2B luxury marketplace with real-time logistics, secure transactions, and advanced inventory management capabilities.
