import 'package:app_gastos_tp3_grupo8/providers/grupoProvider.dart';
import 'package:app_gastos_tp3_grupo8/screens/verGastos.dart';
import 'package:app_gastos_tp3_grupo8/screens/verGastosGrupales.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerGastosGeneral extends StatefulWidget {
  final int usuarioId;
  const VerGastosGeneral({Key? key, required this.usuarioId}) : super(key: key);

  @override
  State<VerGastosGeneral> createState() => _VerGastosGeneralState();
}

class _VerGastosGeneralState extends State<VerGastosGeneral> {
  int? selectedGrupoId;
  bool isLoadingGrupos = false;
  String? errorGrupos;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  Future<void> _cargarGrupos() async {
    setState(() {
      isLoadingGrupos = true;
      errorGrupos = null;
    });
    try {
      final grupoProvider = Provider.of<GrupoProvider>(context, listen: false);
      await grupoProvider.fetchGrupos(widget.usuarioId);
      setState(() {
        isLoadingGrupos = false;
      });
    } catch (e) {
      setState(() {
        errorGrupos = e.toString();
        isLoadingGrupos = false;
      });
    }
  }

  Future<void> _seleccionarGrupo() async {
    final grupoProvider = Provider.of<GrupoProvider>(context, listen: false);

    if (isLoadingGrupos) {
      // Si sigue cargando grupos, espera antes de mostrar diálogo
      await _cargarGrupos();
    }

    if (errorGrupos != null) {
      // Mostrar error en diálogo
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorGrupos!),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
          ],
        ),
      );
      return;
    }

    if (grupoProvider.grupos.isEmpty) {
      // Avisar que no hay grupos para seleccionar
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Atención'),
          content: const Text('No se encontraron grupos para este usuario.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
          ],
        ),
      );
      return;
    }

    final grupoIdSeleccionado = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Selecciona un grupo"),
          children: grupoProvider.grupos.map<Widget>((grupo) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, grupo['id'] as int);
              },
              child: Text(grupo['nombre']),
            );
          }).toList(),
        );
      },
    );

    if (grupoIdSeleccionado != null) {
      setState(() {
        selectedGrupoId = grupoIdSeleccionado;
      });
      // Llamar y esperar que se carguen los gastos de ese grupo
      await grupoProvider.fetchGastosPorGrupo(grupoIdSeleccionado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ver Gastos"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Gasto Personal", icon: Icon(Icons.person)),
              Tab(text: "Gasto Grupal", icon: Icon(Icons.group)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Gastos(), // Pantalla de gastos personales
            selectedGrupoId == null
                ? Center(
                    child: ElevatedButton(
                      onPressed: _seleccionarGrupo,
                      child: const Text("Selecciona un grupo para ver gastos"),
                    ),
                  )
                : VerGastosGrupales(idGrupo: selectedGrupoId!)


          ],
        ),
      ),
    );
  }
}
