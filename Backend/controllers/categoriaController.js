const Categoria = require('../models/categoriaModel');

const getAllCategorias = async (req, res) => {
  try {
    const categorias = await Categoria.getAllCategorias();
    res.json(categorias);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener las categorías' });
  }
};

const getCategoriaById = async (req, res) => {
  try {
    const categoria = await Categoria.getCategoriaById(req.params.id);
    if (!categoria) return res.status(404).json({ error: 'Categoría no encontrada' });
    res.json(categoria);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener la categoría' });
  }
};

const createCategoria = async (req, res) => {
  try {
    const nuevaCategoria = await Categoria.createCategoria(req.body);
    res.status(201).json(nuevaCategoria);
  } catch (err) {
    res.status(500).json({ error: 'Error al crear la categoría' });
  }
};

const updateCategoria = async (req, res) => {
  try {
    const categoriaActualizada = await Categoria.updateCategoria(req.params.id, req.body);
    if (!categoriaActualizada) return res.status(404).json({ error: 'Categoría no encontrada' });
    res.json(categoriaActualizada);
  } catch (err) {
    res.status(500).json({ error: 'Error al actualizar la categoría' });
  }
};

const deleteCategoria = async (req, res) => {
  try {
    const categoriaEliminada = await Categoria.deleteCategoria(req.params.id);
    if (!categoriaEliminada) return res.status(404).json({ error: 'Categoría no encontrada' });
    res.json({ mensaje: 'Categoría eliminada', categoria: categoriaEliminada });
  } catch (err) {
    res.status(500).json({ error: 'Error al eliminar la categoría' });
  }
};

module.exports = {
  getAllCategorias,
  getCategoriaById,
  createCategoria,
  updateCategoria,
  deleteCategoria,
};
