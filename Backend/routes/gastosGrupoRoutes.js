const express = require('express');
const router = express.Router();
const gastoGrupoController = require('../controllers/gastoGrupoController');

router.get('/', gastoGrupoController.getAllGastosGrupo);
router.get('/:idgrupo', gastoGrupoController.getGastosByGrupo);
router.post('/', gastoGrupoController.createGastoGrupo); 
router.delete('/:id', gastoGrupoController.deleteGastoGrupo);

module.exports = router;
