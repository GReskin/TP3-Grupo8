require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const dbPromise = require('./models/db');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());

// Rutas
app.use('/api/usuarios', require('./routes/userRoutes'));
app.use('/api/categorias', require('./routes/categoriaRoutes'));
app.use('/api/gastos', require('./routes/gastoRoutes'));

// Ruta de prueba
app.get('/', (req, res) => {
  res.send('API de gastos funcionando 🚀');
});

// Inicialización del servidor
(async () => {
  try {
    // Espera a que se cree la base de datos y las tablas
    await dbPromise;
    app.listen(PORT, () => {
      console.log(`✅ Servidor corriendo en http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('❌ Error iniciando la app:', err);
    process.exit(1);
  }
})();
