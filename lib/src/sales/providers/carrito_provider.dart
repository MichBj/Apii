import 'package:flutter/material.dart';
import '../../inventory/models/producto_model.dart';

class CarritoProvider with ChangeNotifier {
  // Lista privada de productos en el carrito
  final List<Producto> _items = [];

  // Getter para obtener los productos
  List<Producto> get items => [..._items];

  // GETTER QUE FALTABA: Calcula el total de la venta
  double get totalPagar {
    double total = 0.0;
    for (var item in _items) {
      total += item.precio * item.cantidad;
    }
    return total;
  }

  // Método para agregar o incrementar cantidad
  void agregarProducto(Producto producto) {
    // Verificar si ya existe en el carrito por su código
    final index = _items.indexWhere((item) => item.codigo == producto.codigo);

    if (index >= 0) {
      // Si existe, aumentamos la cantidad usando copyWith
      _items[index] = _items[index].copyWith(
        cantidad: _items[index].cantidad + 1,
      );
    } else {
      // Si no existe, lo agregamos
      _items.add(producto);
    }
    notifyListeners(); // Notifica a la UI para redibujar
  }

  void limpiarCarrito() {
    _items.clear();
    notifyListeners();
  }

  void eliminarProducto(String codigo) {
    _items.removeWhere((item) => item.codigo == codigo);
    notifyListeners();
  }
}