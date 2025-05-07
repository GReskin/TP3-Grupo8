const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.get('/', userController.getAllUsers);        // GET /api/usuarios
router.get('/:id', userController.getUserById);     // GET /api/usuarios/:id
router.post('/', userController.createUser);        // POST /api/usuarios
router.put('/:id', userController.updateUser);      // PUT /api/usuarios/:id
router.delete('/:id', userController.deleteUser);   // DELETE /api/usuarios/:id
router.post('/login', userController.login);        // POST /api/usuarios/login

module.exports = router;