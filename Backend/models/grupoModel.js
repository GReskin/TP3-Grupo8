const dbPromise = require("./db");

const Grupo = {
  createGroup: async ({ nombre, creador_id }) => {
    const db = await dbPromise;
    const { rows } = await db.query(
      `INSERT INTO grupos (nombre, creador_id) VALUES ($1, $2) RETURNING *`,
      [nombre, creador_id]
    );
    return rows[0];
  },

  addUserToGroup: async ({ grupo_id, usuario_id }) => {
    const db = await dbPromise;
    const { rows } = await db.query(
      `INSERT INTO usuario_grupos (grupo_id, usuario_id)
       VALUES ($1, $2)
       ON CONFLICT DO NOTHING
       RETURNING *`,
      [grupo_id, usuario_id]
    );
    return rows[0];
  },

  getGroupsByUser: async (usuario_id) => {
    const db = await dbPromise;
    const { rows } = await db.query(
      `SELECT g.* FROM grupos g
       JOIN usuario_grupos ug ON g.id = ug.grupo_id
       WHERE ug.usuario_id = $1`,
      [usuario_id]
    );
    return rows;
  },

  getUsersByGroup: async (grupo_id) => {
    const db = await dbPromise;
    const { rows } = await db.query(
      `SELECT u.* FROM usuarios u
       JOIN usuario_grupos ug ON u.id = ug.usuario_id
       WHERE ug.grupo_id = $1`,
      [grupo_id]
    );
    return rows;
  },

  removeUserFromGroup: async ({ grupo_id, usuario_id }) => {
    const db = await dbPromise;
    const { rows } = await db.query(
      `DELETE FROM usuario_grupos
       WHERE grupo_id = $1 AND usuario_id = $2
       RETURNING *`,
      [grupo_id, usuario_id]
    );
    return rows[0];
  },
  getAllGroups: async () => {
    const db = await dbPromise;
    const { rows } = await db.query(`SELECT * FROM grupos`);
    return rows;
  },

  deleteGroup: async (id) => {
    const db = await dbPromise;
    const { rows } = await db.query(
      `DELETE FROM grupos WHERE id = $1 RETURNING *`,
      [id]
    );
    return rows[0];
  },
};

module.exports = Grupo;
