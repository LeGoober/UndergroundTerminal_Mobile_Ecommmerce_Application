# Underground Terminal - Agent Guidelines

## Commands
- **Flutter**: `flutter run`, `flutter test`, `flutter test test/specific_test.dart`, `flutter build apk`, `flutter analyze`
- **Spring Boot**: `mvn spring-boot:run`, `mvn test`, `mvn test -Dtest=SpecificTest`, `mvn clean package`
- **Dependencies**: `flutter pub get`, `flutter pub add <package>`, `mvn clean install`

## Architecture
- **Frontend**: Flutter mobile app (iPhone 14: 390x844px) with Provider/Riverpod state management
- **Backend**: Spring Boot REST API with JPA/H2, endpoints at `/api/products`, `/api/users`, `/api/orders`
- **Key Models**: Product (id, name, price, imageUrl, supplierId), User (id, role, name), Order
- **Services**: ApiService for HTTP calls, state management for real-time features

## Code Style
- **Colors**: Primary #FFD700 (gold), Background #121212 (dark), Text #FFFFFF/#B3B3B3
- **Typography**: Playfair Display (headings), Montserrat (body) via google_fonts package  
- **Naming**: camelCase for variables/methods, PascalCase for classes, snake_case for files
- **Imports**: flutter material first, packages, then relative imports
- **Error Handling**: try-catch with meaningful error messages, loading states in UI
- **Components**: Reusable widgets with proper separation of concerns, stateless when possible

## Structure
- `lib/`: main.dart, screens/, models/, services/, widgets/
- `src/main/java/`: entities/, repositories/, controllers/, services/
- Key screens: SplashScreen, LoginScreen, DashboardScreen, ProductDetailScreen, CartScreen
