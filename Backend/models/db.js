const { Pool, Client } = require('pg');
require('dotenv').config();

const {
  DB_HOST,
  DB_USER,
  DB_PASSWORD,
  DB_NAME,
  DB_PORT
} = process.env;

async function createDatabaseIfNotExists() {
  const client = new Client({
    host: DB_HOST,
    user: DB_USER,
    password: DB_PASSWORD,
    port: DB_PORT,
    database: 'postgres',
  });

  await client.connect();

  const res = await client.query(
    `SELECT 1 FROM pg_database WHERE datname = $1`,
    [DB_NAME]
  );

  if (res.rowCount === 0) {
    console.log(`⚙️  Creando base de datos "${DB_NAME}"...`);
    await client.query(`CREATE DATABASE ${DB_NAME}`);
    console.log(`✅ Base de datos "${DB_NAME}" creada`);
  }

  await client.end();
}

async function createTablesIfNotExist(pool) {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS usuarios (
      id SERIAL PRIMARY KEY,
      usuario VARCHAR(100) NOT NULL,
      contraseña VARCHAR(100) NOT NULL,
      fecha_nacimiento DATE NOT NULL,
      email VARCHAR(100) UNIQUE NOT NULL
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS categorias_gasto (
      id SERIAL PRIMARY KEY,
      nombre VARCHAR(100) NOT NULL
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS gastos (
      id SERIAL PRIMARY KEY,
      descripcion TEXT NOT NULL,
      monto NUMERIC(10, 2) NOT NULL,
      fecha DATE NOT NULL,
      idcategoria INTEGER REFERENCES categorias_gasto(id),
      idusuario INTEGER REFERENCES usuarios(id)
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS grupos (
      id SERIAL PRIMARY KEY,
      nombre VARCHAR(100) NOT NULL,
      creador_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS usuario_grupos (
      grupo_id INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
      usuario_id INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
      PRIMARY KEY (grupo_id, usuario_id)
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS gastos_grupo (
      id SERIAL PRIMARY KEY,
      descripcion TEXT NOT NULL,
      monto NUMERIC(10, 2) NOT NULL,
      fecha DATE NOT NULL,
      idcategoria INTEGER REFERENCES categorias_gasto(id),
      idgrupo INTEGER REFERENCES grupos(id)
    );
  `);

  console.log('✅ Tablas creadas o ya existentes');
}

const initDb = (async () => {
  await createDatabaseIfNotExists();

  const pool = new Pool({
    host: DB_HOST,
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_NAME,
    port: DB_PORT,
  });

  await createTablesIfNotExist(pool);

  return pool;
})();

module.exports = initDb;