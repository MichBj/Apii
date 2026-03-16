// routes/productRoutes.js
const express = require('express');
const router = express.Router();
const db = require('../config/db');
const multer = require('multer');
const path = require('path');
const productController = require('../controllers/productController');


router.post('/', upload.single('imagen'), productController.createProduct);
// Configuración interna de multer para esta ruta
const storage = multer.diskStorage({
    destination: 'uploads/',
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});
const upload = multer({ storage });

// Agregar producto con foto
router.post('/add', upload.single('foto'), (req, res) => {
    const { nombre, codigo, cantidad, precio } = req.body;
    const foto_url = req.file ? `/uploads/${req.file.filename}` : null;

    const sql = "INSERT INTO productos (nombre, codigo, cantidad, precio, foto_url) VALUES (?, ?, ?, ?, ?)";
    db.query(sql, [nombre, codigo, cantidad, precio, foto_url], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Producto agregado' });
    });
});

// Buscar producto por código (Para la pestaña de ventas)
router.get('/:codigo', (req, res) => {
    const sql = "SELECT * FROM productos WHERE codigo = ?";
    db.query(sql, [req.params.codigo], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.length > 0) res.json(result[0]);
        else res.status(404).json({ message: 'No encontrado' });
    });
});
module.exports = router;