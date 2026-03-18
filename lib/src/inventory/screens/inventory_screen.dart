import 'package:flutter/material.dart';
import '../../shared/services/api_service.dart';
import '../models/producto_model.dart';
import 'edit_product_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Producto> _productos = [];
  bool _cargando = true;
  String _busqueda = '';
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarInventario();
  }

  Future<void> _cargarInventario() async {
    setState(() => _cargando = true);
    final productos = _busqueda.isEmpty
        ? await ApiService.listarInventario()
        : await ApiService.buscarProducto(_busqueda);
    setState(() {
      _productos = productos;
      _cargando = false;
    });
  }

  void _buscar() {
    setState(() {
      _busqueda = _busquedaController.text.trim();
    });
    _cargarInventario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarInventario,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
              icon: const Icon(Icons.home),
              label: const Text('Inicio'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/add_product'),
              icon: const Icon(Icons.add_circle),
              label: const Text('Agregar'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/pos'),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Ventas'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_product');
          if (result == true) _cargarInventario();
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _busquedaController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por id, código o nombre',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _buscar(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscar,
                ),
              ],
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _productos.isEmpty
                    ? const Center(child: Text('No hay productos'))
                    : ListView.builder(
                        itemCount: _productos.length,
                        itemBuilder: (context, index) {
                          final p = _productos[index];
                          return ListTile(
                            leading: p.imagen != null && p.imagen!.isNotEmpty
                                ? Image.network(
                                    '${ApiService.baseUrl.replaceAll('/api', '')}${p.imagen}',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(p.nombre),
                            subtitle: Text('Código: ${p.codigo}\nCantidad: ${p.cantidad}\nPrecio: \$${p.precio}'),
                            isThreeLine: true,
                            trailing: const Icon(Icons.edit, color: Colors.blue),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProductScreen(producto: p),
                                ),
                              );
                              if (result == true) _cargarInventario();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
