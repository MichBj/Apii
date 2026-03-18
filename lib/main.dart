import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'src/auth/providers/auth_provider.dart';
import 'src/sales/providers/carrito_provider.dart';

// Screens
import 'src/auth/screens/welcome_screen.dart';
import 'src/home_screen.dart';
import 'src/inventory/screens/add_product_screen.dart';
import 'src/inventory/screens/inventory_screen.dart';
import 'src/shared/screens/geolocation_screen.dart';
import 'src/sales/screens/scanner_screen.dart';
import 'src/sales/screens/venta_pos.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/scanner': (context) => const ScannerScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/pos': (context) => const VentaPOS(),
        '/inventory': (context) => const InventoryScreen(),
        '/geolocation': (context) => const GeolocationScreen(),
      },
    );
  }
}