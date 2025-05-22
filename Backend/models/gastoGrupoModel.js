const db = require('../db');

const getAllGastosGrupo = async () => {
  const res = await (await db).query('SELECT * FROM gastos_grupo');
  return res.rows;
};

const getGastosByGrupo = async (idGrupo) => {
  const res = await (await db).query(
    'SELECT * FROM gastos_grupo WHERE idgrupo = $1',
    [idGrupo]
  );
  return res.rows;
};

const createGastoGrupo = async (gasto) => {
  const { descripcion, monto, fecha, idcategoria, idgrupo } = gasto;
  const res = await (await db).query(
    `INSERT INTO gastos_grupo (descripcion, monto, fecha, idcategoria, idgrupo)
     VALUES ($1, $2, $3, $4, $5) RETURNING *`,
    [descripcion, monto, fecha, idcategoria, idgrupo]
  );
  return res.rows[0];
};

const deleteGastoGrupo = async (id) => {
  const res = await (await db).query(
    'DELETE FROM gastos_grupo WHERE id = $1 RETURNING *',
    [id]
  );
  return res.rows[0];
};

module.exports = {
  getAllGastosGrupo,
  getGastosByGrupo,
  createGastoGrupo,
  deleteGastoGrupo
};
