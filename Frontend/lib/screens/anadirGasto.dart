// añadirGasto.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_gastos_tp3_grupo8/providers/gastoProvider.dart';
import 'package:go_router/go_router.dart';

class AnadirGasto extends StatefulWidget {
  @override
  _AnadirGastoState createState() => _AnadirGastoState();
}

class _AnadirGastoState extends State<AnadirGasto> {
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  DateTime _fecha = DateTime.now();
  int _idcategoria = 1; // Valor predeterminado

  List<dynamic> _categorias = []; // Lista de categorías

  @override
  void initState() {
    super.initState();
    Provider.of<GastoProvider>(context, listen: false).cargarCategorias().then((
      _,
    ) {
      setState(() {
        _categorias =
            Provider.of<GastoProvider>(context, listen: false).categorias;
      });
    });
  }

  void _selectFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fecha) {
      Provider.of<GastoProvider>(
        context,
        listen: false,
      ).actualizarFecha(picked);
      setState(() {
        _fecha = picked;
      });
    }
  }

  void _crearGasto() async {
    final descripcion = _descripcionController.text;
    final montoTexto = _montoController.text;

    if (descripcion.isEmpty || montoTexto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    final gastoProvider = Provider.of<GastoProvider>(context, listen: false);
    await gastoProvider.crearGasto(descripcion, montoTexto);

    // No need for try-catch here, the provider handles errors
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Gasto'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<GastoProvider>(
          builder: (context, gastoProvider, _) {
            // Listen for errors and success from the provider
            if (gastoProvider.gastoError != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(gastoProvider.gastoError!)),
                );
                gastoProvider.resetGastoState(); // Clear the error
              });
            }

            if (gastoProvider.gastoCreado) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/home');
                gastoProvider.resetGastoState(); // Clear the success flag
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
                DropdownButtonFormField<int>(
                  value: gastoProvider.idCategoria,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      Provider.of<GastoProvider>(
                        context,
                        listen: false,
                      ).seleccionarCategoria(newValue);
                      setState(() {
                        _idcategoria = newValue;
                      });
                    }
                  },
                  items:
                      _categorias.map<DropdownMenuItem<int>>((categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria['id'],
                          child: Text(categoria['nombre']),
                        );
                      }).toList(),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => _selectFecha(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      "${Provider.of<GastoProvider>(context).fecha.toLocal()}"
                          .split(' ')[0],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _crearGasto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text('Crear Gasto', style: TextStyle(fontSize: 18)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
