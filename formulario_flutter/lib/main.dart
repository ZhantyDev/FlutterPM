import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PersonalDataForm(),
    );
  }
}

class PersonalDataForm extends StatefulWidget {
  const PersonalDataForm({super.key});

  @override
  _PersonalDataFormState createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  // Controladores de texto para los campos de entrada
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();

  void _showData() {
    final name = _nameController.text;
    final lastName = _lastNameController.text;
    final document = _documentController.text;

    if (name.isNotEmpty && lastName.isNotEmpty && document.isNotEmpty) {
      final data = 'Nombres: $name\nApellidos: $lastName\nDocumento: $document';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor complete todos los campos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Datos Personales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Datos Personales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Campo de texto para el nombre
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombres',
              ),
            ),
            SizedBox(height: 10),
            // Campo de texto para el apellido
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Apellidos',
              ),
            ),
            SizedBox(height: 10),
            // Campo de texto para el documento
            TextField(
              controller: _documentController,
              decoration: InputDecoration(
                labelText: 'Documento',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showData,
              child: Text('Mostrar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}
