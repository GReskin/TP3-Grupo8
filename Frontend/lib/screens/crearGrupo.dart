import 'package:flutter/material.dart';

class CrearGrupo extends StatefulWidget {
  @override
  _CrearGrupoState createState() => _CrearGrupoState();
}

class _CrearGrupoState extends State<CrearGrupo> {
  final TextEditingController _nombreGrupoController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();

  final List<String> usuariosDisponibles = [
    'juan123',
    'maria456',
    'luis789',
    'ana321',
    'carlos987',
  ];

  List<String> usuariosGrupo = [];

  Future<void> _confirmarAgregarUsuario(String usuario) async {
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar usuario'),
        content: Text('¿Agregar "$usuario" al grupo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Agregar')),
        ],
      ),
    );

    if (shouldAdd == true) {
      _agregarUsuario(usuario);
    }
  }

  void _agregarUsuario(String usuario) {
    if (!usuariosDisponibles.contains(usuario)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario "$usuario" no existe')),
      );
      return;
    }

    if (usuariosGrupo.contains(usuario)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario "$usuario" ya está en el grupo')),
      );
      return;
    }

    setState(() {
      usuariosGrupo.add(usuario);
      _usuarioController.clear();
    });
  }

  Future<void> _confirmarEliminarUsuario(String usuario) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar integrante'),
        content: Text('¿Eliminar a "$usuario" del grupo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar')),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        usuariosGrupo.remove(usuario);
      });
    }
  }

  void _crearGrupo() {
    final nombreGrupo = _nombreGrupoController.text.trim();

    if (nombreGrupo.isEmpty || usuariosGrupo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completa el nombre del grupo y agrega al menos un usuario')),
      );
      return;
    }

    print('Grupo creado: $nombreGrupo');
    print('Usuarios: $usuariosGrupo');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Grupo "$nombreGrupo" creado con éxito')),
    );

    setState(() {
      _nombreGrupoController.clear();
      _usuarioController.clear();
      usuariosGrupo.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _nombreGrupoController,
              label: 'Nombre del Grupo',
              icon: Icons.group,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _usuarioController,
                    label: 'Nombre de Usuario',
                    icon: Icons.person_add_alt_1,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    final usuario = _usuarioController.text.trim();
                    if (usuario.isNotEmpty) {
                      _confirmarAgregarUsuario(usuario);
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
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: usuariosGrupo.isEmpty
                  ? Center(child: Text('No hay usuarios añadidos.'))
                  : ListView.builder(
                      itemCount: usuariosGrupo.length,
                      itemBuilder: (context, index) {
                        final usuario = usuariosGrupo[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                usuario[0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(usuario),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarEliminarUsuario(usuario),
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
                onPressed: _crearGrupo,
                icon: Icon(Icons.check),
                label: Text('Crear Grupo'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          borderSide: BorderSide(color: const Color.fromARGB(255, 58, 137, 183)),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
