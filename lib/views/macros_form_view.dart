import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/user_controller.dart';
import 'new_macros_result_view.dart'; // Use a nova view

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
                  if (_formKey.currentState!.validate()) {
                    // Usa Future para evitar travar a interface
                    await Future.delayed(Duration(milliseconds: 100), () {
                      _controller.setPhysicalData(
                        weight: double.parse(_weightController.text),
                        height: double.parse(_heightController.text),
                        age: int.parse(_ageController.text),
                        gender: _selectedGender,
                        activityLevel: _selectedActivityLevel,
                      );
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewMacrosResultView(
                          weight: double.parse(_weightController.text),
                          height: double.parse(_heightController.text),
                          age: int.parse(_ageController.text),
                          gender: _selectedGender,
                          activityLevel: _selectedActivityLevel,
                          controller: _controller,
                        ),
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
