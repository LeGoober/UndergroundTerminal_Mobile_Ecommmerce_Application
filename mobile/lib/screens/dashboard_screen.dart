import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      // Fallback to mock data when API fails
      _products = _getMockProducts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Using offline mode: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        name: 'Luxury Watch',
        price: 2500.00,
        imageUrl: 'https://images.unsplash.com/photo-1605792657660-596af9009a3d?auto=format&fit=crop&w=600&q=80',
        supplierId: 1,
        description: 'Premium Swiss luxury watch',
        stockLevel: 5,
      ),
      Product(
        id: 2,
        name: 'Designer Handbag',
        price: 1800.00,
        imageUrl: 'https://images.unsplash.com/photo-1618354691417-1b6a1f0e1e3f?auto=format&fit=crop&w=600&q=80',
        supplierId: 2,
        description: 'Exclusive designer handbag',
        stockLevel: 3,
      ),
      Product(
        id: 3,
        name: 'Diamond Necklace',
        price: 5500.00,
        imageUrl: 'https://images.unsplash.com/photo-1618354691417-1b6a1f0e1e3f?auto=format&fit=crop&w=600&q=80',
        supplierId: 1,
        description: 'Exquisite diamond necklace',
        stockLevel: 2,
      ),
      Product(
        id: 4,
        name: 'Silk Scarf',
        price: 450.00,
        imageUrl: 'https://images.unsplash.com/photo-1621607514816-2f9c5f6e1e3f?auto=format&fit=crop&w=600&q=80',
        supplierId: 3,
        description: 'Premium silk scarf',
        stockLevel: 8,
      ),
    ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on selected index
    switch (index) {
      case 0:
        // Home - already here, just refresh
        break;
      case 1:
        // Search - show search functionality
        _showSearch();
        break;
      case 2:
        // Cart - show cart
        _showCart();
        break;
      case 3:
        // Profile - show profile
        _showProfile();
        break;
    }
  }

  void _showSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search feature coming soon!')),
    );
  }

  void _showCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cart feature coming soon!')),
    );
  }

  void _showProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Underground Terminal',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.accent.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trending Products',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Discover the latest luxury items',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(product: _products[index]);
                        },
                        childCount: _products.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100), // Bottom padding
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
