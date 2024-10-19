import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'macros_result_view.dart';

class MacrosFormView extends StatefulWidget {
  @override
  _MacrosFormViewState createState() => _MacrosFormViewState();
}

class _MacrosFormViewState extends State<MacrosFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Masculino';
  String _selectedActivityLevel = 'Baixo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir Dados'),
        backgroundColor: Colors.green.shade700, // Cor verde
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
                  color: Colors.green.shade800, // Título verde
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Campo Peso
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
                    return 'Insira seu peso';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Campo Altura
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
                    return 'Insira sua altura';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Campo Idade
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
                    return 'Insira sua idade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Campo Gênero
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Masculino', 'Feminino'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Sexo',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  filled: true,
                  fillColor: Colors.green.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Campo Nível de Atividade
              DropdownButtonFormField<String>(
                value: _selectedActivityLevel,
                items: ['Baixo', 'Médio', 'Alto'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
              // Botão para enviar dados e calcular
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Navegar para a tela de resultado com os dados inseridos
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MacrosResultView(
                          weight: double.parse(_weightController.text),
                          height: double.parse(_heightController.text),
                          age: int.parse(_ageController.text),
                          gender: _selectedGender,
                          activityLevel: _selectedActivityLevel,
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
