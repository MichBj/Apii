import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class WelcomeScreen extends StatelessWidget {
  // 1. Agregamos el constructor con la Key (Soluciona el error de severity 8)
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Agregué Center para que se vea mejor
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. Agregamos 'const' a los widgets que no cambian
            const Text(
              "SGVI - Gestión de Ventas",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().login("Michael", "admin");
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text("Ingresar como Admin"),
            ),
            
            const SizedBox(height: 10), // Un pequeño espacio entre botones
            
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().login("Empleado 1", "vendedor");
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text("Ingresar como Vendedor"),
            ),
          ],
        ),
      ),
    );
  }
}