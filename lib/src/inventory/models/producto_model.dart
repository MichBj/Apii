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
    );
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