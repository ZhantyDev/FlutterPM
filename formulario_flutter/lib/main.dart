import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PersonalDataForm(),
    );
  }
}

class PersonalDataForm extends StatefulWidget {
  const PersonalDataForm({super.key});

  @override
  State<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();

  void _showData() {
    final name = _nameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final document = _documentController.text.trim();

    final snackBar = (name.isNotEmpty && lastName.isNotEmpty && document.isNotEmpty)
        ? SnackBar(
            content: Text('Nombres: $name\nApellidos: $lastName\nDocumento: $document'),
            backgroundColor: Colors.green,
          )
        : const SnackBar(
            content: Text('Por favor complete todos los campos'),
            backgroundColor: Colors.red,
          );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Datos Personales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Datos Personales',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(_nameController, 'Nombres'),
                const SizedBox(height: 12),
                _buildTextField(_lastNameController, 'Apellidos'),
                const SizedBox(height: 12),
                _buildTextField(_documentController, 'Documento', keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _showData,
                  icon: const Icon(Icons.send),
                  label: const Text('Mostrar Datos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
