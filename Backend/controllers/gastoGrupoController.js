const GastoGrupo = require('../models/gastoGrupoModel');

const getAllGastosGrupo = async (req, res) => {
  try {
    const gastos = await GastoGrupo.getAllGastosGrupo();
    res.json(gastos);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener los gastos de grupo' });
  }
};

const getGastosByGrupo = async (req, res) => {
  try {
    const gastos = await GastoGrupo.getGastosByGrupo(req.params.idgrupo);
    res.json(gastos);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener los gastos del grupo' });
  }
};





const createGastoGrupo = async (req, res) => {
  try {
    console.log('Datos recibidos para gasto grupo:', req.body);
    const nuevoGasto = await GastoGrupo.createGastoGrupo(req.body);

    res.status(201).json(nuevoGasto);
  } catch (error) {
    console.error('Error al crear gasto de grupo:', error.message);
    res.status(500).json({ error: 'Error al crear gasto de grupo' });
  }
};


const deleteGastoGrupo = async (req, res) => {
  try {
    const gastoEliminado = await GastoGrupo.deleteGastoGrupo(req.params.id);
    res.json({ mensaje: 'Gasto eliminado', gasto: gastoEliminado });
  } catch (err) {
    res.status(500).json({ error: 'Error al eliminar el gasto de grupo' });
  }
};

module.exports = {
  getAllGastosGrupo,
  getGastosByGrupo,
  createGastoGrupo,
  deleteGastoGrupo
};
