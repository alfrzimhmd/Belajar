import 'package:flutter/material.dart';
import 'package:belajar_app1/pages/notif/notif_page.dart';
import 'counter/counter_page.dart';
import 'wordgenerate/wordgenerate_page.dart';
import 'calculator/calculator_page.dart';
import 'quotes/quotes_page.dart';
import 'draw/drawing_page.dart';
import 'notes/notes_page.dart';

/// Halaman utama aplikasi yang menampilkan navigation bar dan berbagai fitur
class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Index untuk menandai halaman yang sedang aktif
  int _selectedIndex = 0;

  // Daftar semua halaman/widget yang akan ditampilkan
  final List<Widget> _pages = [
    const CounterPage(),        
    const WordgeneratePage(),   
    const NotificationPage(),
    const CalculatorPage(),     
    const QuotesPage(),        
    const DrawingPage(),       
    const NotesPage(),         
  ];

  // Data untuk navigation item
  final List<NavigationItem> _navItems = [
    NavigationItem(icon: Icons.touch_app_outlined, label: 'Counter'),
    NavigationItem(icon: Icons.auto_awesome_outlined, label: 'Word Gen'),
    NavigationItem(icon: Icons.notifications_outlined, label: 'Test notif'),
    NavigationItem(icon: Icons.calculate_outlined, label: 'Calculator'),
    NavigationItem(icon: Icons.format_quote_outlined, label: 'Quotes'),
    NavigationItem(icon: Icons.brush_outlined, label: 'Drawing'),
    NavigationItem(icon: Icons.edit_note, label: 'Note'),
  ];

  /// Method untuk menangani ketika navigation item di-tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai dengan index yang dipilih
      body: _pages[_selectedIndex],
      // Bottom navigation bar yang responsive
      bottomNavigationBar: _buildResponsiveNavigationBar(),
    );
  }

  /// Membangun navigation bar yang responsive dengan scroll horizontal
  Widget _buildResponsiveNavigationBar() {
    return SafeArea(
      top: false,    // Tidak perlu safe area di atas
      bottom: true,  // Perlu safe area di bawah (untuk notch dll)
      minimum: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom, 
      ),
      child: Container(
        height: 70, 
        decoration: BoxDecoration(
          color: Colors.white, 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20), 
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        // Scroll horizontal untuk menampilkan banyak navigation items
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = index == _selectedIndex; 
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _NavItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => _onItemTapped(index), 
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Model data untuk navigation item
class NavigationItem {
  final IconData icon;  
  final String label;   

  NavigationItem({required this.icon, required this.label});
}

/// Widget untuk individual navigation item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;    
  final VoidCallback onTap; 

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handler tap gesture
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.blue[700]!, width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ukuran sesuai konten
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
            ),
            const SizedBox(width: 8), 
            // Label navigation
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.blue[700] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}