import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'statistik/statistik_page.dart';
import 'produk/produk_page.dart';
import 'settings/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    const DashboardPage(),
    const StatisticsPage(),
    const ProductsPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    
    setState(() => _selectedIndex = index);
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        physics: const ClampingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20), // withAlpha bukan withOpacity
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0A4DA2),
            unselectedItemColor: Colors.black.withAlpha(153), // ~60% opacity
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              _buildBottomNavItem(
                0, 
                Icons.dashboard_outlined, 
                Icons.dashboard, 
                'Dashboard'
              ),
              _buildBottomNavItem(
                1, 
                Icons.bar_chart_outlined, 
                Icons.bar_chart, 
                'Statistik'
              ),
              _buildBottomNavItem(
                2, 
                Icons.shopping_bag_outlined, 
                Icons.shopping_bag, 
                'Produk'
              ),
              _buildBottomNavItem(
                3, 
                Icons.settings_outlined, 
                Icons.settings, 
                'Pengaturan'
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    int index, 
    IconData icon, 
    IconData activeIcon, 
    String label
  ) {
    final isActive = _selectedIndex == index;
    
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..scale(isActive ? 1.1 : 1.0),
        child: Icon(
          icon,
          size: isActive ? 24 : 22,
          color: isActive 
              ? const Color(0xFF0A4DA2) 
              : Colors.black.withAlpha(153),
        ),
      ),
      activeIcon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..scale(isActive ? 1.1 : 1.0),
        child: Icon(
          activeIcon,
          size: isActive ? 24 : 22,
          color: const Color(0xFF0A4DA2),
        ),
      ),
      label: label,
    );
  }
}