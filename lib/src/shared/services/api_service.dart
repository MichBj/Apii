import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../inventory/models/producto_model.dart';

class ApiService {
  static const String baseUrl = "http://192.168.137.1:5000/api";

  // Crear producto (con imagen, para admin o invitado)
  static Future<bool> crearProducto({
    required String nombre,
    required double precio,
    required String codigo,
    required int cantidad,
    XFile? imagen,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/productos');
      var request = http.MultipartRequest('POST', url);
      request.fields['nombre'] = nombre;
      request.fields['precio'] = precio.toString();
      request.fields['codigo'] = codigo;
      request.fields['cantidad'] = cantidad.toString();
      if (imagen != null) {
        final bytes = await imagen.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'foto',
          bytes,
          filename: imagen.name,
        ));
      }
      var response = await request.send();
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint("Error ApiService (Crear): $e");
      return false;
    }
  }

  // Listar inventario completo
  static Future<List<Producto>> listarInventario() async {
    try {
      final url = Uri.parse('$baseUrl/productos');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Producto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error ApiService (Listar): $e");
      return [];
    }
  }

  // Buscar producto por id, código o nombre
  static Future<List<Producto>> buscarProducto(String search) async {
    try {
      final url = Uri.parse('$baseUrl/productos/buscar?search=$search');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Producto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error ApiService (Buscar): $e");
      return [];
    }
  }

  // Modificar producto (con imagen opcional)
  static Future<bool> modificarProducto({
    required int id,
    required String nombre,
    required double precio,
    required String codigo,
    required int cantidad,
    XFile? imagen,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/productos/$id');
      var request = http.MultipartRequest('PUT', url);
      request.fields['nombre'] = nombre;
      request.fields['precio'] = precio.toString();
      request.fields['codigo'] = codigo;
      request.fields['cantidad'] = cantidad.toString();
      if (imagen != null) {
        final bytes = await imagen.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'foto',
          bytes,
          filename: imagen.name,
        ));
      }
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error ApiService (Modificar): $e");
      return false;
    }
  }
}