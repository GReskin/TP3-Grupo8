
import 'package:app_gastos_tp3_grupo8/core/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class AnadirGasto extends StatefulWidget {
  const AnadirGasto({super.key});

  @override
  State<AnadirGasto> createState() => _AnadirGastoState();
}

class _AnadirGastoState extends State<AnadirGasto> {

  final List<String> categorias = ['Supermercado', 'Ropa', 'Juegos', 'Transporte', 'Otros'];
String? categoriaSeleccionada;
  @override
  Widget build(BuildContext context) {
    TextEditingController fechaController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Center(
          child: Text(
            "Añadir Gasto",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Monto',
                    labelText: 'Monto',
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Descripción',
                    labelText: 'Descripción',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: fechaController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Seleccionar fecha',
                    labelText: 'Fecha',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      fechaController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),

                const SizedBox(height: 20),

                  // ✅ Campo categoría desplegable
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  value: categoriaSeleccionada,
                  items: categorias.map((String categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
                  onChanged: (String? nuevaCategoria) {
                    setState(() {
                      categoriaSeleccionada = nuevaCategoria;
                    });
                  },
                ),

                const SizedBox(height: 20),
                
                ElevatedButtonTheme(
                  data: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Agregar'),
                  ),
                ),

                
              ],
              
            ),
            
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appRouter.push('/home');
        },
        child: Icon(Icons.arrow_back),
      ),

    );
  }
}
