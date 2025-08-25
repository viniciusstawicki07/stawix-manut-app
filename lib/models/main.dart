import 'package:flutter/material.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';

void main() {
  runApp(const SysManApp());
}

class SysManApp extends StatelessWidget {
  const SysManApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SysMan Manutenções',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      // Define a tela de login como a rota inicial
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
