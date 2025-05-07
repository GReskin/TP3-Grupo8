const User = require('../models/userModel');

const getAllUsers = async (req, res) => {
  try {
    const users = await User.getAllUsers();
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener los usuarios' });
  }
};

const getUserById = async (req, res) => {
  try {
    const user = await User.getUserById(req.params.id);
    if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener el usuario' });
  }
};

  const getUserByEmail = async(req, res) => {
    try {
      const user = await User.getUserByEmail(req.params.email);
      if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
      res.json(user);
    } catch (err) {
      res.status(500).json({ error: 'Error al obtener el usuario' });
    }
  };

const createUser = async (req, res) => {
  try {
    console.log('Datos recibidos en el backend:', req.body);
    const newUser = await User.createUser(req.body);
    res.status(201).json(newUser);
  } catch (err) {
    res.status(500).json({ error: 'Error al crear el usuario' });
  }
};

const updateUser = async (req, res) => {
  try {
    const updatedUser = await User.updateUser(req.params.id, req.body);
    if (!updatedUser) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: 'Error al actualizar el usuario' });
  }
};

const deleteUser = async (req, res) => {
  try {
    const deletedUser = await User.deleteUser(req.params.id);
    if (!deletedUser) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json({ mensaje: 'Usuario eliminado', usuario: deletedUser });
  } catch (err) {
    res.status(500).json({ error: 'Error al eliminar el usuario' });
  }
};

const login = async (req, res) => {
  const { email, contraseña } = req.body;

  if (!email || !contraseña) {
    return res.status(400).json({ error: 'Correo y contraseña son requeridos' });
  }

  try {
    const user = await User.getUserByEmail(email);

    if (!user) {
      return res.status(400).json({ error: 'Usuario no encontrado' });
    }

    if (user.contraseña !== contraseña) {
      return res.status(400).json({ error: 'Contraseña incorrecta' });
    }
    
    console.log("Login exitoso de user:" + "[email: " + email + ", contraseña: " + contraseña + "]");
    return res.status(200).json({
      message: 'Login exitoso',
      id: user.id,   
      usuario: user.usuario
    });

  } catch (err) {
    console.error('Error al procesar login:', err);
    return res.status(500).json({ error: 'Error en el servidor' });
  }
};

module.exports = {
  getAllUsers,
  getUserById,
  getUserByEmail,
  createUser,
  updateUser,
  deleteUser,
  login,
};
