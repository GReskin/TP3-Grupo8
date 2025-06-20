import 'package:app_gastos_tp3_grupo8/providers/gastoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_gastos_tp3_grupo8/providers/grupoProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearGrupo extends StatefulWidget {
  @override
  _CrearGrupoState createState() => _CrearGrupoState();
}

class _CrearGrupoState extends State<CrearGrupo> {
  late GrupoProvider grupoProvider;
  Map<String, dynamic>?
  usuarioSeleccionado; // Variable para el usuario seleccionado

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      grupoProvider = Provider.of<GrupoProvider>(context, listen: false);
      grupoProvider.fetchCategorias();
      grupoProvider.fetchUsuarios(); // Carga usuarios de la DB
    });
  }

void _validarYCrearGrupo() {
  final gastoProvider = Provider.of<GastoProvider>(context, listen: false);
  if (grupoProvider.nombreGrupoController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('El nombre del grupo no puede estar vacío')),
    );
    return;
  }
  else if (grupoProvider.usuariosGrupo.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Debe agregar al menos un usuario al grupo')),
    );
    return;
  }
  
  else if (gastoProvider.getIdUsuario() == usuarioSeleccionado) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No te podes agregar a vos mismo')),
    );
    return;
  }else{
    grupoProvider.crearGrupo(context);
  }

  
}

  Future<void> _confirmarAgregarUsuario(
    BuildContext context,
    GrupoProvider grupoProvider,
    Map<String, dynamic> usuario,
  ) async {
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Agregar usuario'),
            content: Text('¿Agregar "${usuario['usuario']}" al grupo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Agregar'),
              ),
            ],
          ),
    );

    if (shouldAdd == true) {
      grupoProvider.agregarUsuario(context, usuario);
    }
  }

 Future<void> _confirmarEliminarUsuario(
  BuildContext context,
  GrupoProvider grupoProvider,
  Map<String, dynamic> usuario,
) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Eliminar integrante'),
      content: Text('¿Eliminar a "${usuario['usuario']}" del grupo?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Eliminar'),
        ),
      ],
    ),
  );

  if (shouldDelete == true) {
    grupoProvider.eliminarUsuarioPorId(usuario['id']);
  }
}


  @override
  Widget build(BuildContext context) {
    // Usamos listen: true para que se actualice UI con cambios en provider
    grupoProvider = Provider.of<GrupoProvider>(context);



    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Crear Grupo'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInputField(
              controller: grupoProvider.nombreGrupoController,
              label: 'Nombre del Grupo',
              icon: Icons.group,
            ),
            const SizedBox(height: 16),
            Row(
  children: [
    Expanded(
      child: TextFormField(
        controller: grupoProvider.usuarioController,
        decoration: InputDecoration(
          labelText: 'Nombre del usuario',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Icon(Icons.person),
        ),
      ),
    ),
    const SizedBox(width: 8),
    FloatingActionButton(
      onPressed: () {
        final inputNombre = grupoProvider.usuarioController.text.trim();

if (inputNombre.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Escribe un nombre de usuario')),
  );
  return;
}

final usuarioEncontrado = grupoProvider.usuariosDisponibles.firstWhere(
  (u) =>
      u['usuario'] != null &&
      u['usuario'].toString().toLowerCase() == inputNombre.toLowerCase(),
  orElse: () => <String, dynamic>{},
);

if (usuarioEncontrado.isNotEmpty) {
  _confirmarAgregarUsuario(
    context,
    grupoProvider,
    usuarioEncontrado,
  );
  grupoProvider.usuarioController.clear();
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Usuario no encontrado')),
  );
}

      },
      backgroundColor: Colors.blueAccent,
      mini: true,
      child: Icon(Icons.add),
    ),
  ],
),


            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Integrantes añadidos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  grupoProvider.usuariosGrupo.isEmpty
                      ? Center(child: Text('No hay usuarios añadidos.'))
                      : ListView.builder(
                        itemCount: grupoProvider.usuariosGrupo.length,
                        itemBuilder: (context, index) {
                          final usuario = grupoProvider.usuariosGrupo[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  (usuario['usuario']?.toString() ?? '?')[0]
                                      .toUpperCase(),

                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(usuario['usuario']),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmarEliminarUsuario(
                                context,
                                grupoProvider,
                                usuario,
                              ),

                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _validarYCrearGrupo(),
                icon: Icon(Icons.check),
                label: Text('Crear Grupo'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 35, 166, 218)),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 58, 137, 183),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
