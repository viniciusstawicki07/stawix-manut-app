import 'package:flutter/material.dart';
import 'package:manutencao_bj_app/screens/os_edit/os_edit_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/os_details/os_details_screen.dart'; // Importe a nova tela

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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/os_details': (context) => const OsDetailsScreen(),
        '/os_edit': (context) => const OsEditScreen(),// Adicione esta linha
      },
    );
  }
}
