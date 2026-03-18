// routes/productRoutes.js
const express = require('express');
const router = express.Router();
const db = require('../config/db');
const multer = require('multer');
const path = require('path');
const productController = require('../controllers/productController');

// Configuración de multer para subida de imágenes
const storage = multer.diskStorage({
  destination: 'uploads/',
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage });

// Crear producto (admin o invitado)
router.post('/', upload.single('foto'), productController.createProduct);

// Listar inventario completo
router.get('/', productController.getAllProducts);

// Buscar producto por id, código o nombre
router.get('/buscar', productController.findProduct);

// Modificar producto
router.put('/:id', upload.single('foto'), productController.updateProduct);

module.exports = router;