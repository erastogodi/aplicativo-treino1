import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/treino.dart';

class CreateWorkoutPage extends StatefulWidget {
  final HomeController controller;

  CreateWorkoutPage({required this.controller});

  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();
  final List<TextEditingController> _exercicioControllers = [];

  void _adicionarExercicio() {
    setState(() {
      _exercicioControllers.add(TextEditingController());
    });
  }

  void _salvarTreino() {
    String nome = _nomeController.text;
    String data = _dataController.text;
    String duracao = _duracaoController.text;

    if (nome.isNotEmpty &&
        data.isNotEmpty &&
        duracao.isNotEmpty &&
        _exercicioControllers.isNotEmpty) {
      List<String> exercicios =
          _exercicioControllers.map((controller) => controller.text).toList();
      Treino novoTreino = Treino(
        nome: nome,
        data: data,
        duracao: duracao,
        intensidade: 'Alta', // Ou pegue de outro lugar caso necessário
      );
      widget.controller.adicionarTreino(novoTreino);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Treino'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  'Nome do Treino', Icons.fitness_center, _nomeController),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        'Data', Icons.calendar_today, _dataController),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                        'Duração', Icons.timer, _duracaoController),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Exercícios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildExerciseList(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _adicionarExercicio,
                child: Text('Adicionar Exercício'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarTreino,
                child: Text('Salvar Treino'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _exercicioControllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: TextField(
            controller: _exercicioControllers[index],
            decoration: InputDecoration(
              labelText: 'Exercício ${index + 1}',
              prefixIcon: Icon(Icons.fitness_center),
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }
}
