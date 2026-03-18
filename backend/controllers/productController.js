// controllers/productController.js
const db = require('../config/db');

// Crear producto (con imagen)
exports.createProduct = async (req, res) => {
  const { nombre, codigo, cantidad, precio } = req.body;
  const foto_url = req.file ? `/uploads/${req.file.filename}` : null;
  try {
    const [result] = await db.query(
      'INSERT INTO productos (nombre, codigo, cantidad, precio, foto_url) VALUES (?, ?, ?, ?, ?)',
      [nombre, codigo, cantidad, precio, foto_url]
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

// Listar inventario completo
exports.getAllProducts = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM productos');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener productos' });
  }
};

// Buscar producto por id, código o nombre
exports.findProduct = async (req, res) => {
  const { search } = req.query;
  try {
    const [rows] = await db.query(
      'SELECT * FROM productos WHERE id = ? OR codigo = ? OR nombre LIKE ?',
      [search, search, `%${search}%`]
    );
    if (rows.length > 0) res.json(rows);
    else res.status(404).json({ message: 'No encontrado' });
  } catch (error) {
    res.status(500).json({ message: 'Error en la búsqueda' });
  }
};

// Modificar producto
exports.updateProduct = async (req, res) => {
  const { id } = req.params;
  const { nombre, codigo, cantidad, precio } = req.body;
  const foto_url = req.file ? `/uploads/${req.file.filename}` : null;
  try {
    let sql = 'UPDATE productos SET nombre=?, codigo=?, cantidad=?, precio=?';
    let params = [nombre, codigo, cantidad, precio];
    if (foto_url) {
      sql += ', foto_url=?';
      params.push(foto_url);
    }
    sql += ' WHERE id=?';
    params.push(id);
    const [result] = await db.query(sql, params);
    res.json({ success: true, message: 'Producto actualizado' });
  } catch (error) {
    res.status(500).json({ message: 'Error al actualizar producto' });
  }
};