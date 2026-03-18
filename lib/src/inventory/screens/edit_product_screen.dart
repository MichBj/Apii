import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/services/api_service.dart';
import '../models/producto_model.dart';

class EditProductScreen extends StatefulWidget {
  final Producto producto;
  const EditProductScreen({super.key, required this.producto});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _codigoController;
  late TextEditingController _cantidadController;

  XFile? _imageFile;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto.nombre);
    _precioController = TextEditingController(text: widget.producto.precio.toString());
    _codigoController = TextEditingController(text: widget.producto.codigo);
    _cantidadController = TextEditingController(text: widget.producto.cantidad.toString());
  }

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = image);
    }
  }

  void _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.producto.id == null) return;

    setState(() => _cargando = true);
    final messenger = ScaffoldMessenger.of(context);

    bool ok = await ApiService.modificarProducto(
      id: widget.producto.id!,
      nombre: _nombreController.text,
      precio: double.parse(_precioController.text.replaceAll('\$', '').replaceAll(',', '').trim()),
      codigo: _codigoController.text,
      cantidad: int.parse(_cantidadController.text),
      imagen: _imageFile,
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (ok) {
      messenger.showSnackBar(const SnackBar(content: Text('Producto actualizado')));
      Navigator.pop(context, true);
    } else {
      messenger.showSnackBar(const SnackBar(content: Text('Error al actualizar producto')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto')),
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
              onPressed: () => Navigator.pushReplacementNamed(context, '/inventory'),
              icon: const Icon(Icons.inventory),
              label: const Text('Inventario'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/pos'),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Ventas'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: kIsWeb
                              ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                              : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                        )
                      : widget.producto.imagen != null && widget.producto.imagen!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${ApiService.baseUrl.replaceAll('/api', '')}${widget.producto.imagen}',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                    Text('Tocar para cambiar foto'),
                                  ],
                                ),
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                                Text('Tocar para agregar foto'),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Código', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio', border: OutlineInputBorder(), prefixText: '\$'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _guardarCambios,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: _cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('GUARDAR CAMBIOS', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
