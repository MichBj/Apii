// controllers/authController.js
const db = require('../config/db');

exports.login = async (req, res) => {
  const { cedula, password } = req.body;

  try {
    const [rows] = await db.query(
      'SELECT * FROM EMPLEADO WHERE cedula = ? AND activo = "S"',
      [cedula]
    );

    if (rows.length === 0) {
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    const user = rows[0];

    // Aquí deberías comparar contraseña con hash (bcrypt), pero por simplicidad usamos texto plano temporal
    if (password !== '123456') { // CAMBIA ESTO POR bcrypt.compare en producción
      return res.status(401).json({ message: 'Credenciales inválidas' });
    }

    // Devolvemos rol y datos básicos (puedes usar JWT aquí)
    res.json({
      success: true,
      user: {
        id: user.id_empleado,
        nombre: user.nombre,
        cargo: user.cargo,
        sucursal_id: user.SUCURSAL_id_sucursal
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error en el servidor' });
  }
};