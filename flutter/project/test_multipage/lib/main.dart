import 'package:flutter/material.dart';
import 'splashscreen/splashscreen.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';
import '../../pages/main_page.dart';
import '../../pages/notif/notification_helper.dart';

/// Fungsi main - entry point aplikasi Flutter
void main() async {
  // Memastikan binding Flutter diinisialisasi sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi notifikasi
  await NotificationHelper.initialize();

  runApp(const MyApp());
}

/// Root widget dari aplikasi
class MyApp extends StatelessWidget{
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Flutter 1',

      // Rute awal yang akan ditampilkan saat aplikasi pertama kali dibuka
      initialRoute: '/splash',

      // Daftar rute
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login' : (context) => const LoginPage(),
        '/register' : (context) => const RegisterPage(),
        '/main' : (context) => const MainPage(),
      },
    );
  }
}