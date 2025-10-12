class SupabaseConfig {
  // Replace these with your actual Supabase project credentials
  static const String supabaseUrl = 'https://kkpxfuddjchbipiyxhma.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrcHhmdWRkamNoYmlwaXl4aG1hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzNDc4MzcsImV4cCI6MjA3NDkyMzgzN30.C_1ykxjPeV2h5-hAQNhwfVgY15IXKfmLQ0cA8Ry9vUA';

  // Table names (adjust to match your Supabase tables)
  static const String productsTable = 'products';
  static const String usersTable = 'users';
  static const String ordersTable = 'orders';
}
