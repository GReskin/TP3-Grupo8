const dbPromise = require('./db');

const getAllGastos = async () => {
  const db = await dbPromise;
  const res = await db.query(`
    SELECT g.*, u.usuario, c.nombre AS categoria
    FROM gastos g
    JOIN usuarios u ON g.idusuario = u.id
    JOIN categorias_gasto c ON g.idcategoria = c.id
    ORDER BY g.fecha DESC
  `);
  return res.rows;
};

const getAllGastosByUser = async (id) => {
  const db = await dbPromise;
  const res = await db.query(`
   SELECT * FROM gastos
   WHERE idusuario = $1
  `, [id]);
  return res.rows;
}


const getGastoById = async (id) => {
  const db = await dbPromise;
  const res = await db.query(`
    SELECT g.*, u.usuario, c.nombre AS categoria
    FROM gastos g
    JOIN usuarios u ON g.idusuario = u.id
    JOIN categorias_gasto c ON g.idcategoria = c.id
    WHERE g.id = $1
  `, [id]);
  return res.rows[0];
};

const createGasto = async ({ descripcion, monto, fecha, idcategoria, idusuario }) => {
  const db = await dbPromise;
  const res = await db.query(`
    INSERT INTO gastos (descripcion, monto, fecha, idcategoria, idusuario)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING *`,
    [descripcion, monto, fecha, idcategoria, idusuario]
  );
  return res.rows[0];
};

const updateGasto = async (id, { descripcion, monto, fecha, idcategoria, idusuario }) => {
  const db = await dbPromise;
  const res = await db.query(`
    UPDATE gastos SET
      descripcion = $1,
      monto = $2,
      fecha = $3,
      idcategoria = $4,
      idusuario = $5
    WHERE id = $6
    RETURNING *`,
    [descripcion, monto, fecha, idcategoria, idusuario, id]
  );
  return res.rows[0];
};

const deleteGasto = async (id) => {
  const db = await dbPromise;
  const res = await db.query('DELETE FROM gastos WHERE id = $1 RETURNING *', [id]);
  return res.rows[0];
};

module.exports = {
  getAllGastos,
  getGastoById,
  createGasto,
  updateGasto,
  deleteGasto,
  getAllGastosByUser
};
