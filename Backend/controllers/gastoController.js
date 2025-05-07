const Gasto = require('../models/gastoModel');

const getAllGastos = async (req, res) => {
  try {
    const gastos = await Gasto.getAllGastos();
    res.json(gastos);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener los gastos' });
  }
};

const getGastoById = async (req, res) => {
  try {
    const gasto = await Gasto.getGastoById(req.params.id);
    if (!gasto) return res.status(404).json({ error: 'Gasto no encontrado' });
    res.json(gasto);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener el gasto' });
  }
};

const createGasto = async (req, res) => {
  try {
    const nuevoGasto = await Gasto.createGasto(req.body);
    res.status(201).json(nuevoGasto);
  } catch (err) {
    res.status(500).json({ error: 'Error al crear el gasto' });
  }
};

const updateGasto = async (req, res) => {
  try {
    const gastoActualizado = await Gasto.updateGasto(req.params.id, req.body);
    if (!gastoActualizado) return res.status(404).json({ error: 'Gasto no encontrado' });
    res.json(gastoActualizado);
  } catch (err) {
    res.status(500).json({ error: 'Error al actualizar el gasto' });
  }
};

const deleteGasto = async (req, res) => {
  try {
    const gastoEliminado = await Gasto.deleteGasto(req.params.id);
    if (!gastoEliminado) return res.status(404).json({ error: 'Gasto no encontrado' });
    res.json({ mensaje: 'Gasto eliminado', gasto: gastoEliminado });
  } catch (err) {
    res.status(500).json({ error: 'Error al eliminar el gasto' });
  }
};

module.exports = {
  getAllGastos,
  getGastoById,
  createGasto,
  updateGasto,
  deleteGasto,
};
