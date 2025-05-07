require('dotenv').config();
const express = require('express');
const cors = require('cors');
const dbPromise = require('./models/db');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());

//Middleware de logs
app.use((req, res, next) => {
  console.log(`[${req.method}] ${req.url}`);
  next();
});

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
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`✅ Servidor corriendo en http://0.0.0.0:${PORT}`);
    });
  } catch (err) {
    console.error('❌ Error iniciando la app:', err);
    process.exit(1);
  }
})();
