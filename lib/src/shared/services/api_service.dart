import 'dart:convert';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../inventory/models/producto_model.dart'; 

class ApiService {
  static const String baseUrl = "http://localhost/api"; 

  // Crea producto con compresión de imagen nativa
  static Future<bool> crearProducto({
    required String nombre,
    required double precio,
    required String codigo,
    XFile? imagen,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/productos.php');
      var request = http.MultipartRequest('POST', url);

      request.fields['nombre'] = nombre;
      request.fields['precio'] = precio.toString();
      request.fields['codigo'] = codigo;

      if (imagen != null) {
        // COMPRESIÓN NATIVA: Reduce el peso antes de subir a MySQL
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          imagen.path,
          minWidth: 800,
          minHeight: 600,
          quality: 70,
        );
        
        if (compressedBytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'imagen',
            compressedBytes,
            filename: imagen.name,
          ));
        }
      }

      var response = await request.send();
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint("Error ApiService (Crear): $e");
      return false;
    }
  }

  // Busca producto por código de barras
  static Future<Producto?> buscarPorCodigo(String codigo) async {
    try {
      final url = Uri.parse('$baseUrl/productos.php?codigo=$codigo');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Producto.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint("Error ApiService (Buscar): $e");
      return null;
    }
  }
}