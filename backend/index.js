const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root', 
    password: '1230', 
    database: 'sgvi_db'
});
const productRoutes = require('./routes/productRoutes');
app.use('/api', productRoutes);

// LOGIN: Valida credenciales y devuelve el ROL
app.post('/login', (req, res) => {
    const { correo, password } = req.body;
    const sql = "SELECT nombre, rol FROM usuarios WHERE correo = ? AND password = ?";
    db.query(sql, [correo, password], (err, result) => {
        if (result.length > 0) {
            res.json(result[0]); // Devuelve {nombre, rol}
        } else {
            res.status(401).send("Credenciales incorrectas");
        }
    });
});

// REGISTRO: Guarda nuevos usuarios con su ROL
app.post('/register', (req, res) => {
    const { nombre, correo, password, rol } = req.body;
    const sql = "INSERT INTO usuarios (nombre, correo, password, rol) VALUES (?, ?, ?, ?)";
    db.query(sql, [nombre, correo, password, rol], (err) => {
        if (err) return res.status(500).send(err);
        res.status(201).send("Usuario creado");
    });
});

app.listen(3000, () => console.log("Servidor corriendo en el puerto 3000"));