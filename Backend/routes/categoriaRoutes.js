const express = require('express');
const router = express.Router();
const categoriaController = require('../controllers/categoriaController');

router.get('/', categoriaController.getAllCategorias);       // GET /api/categorias
router.get('/:id', categoriaController.getCategoriaById);    // GET /api/categorias/:id
router.post('/', categoriaController.createCategoria);       // POST /api/categorias
router.put('/:id', categoriaController.updateCategoria);     // PUT /api/categorias/:id
router.delete('/:id', categoriaController.deleteCategoria);  // DELETE /api/categorias/:id

module.exports = router;
