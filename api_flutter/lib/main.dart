import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta de Datos',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.lightBlue[50],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const ConsultarDatos(),
    );
  }
}

class ConsultarDatos extends StatefulWidget {
  const ConsultarDatos({super.key});

  @override
  _ConsultarDatosState createState() => _ConsultarDatosState();
}

class _ConsultarDatosState extends State<ConsultarDatos> {
  final TextEditingController documentoController = TextEditingController();
  String? nombres;
  String? apellidos;
  String? doc;
  String? edad;
  String? FechaN;
  String? imagenUrl;
  bool isLoading = false;

  Future<void> consultarDatos() async {
    final documento = documentoController.text;

    if (documento.isEmpty) return;

    setState(() => isLoading = true);

    final url = 'http://localhost:8067/operaciongetusuariodocumento?doc=$documento';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          nombres = data['nombres'];
          apellidos = data['apellidos'];
          doc = data['documento'];
          edad = data['edad'];
          FechaN = data['fechaN'];
          imagenUrl = data['imagen'];
        });
      } else {
        throw Exception('Error en la consulta');
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al consultar los datos')),
      );
      setState(() {
        nombres = null;
        apellidos = null;
        doc = null;
        edad = null;
        FechaN = null;
        imagenUrl = null;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Datos'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Text(
                'Ingrese la cédula',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: documentoController,
                decoration: const InputDecoration(labelText: 'Cédula'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : consultarDatos,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Consultar'),
              ),
              const SizedBox(height: 20),
              if (nombres != null && apellidos != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Nombres: $nombres'),
                    Text('Apellidos: $apellidos'),
                    Text('Documento: $doc'),
                    Text('Edad: $edad'),
                    Text('Fecha de nacimiento: $FechaN'),
                    const SizedBox(height: 10),
                    if (imagenUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(imagenUrl!),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
