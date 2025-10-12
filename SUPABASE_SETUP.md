# Supabase Integration Setup

## 1. Get Your Supabase Credentials

From your Supabase dashboard:
1. Go to **Settings** → **API**
2. Copy your **Project URL** and **anon public key**

## 2. Configure Flutter App

Update `mobile/lib/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
  
  // Update table names to match your Supabase tables
  static const String productsTable = 'products';
  static const String usersTable = 'users';
  static const String ordersTable = 'orders';
}
```

## 3. Configure Spring Boot Backend

Update `backend/src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://db.your-project.supabase.co:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=your-database-password
```

## 4. Create Tables in Supabase

Run these SQL commands in your Supabase SQL editor:

```sql
-- Users table
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT,
  role TEXT NOT NULL CHECK (role IN ('SUPPLIER', 'BUYER', 'DESIGNER')),
  image_url TEXT,
  bio TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Products table
CREATE TABLE products (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  image_url TEXT,
  supplier_id BIGINT REFERENCES users(id),
  description TEXT,
  stock_level INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policies (adjust as needed)
CREATE POLICY "Users can view all profiles" ON users FOR SELECT USING (true);
CREATE POLICY "Products are viewable by everyone" ON products FOR SELECT USING (true);
```

## 5. Features Enabled

✅ **Real-time updates** - Products sync automatically across devices
✅ **Authentication** - Secure login/signup with Supabase Auth
✅ **PostgreSQL** - Production-ready database
✅ **Both Flutter & Spring Boot** - Choose your preferred backend
✅ **B2B features** - Multi-user roles (Supplier, Buyer, Designer)

## 6. Run the Applications

```bash
# Install Flutter dependencies
cd mobile
flutter pub get

# Run Flutter app
flutter run

# Run Spring Boot (optional - you can use Supabase directly)
cd backend
mvn spring-boot:run
```

## 7. Next Steps

- Set up RLS policies for your business logic
- Configure email templates in Supabase Auth
- Add file storage for product images
- Implement real-time chat features
