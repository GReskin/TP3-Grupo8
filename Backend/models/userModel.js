const dbPromise = require('./db');

const getAllUsers = async () => {
  const db = await dbPromise;
  const res = await db.query('SELECT * FROM usuarios');
  return res.rows;
};

const getUserById = async (id) => {
  const db = await dbPromise;
  const res = await db.query('SELECT * FROM usuarios WHERE id = $1', [id]);
  return res.rows[0];
};

const createUser = async ({ usuario, contraseña, fecha_nacimiento, email }) => {
  const db = await dbPromise;
  const res = await db.query(
    `INSERT INTO usuarios (usuario, contraseña, fecha_nacimiento, email)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [usuario, contraseña, fecha_nacimiento, email]
  );
  console.log("Agregado user:" + "[usuario: " + usuario + ", contraseña: " + contraseña + ", fecha_nacimiento: " + fecha_nacimiento + ", email: " + email);
  return res.rows[0];
};

const updateUser = async (id, { usuario, contraseña, fecha_nacimiento, email }) => {
  const db = await dbPromise;
  const res = await db.query(
    `UPDATE usuarios SET
      usuario = $1,
      contraseña = $2,
      fecha_nacimiento = $3,
      email = $4
     WHERE id = $5
     RETURNING *`,
    [usuario, contraseña, fecha_nacimiento, email, id]
  );
  return res.rows[0];
};

const deleteUser = async (id) => {
  const db = await dbPromise;
  const res = await db.query('DELETE FROM usuarios WHERE id = $1 RETURNING *', [id]);
  return res.rows[0];
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
};