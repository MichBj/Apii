// controllers/productController.js
const db = require('../config/db');

exports.createProduct = async (req, res) => {
  const { nombre, descripcion, precio_unitario, categoria_id } = req.body;
  const imagen = req.file ? `/uploads/${req.file.filename}` : null;

  try {
    const [result] = await db.query(
      'INSERT INTO PRODUCTO (nombre, descripcion, precio_unitario, CATEGORIA_id_categoria, imagen) VALUES (?, ?, ?, ?, ?)',
      [nombre, descripcion, precio_unitario, categoria_id, imagen]
    );

    res.status(201).json({
      success: true,
      message: 'Producto creado',
      productId: result.insertId
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al crear producto' });
  }
};