import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido, ${auth.userName}")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          if (auth.rol == 'admin') 
            _menuItem(context, Icons.add_a_photo, "Agregar Producto", '/add_product'),
          
          _menuItem(context, Icons.shopping_cart, "Nueva Venta", '/pos'),
          _menuItem(context, Icons.inventory, "Inventario", '/inventory'),
          _menuItem(context, Icons.location_on, "Geolocalización", '/geolocation'),
        ],
      ),
    );
  }

  // ...existing code...
  Widget _menuItem(BuildContext context, IconData icon, String label, String route) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}