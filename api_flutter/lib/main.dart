import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de Datos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConsultarDatos(),
    );
  }
}

class ConsultarDatos extends StatefulWidget {
  const ConsultarDatos({super.key});

  @override
  _ConsultarDatosState createState() => _ConsultarDatosState();
}

class _ConsultarDatosState extends State<ConsultarDatos> {
  TextEditingController documentoController = TextEditingController();
  String? nombres;
  String? apellidos;
  String? imagenUrl;
  bool isLoading = false;

  Future<void> consultarDatos() async {
    final documento = documentoController.text;

    if (documento.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = 'http://localhost:8067/operaciongetusuariodocumento?documento=$documento'; // URL de la API remota
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nombres = data['nombres'];
          apellidos = data['apellidos'];
          imagenUrl = data['imagen']; // URL de la imagen
        });
      } else {
        throw Exception('Error en la consulta');
      }
    } catch (e) {
      setState(() {
        nombres = null;
        apellidos = null;
        imagenUrl = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al consultar los datos')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: documentoController,
              decoration: InputDecoration(labelText: 'Ingrese la cédula'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : consultarDatos,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Consultar'),
            ),
            SizedBox(height: 16),
            if (nombres != null && apellidos != null) ...[
              Text('Nombres: $nombres'),
              Text('Apellidos: $apellidos'),
              if (imagenUrl != null)
                Image.network(imagenUrl!),
            ],
          ],
        ),
      ),
    );
  }
}