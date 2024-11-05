import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import '../models/treino.dart';

class CreateWorkoutPage extends StatefulWidget {
  final HomeController? controller;

  const CreateWorkoutPage({super.key, this.controller});

  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final List<TextEditingController> _exercicioControllers = [];
  int _duracaoSelecionada = 30; // Valor inicial padrão para evitar o erro

  void _adicionarExercicio() {
    setState(() {
      _exercicioControllers.add(TextEditingController());
    });
  }

  void _salvarTreino() {
    String nome = _nomeController.text;
    String data = _dataController.text;
    int duracao = _duracaoSelecionada;

    if (nome.isNotEmpty &&
        data.isNotEmpty &&
        _exercicioControllers.isNotEmpty) {
      List<String> exercicios =
          _exercicioControllers.map((controller) => controller.text).toList();
      Treino novoTreino = Treino(
        nome: nome,
        data: data,
        duracao: '$duracao minutos',
        intensidade: 'Alta',
      );
      widget.controller?.adicionarTreino(novoTreino);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  Future<void> _selecionarData() async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (dataSelecionada != null) {
      setState(() {
        _dataController.text = DateFormat('yyyy-MM-dd').format(dataSelecionada);
      });
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
                    child: GestureDetector(
                      onTap: _selecionarData,
                      child: AbsorbPointer(
                        child: _buildTextField(
                            'Data', Icons.calendar_today, _dataController),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDurationSelector(),
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

  Widget _buildDurationSelector() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Duração (minutos)',
        prefixIcon: Icon(Icons.timer),
        border: OutlineInputBorder(),
      ),
      value: _duracaoSelecionada,
      onChanged: (int? newValue) {
        setState(() {
          _duracaoSelecionada = newValue!;
        });
      },
      items: List.generate(
        120,
        (index) => DropdownMenuItem(
          value: index + 1,
          child: Text('${index + 1} min'),
        ),
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
