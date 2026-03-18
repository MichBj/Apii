import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/services/api_service.dart';

// Verifica que este nombre coincida exactamente con el de main.dart
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  
  XFile? _imageFile;
  bool _cargando = false;

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _cargando = true);
    final messenger = ScaffoldMessenger.of(context);

    bool ok = await ApiService.crearProducto(
      nombre: _nombreController.text,
      precio: double.parse(_precioController.text.replaceAll('\$', '').replaceAll(',', '').trim()),
      codigo: _codigoController.text,
      cantidad: 1, // Puedes cambiarlo por un campo si tienes input de cantidad
      imagen: _imageFile,
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (ok) {
      messenger.showSnackBar(const SnackBar(content: Text('Producto guardado correctamente')));
      Navigator.pop(context, true);
    } else {
      messenger.showSnackBar(const SnackBar(content: Text('Error al guardar producto')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Producto')),
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
                  child: _imageFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            Text('Tocar para tomar foto'),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: kIsWeb 
                            ? Image.network(_imageFile!.path, fit: BoxFit.cover) 
                            : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(labelText: 'Código de Barras', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Producto', border: OutlineInputBorder()),
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
                  onPressed: _cargando ? null : _guardarProducto,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: _cargando 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('GUARDAR EN MYSQL', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}