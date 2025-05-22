const Grupo = require("../models/grupoModel");

const createGroup = async (req, res) => {
  try {
    const { nombre, creador_id } = req.body;
    const group = await Grupo.createGroup({ nombre, creador_id });
    res.status(201).json(group);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const addUser = async (req, res) => {
  try {
    const { grupo_id, usuario_id } = req.body;
    const membership = await Grupo.addUserToGroup({ grupo_id, usuario_id });
    res.status(201).json(membership);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getMyGroups = async (req, res) => {
  try {
    const usuario_id = parseInt(req.params.usuario_id, 10);
    const groups = await Grupo.getGroupsByUser(usuario_id);
    res.json(groups);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getMembers = async (req, res) => {
  try {
    const grupo_id = parseInt(req.params.grupo_id, 10);
    const users = await Grupo.getUsersByGroup(grupo_id);
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const removeUser = async (req, res) => {
  try {
    const { grupo_id, usuario_id } = req.body;
    const removed = await Grupo.removeUserFromGroup({ grupo_id, usuario_id });
    res.json(removed);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteGroup = async (req, res) => {
  try {
    const id = parseInt(req.params.id, 10);
    const deleted = await Grupo.deleteGroup(id);
    res.json(deleted);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
const getAllGroups = async (req, res) => {
  try {
    const grupos = await Grupo.getAllGroups();
    res.json(grupos);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error al obtener los grupos" });
  }
};

module.exports = {
  createGroup,
  addUser,
  getMyGroups,
  getMembers,
  removeUser,
  deleteGroup,
  getAllGroups,
};
