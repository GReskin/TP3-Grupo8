const dbPromise = require('./db');

const getAllCategorias = async () => {
  const db = await dbPromise;
  const res = await db.query('SELECT * FROM categorias_gasto');
  return res.rows;
};

const getCategoriaById = async (id) => {
  const db = await dbPromise;
  const res = await db.query('SELECT * FROM categorias_gasto WHERE id = $1', [id]);
  return res.rows[0];
};

const createCategoria = async ({ nombre }) => {
  const db = await dbPromise;
  const res = await db.query(
    `INSERT INTO categorias_gasto (nombre)
     VALUES ($1)
     RETURNING *`,
    [nombre]
  );
  return res.rows[0];
};

const updateCategoria = async (id, { nombre }) => {
  const db = await dbPromise;
  const res = await db.query(
    `UPDATE categorias_gasto SET nombre = $1
     WHERE id = $2
     RETURNING *`,
    [nombre, id]
  );
  return res.rows[0];
};

const deleteCategoria = async (id) => {
  const db = await dbPromise;
  const res = await db.query(
    'DELETE FROM categorias_gasto WHERE id = $1 RETURNING *',
    [id]
  );
  return res.rows[0];
};

module.exports = {
  getAllCategorias,
  getCategoriaById,
  createCategoria,
  updateCategoria,
  deleteCategoria,
};
