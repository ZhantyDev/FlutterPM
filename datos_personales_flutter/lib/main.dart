import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Datos Personales',
      home: FormularioPage(),
    );
  }
}

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  String _resultado = "";

  late Database db;

  @override
  void initState() {
    super.initState();
    inicializarDB();
  }

  Future<void> inicializarDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'datos_personales_71764044.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            documento TEXT,
            nombres TEXT,
            apellidos TEXT
          )
        ''');
      },
    );
  }

  Future<void> guardarDatos() async {
    await db.insert('usuarios', {
      'documento': _documentoController.text,
      'nombres': _nombresController.text,
      'apellidos': _apellidosController.text,
    });

    _documentoController.clear();
    _nombresController.clear();
    _apellidosController.clear();
  }

  Future<void> mostrarDatos() async {
    final List<Map<String, dynamic>> datos = await db.query('usuarios');
    setState(() {
      _resultado = datos.map((e) => '${e['documento']} - ${e['nombres']} ${e['apellidos']}').join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario Datos Personales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Formulario Datos Personales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _documentoController,
              decoration: InputDecoration(labelText: 'Documento'),
            ),
            TextField(
              controller: _nombresController,
              decoration: InputDecoration(labelText: 'Nombres'),
            ),
            TextField(
              controller: _apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: guardarDatos, child: Text('Guardar')),
                ElevatedButton(onPressed: mostrarDatos, child: Text('Mostrar')),
              ],
            ),
            SizedBox(height: 20),
            Text('Resultados:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: SingleChildScrollView(child: Text(_resultado))),
          ],
        ),
      ),
    );
  }
}