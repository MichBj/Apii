import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de Providers
import 'auth/providers/auth_provider.dart';
import 'sales/providers/carrito_provider.dart';

// Imports de Pantallas
import 'auth/screens/welcome_screen.dart';
import 'home_screen.dart';
import 'inventory/screens/add_product_screen.dart';
import 'sales/screens/scanner_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGVI App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // Agregamos 'const' antes de cada pantalla para solucionar los errores
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/scanner': (context) => const ScannerScreen(),
        '/add_product': (context) => const AddProductScreen(),
      },
    );
  }
}