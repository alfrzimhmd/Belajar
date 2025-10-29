import '../pages/main_page.dart';
import 'package:flutter/material.dart';
import 'splashscreen/splashscreen.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';

/// Fungsi main - entry point aplikasi Flutter
void main(){
  // Memastikan binding Flutter diinisialisasi sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Menjalankan aplikasi
  runApp(const MyApp());
}

/// Root widget dari aplikasi
class MyApp extends StatelessWidget{
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      // Menyembunyikan banner debug di corner
      debugShowCheckedModeBanner: false,

      // Nama aplikasi
      title: 'Belajar Flutter',

      // Rute awal yang akan ditampilkan saat aplikasi pertama kali dibuka
      initialRoute: '/splash',

      // Daftar rute yang tersedia dalam aplikasi
      routes: {
        // Rute splash screen - tampilan pertama
        '/splash': (context) => const SplashScreen(),

        // Rute halaman login
        '/login' : (context) => const LoginPage(),

        // Rute halaman registrasi
        '/register' : (context) => const RegisterPage(),

        // Rute halaman utama setelah login
        '/main' : (context) => const MainPage(),
      },
    );
  }
}