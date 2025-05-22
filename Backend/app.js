require('dotenv').config();
const express = require('express');
const cors = require('cors');
const dbPromise = require('./models/db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
  console.log(`[${req.method}] ${req.url}`);
  next();
});

let pool;

(async () => {
  try {
    pool = await dbPromise;

    // Rutas que necesitan pool

    app.get('/api/grupos', async (req, res) => {
      try {
        const result = await pool.query('SELECT * FROM grupos');
        res.json(result.rows);
      } catch (error) {
        console.error('Error al obtener grupos:', error);
        res.status(500).json({ error: 'Error al obtener grupos' });
      }
    });

    app.post('/api/grupos', async (req, res) => {
      const { nombre, creador_id, usuarios } = req.body;

      try {
        const result = await pool.query(
          'INSERT INTO grupos (nombre, creador_id) VALUES ($1, $2) RETURNING id',
          [nombre, creador_id]
        );

        const grupoId = result.rows[0].id;

        const usuariosAInsertar = [creador_id, ...usuarios];

        const inserts = usuariosAInsertar.map(usuarioId =>
          pool.query('INSERT INTO usuario_grupos (grupo_id, usuario_id) VALUES ($1, $2)', [
            grupoId,
            usuarioId,
          ])
        );

        await Promise.all(inserts);

        res.status(201).json({ message: 'Grupo creado correctamente' });
      } catch (error) {
        console.error('Error al crear grupo:', error);
        res.status(500).json({ error: 'Error al crear grupo' });
      }
    });

    // Otras rutas
    app.use('/api/usuarios', require('./routes/userRoutes'));
    app.use('/api/categorias', require('./routes/categoriaRoutes'));
    app.use('/api/gastos', require('./routes/gastoRoutes'));
    app.use('/api/gastos_grupo', require('./routes/gastosGrupoRoutes'));
    app.get('/api/usuarios/:usuario_id/grupos', async (req, res) => {
  const usuario_id = parseInt(req.params.usuario_id, 10);

  if (isNaN(usuario_id)) {
    return res.status(400).json({ error: 'ID de usuario inválido' });
  }

  try {
    const result = await pool.query(
      `SELECT g.* FROM grupos g
       JOIN usuario_grupos ug ON g.id = ug.grupo_id
       WHERE ug.usuario_id = $1`,
      [usuario_id]
    );

    res.json(result.rows);
  } catch (error) {
    console.error('Error al obtener los grupos del usuario:', error);
    res.status(500).json({ error: 'Error al obtener los grupos del usuario' });
  }
});

    

    // Ruta de prueba
    app.get('/', (req, res) => {
      res.send('API de gastos funcionando 🚀');
    });

    app.listen(PORT, '0.0.0.0', () => {
      console.log(`Servidor corriendo en http://0.0.0.0:${PORT}`);
    });

  } catch (error) {
    console.error('Error inicializando DB:', error);
    process.exit(1);
  }
})();
