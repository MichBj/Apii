// routes/authRoutes.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/login', authController.login);
const express = require('express');

const db = require('../config/db');

// Registro de usuario
router.post('/register', (req, res) => {
    const { nombre, correo, password, rol } = req.body;
    const sql = "INSERT INTO usuarios (nombre, correo, password, rol) VALUES (?, ?, ?, ?)";
    db.query(sql, [nombre, correo, password, rol], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Usuario registrado exitosamente' });
    });
});

// Login
router.post('/login', (req, res) => {
    const { correo, password } = req.body;
    const sql = "SELECT id, nombre, rol FROM usuarios WHERE correo = ? AND password = ?";
    db.query(sql, [correo, password], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.length > 0) {
            res.json(result[0]); // Devuelve {id, nombre, rol}
        } else {
            res.status(401).json({ message: 'Credenciales inválidas' });
        }
    });
});

module.exports = router;

