import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/user_controller.dart';
import 'home_page.dart'; // Importe a tela inicial

class MacrosFormView extends StatefulWidget {
  const MacrosFormView({super.key});

  @override
  _MacrosFormViewState createState() => _MacrosFormViewState();
}

class _MacrosFormViewState extends State<MacrosFormView> {
  final _formKey = GlobalKey<FormState>();
  final UserController _controller = UserController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Masculino';
  String _selectedActivityLevel = 'Baixo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Dados'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Calcule seus Macros',
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu peso';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura (cm)',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua altura';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Idade',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua idade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(
                      value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Gênero',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedActivityLevel,
                items: const [
                  DropdownMenuItem(value: 'Baixo', child: Text('Baixo')),
                  DropdownMenuItem(value: 'Médio', child: Text('Médio')),
                  DropdownMenuItem(value: 'Alto', child: Text('Alto')),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedActivityLevel = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nível de Atividade',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Quando o botão 'Calcular Macros' é pressionado
                  if (_formKey.currentState!.validate()) {
                    double weight = double.parse(_weightController.text);
                    double height = double.parse(_heightController.text);
                    int age = int.parse(_ageController.text);
                    String gender = _selectedGender;
                    String activityLevel = _selectedActivityLevel;

                    // Armazena os dados
                    _controller.setPhysicalData(
                      weight: weight,
                      height: height,
                      age: age,
                      gender: gender,
                      activityLevel: activityLevel,
                    );

                    // Navega para a tela inicial
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(), // Substitua por sua tela inicial
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Calcular Macros',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
