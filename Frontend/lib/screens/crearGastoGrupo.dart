import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_gastos_tp3_grupo8/providers/grupoProvider.dart';

class CrearGastoGrupo extends StatefulWidget {
  @override
  _CrearGastoGrupoState createState() => _CrearGastoGrupoState();
}

class _CrearGastoGrupoState extends State<CrearGastoGrupo> {
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  DateTime _fecha = DateTime.now();

  int? _idcategoria;
  int? _idgrupo;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<GrupoProvider>(context, listen: false);
      provider.fetchCategorias();
      provider.fetchGrupos().then((_) {
        // Inicializamos el grupo y categoría si están vacíos
        if (provider.grupos.isNotEmpty && _idgrupo == null) {
          setState(() {
            _idgrupo = provider.grupos[0]['id'];
          });
        }
        if (provider.categorias.isNotEmpty && _idcategoria == null) {
          setState(() {
            _idcategoria = provider.categorias[0]['id'];
          });
        }
      });
    });
  }

  Future<void> _crearGastoGrupo() async {
    final provider = Provider.of<GrupoProvider>(context, listen: false);

    if (_idgrupo == null || _idcategoria == null) {
      // No hay grupo o categoría seleccionada
      print("Debe seleccionar grupo y categoría");
      return;
    }

    final success = await provider.crearGastoGrupo(
      descripcion: _descripcionController.text,
      monto: double.tryParse(_montoController.text) ?? 0.0,
      fecha: _fecha,
      idcategoria: _idcategoria!,
      idgrupo: _idgrupo!,
    );

    if (success) {
      print("Gasto de grupo creado exitosamente");
      Navigator.pop(context);
    } else {
      print("Error al crear el gasto");
    }
  }

  Future<void> _selectFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Gasto al Grupo'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<GrupoProvider>(
          builder: (context, provider, child) {
            final grupos = provider.grupos;
            final categorias = provider.categorias;

            // Validar que el _idgrupo esté en la lista de grupos
            if (_idgrupo != null && !grupos.any((g) => g['id'] == _idgrupo)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _idgrupo = null;
                });
              });
            }

            // Validar que el _idcategoria esté en la lista de categorias
            if (_idcategoria != null &&
                !categorias.any((c) => c['id'] == _idcategoria)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _idcategoria = null;
                });
              });
            }

            return ListView(
              children: [
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _montoController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Monto',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                ),
                SizedBox(height: 16.0),

                // Selector de grupo (usando provider.grupos)
                DropdownButtonFormField<int>(
                  value: _idgrupo,
                  decoration: InputDecoration(
                    labelText: 'Grupo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group),
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      _idgrupo = newValue;
                    });
                  },
                  hint: Text(
                    grupos.isEmpty
                        ? 'No hay grupos disponibles'
                        : 'Seleccione un grupo',
                  ),

                  items:
                      grupos.isNotEmpty
                          ? grupos.map<DropdownMenuItem<int>>((grupo) {
                            return DropdownMenuItem<int>(
                              value: grupo['id'],
                              child: Text(grupo['nombre']),
                            );
                          }).toList()
                          : [
                            DropdownMenuItem(
                              value: null,
                              child: Text('No hay grupos disponibles'),
                            ),
                          ],
                ),
                SizedBox(height: 16.0),

                // Selector de categoría desde el provider
                DropdownButtonFormField<int>(
                  value: _idcategoria,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      _idcategoria = newValue;
                    });
                  },
                  items:
                      categorias.isNotEmpty
                          ? categorias.map<DropdownMenuItem<int>>((categoria) {
                            return DropdownMenuItem<int>(
                              value: categoria['id'],
                              child: Text(categoria['nombre']),
                            );
                          }).toList()
                          : [
                            DropdownMenuItem(
                              value: null,
                              child: Text('No hay categorías disponibles'),
                            ),
                          ],
                ),
                SizedBox(height: 16.0),

                // Selector de fecha
                GestureDetector(
                  onTap: () => _selectFecha(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      "${_fecha.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                ElevatedButton.icon(
                  onPressed: _crearGastoGrupo,
                  icon: Icon(Icons.add),
                  label: Text('Crear Gasto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
