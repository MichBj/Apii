import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart'; 
import '../../shared/services/api_service.dart';
import '../../inventory/models/producto_model.dart'; // Ahora sí se usa aquí abajo
import '../providers/carrito_provider.dart';

class VentaPOS extends StatefulWidget {
  const VentaPOS({super.key});

  @override
  State<VentaPOS> createState() => _VentaPOSState();
}

class _VentaPOSState extends State<VentaPOS> {
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    // RECURSO NATIVO: Acelerómetro para vaciar carrito al agitar el teléfono
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Sensibilidad: si se agita fuerte en el eje X o Y
      if (event.x.abs() > 25 || event.y.abs() > 25) {
        _dialogoLimpiar();
      }
    });
  }

  void _buscarProducto(String code) async {
    if (code.isEmpty) return;
    
    setState(() => _buscando = true);
    
    // Al declarar la variable como "Producto?", el import ya no sale como "unused"
    final Producto? producto = await ApiService.buscarPorCodigo(code);
    
    if (!mounted) return; // Seguridad para evitar errores si cierras la pantalla
    setState(() => _buscando = false);

    if (producto != null) {
      Provider.of<CarritoProvider>(context, listen: false).agregarProducto(producto);
      _searchController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${producto.nombre} agregado'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto no encontrado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _dialogoLimpiar() {
    final carrito = Provider.of<CarritoProvider>(context, listen: false);
    if (carrito.items.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Limpiar Carrito?'),
        content: const Text('Se detectó agitación. ¿Deseas vaciar la venta actual?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('NO')),
          TextButton(
            onPressed: () {
              carrito.limpiarCarrito();
              Navigator.pop(ctx);
            }, 
            child: const Text('SÍ, VACIAR', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel(); // Liberar memoria del sensor
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Venta POS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _dialogoLimpiar,
          )
        ],
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _buscarProducto,
              decoration: InputDecoration(
                labelText: 'Escanear Código de Barras',
                prefixIcon: const Icon(Icons.qr_code_scanner),
                suffixIcon: _buscando ? const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ) : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // Lista de Productos
          Expanded(
            child: carrito.items.isEmpty 
              ? const Center(child: Text('El carrito está vacío'))
              : ListView.builder(
                  itemCount: carrito.items.length,
                  itemBuilder: (ctx, i) {
                    final item = carrito.items[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${item.cantidad}')),
                      title: Text(item.nombre),
                      subtitle: Text('Precio: \$${item.precio.toStringAsFixed(2)}'),
                      trailing: Text('\$${(item.precio * item.cantidad).toStringAsFixed(2)}', 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
          ),

          // Total y Finalizar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('\$${carrito.totalPagar.toStringAsFixed(2)}', 
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: carrito.items.isEmpty ? null : () {
                      // Próximo paso: Registrar la venta en MySQL
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text('FINALIZAR VENTA'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}