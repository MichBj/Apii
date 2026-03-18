import 'dart:convert';
import 'package:flutter/foundation.dart'; // Importante para debugPrint
import 'package:http/http.dart' as http;

class Producto {
  final int? id;
  final String nombre;
  final double precio;
  final String codigo;
  final String? imagen;
  final int cantidad;

  Producto({
    this.id,
    required this.nombre,
    required this.precio,
    required this.codigo,
    this.imagen,
    this.cantidad = 1,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      nombre: json['nombre']?.toString() ?? '',
      precio: double.tryParse(json['precio']?.toString() ?? '0.0') ?? 0.0,
      codigo: json['codigo']?.toString() ?? '',
      imagen: json['imagen'],
      cantidad: json['cantidad'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'codigo': codigo,
      'imagen': imagen,
      'cantidad': cantidad,
    };
  }

  Producto copyWith({int? cantidad}) {
    return Producto(
      id: id,
      nombre: nombre,
      precio: precio,
      codigo: codigo,
      imagen: imagen,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}

// --- FUNCIÓN DE GUARDADO SIN ADVERTENCIAS ---

Future<void> guardarProducto(Producto producto) async {
  // Recuerda: Usa tu IP local si pruebas en físico, ej: 'http://192.168.1.10:3000...'
  final url = Uri.parse('http://localhost:3000/api/productos');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Éxito: Producto ${producto.nombre} guardado.");
    } else {
      debugPrint("Error de servidor: Status ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Error de red: $e");
  }
}