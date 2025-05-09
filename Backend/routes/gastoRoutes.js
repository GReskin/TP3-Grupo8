const express = require('express');
const router = express.Router();
const gastoController = require('../controllers/gastoController');

router.get('/', gastoController.getAllGastos);        // GET /api/gastos
router.get('/usuarios/:id', gastoController.getAllGastosByUser);        // GET /api/gastos
router.get('/:id', gastoController.getGastoById);     // GET /api/gastos/:id
router.post('/', gastoController.createGasto);        // POST /api/gastos
router.put('/:id', gastoController.updateGasto);      // PUT /api/gastos/:id
router.delete('/:id', gastoController.deleteGasto);   // DELETE /api/gastos/:id

module.exports = router;
