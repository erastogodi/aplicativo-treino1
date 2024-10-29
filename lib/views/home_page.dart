import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/treino.dart';
import 'workout_history_page.dart';
import 'create_workout_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  bool treinoCheckInFeito = false;
  int totalCheckIns = 0;

  @override
  void initState() {
    super.initState();
    _controller.carregarTreinoDoDia();
  }

  void _fazerCheckIn() {
    if (!treinoCheckInFeito && _controller.treinoDoDia != null) {
      setState(() {
        treinoCheckInFeito = true;
        totalCheckIns++;
        _controller.fazerCheckIn(
          _controller.treinoDoDia!,
          () {
            setState(() {});
          },
        );
      });
    }
  }

  void _editarTreinoDoDia() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> nomesTreinos = _controller.getNomesDeTreinos();
        String? treinoSelecionado =
            nomesTreinos.isNotEmpty ? nomesTreinos.first : null;

        return AlertDialog(
          title: Text('Editar Treino do Dia'),
          content: treinoSelecionado != null
              ? DropdownButtonFormField<String>(
                  value: treinoSelecionado,
                  items: nomesTreinos.map((nome) {
                    return DropdownMenuItem<String>(
                      value: nome,
                      child: Text(nome),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      treinoSelecionado = valor;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Selecione o Treino'),
                )
              : Text('Nenhum treino disponível para selecionar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: treinoSelecionado != null
                  ? () {
                      setState(() {
                        Treino treino = _controller.historicoTreinos.firstWhere(
                            (treino) => treino.nome == treinoSelecionado);
                        _controller.editarTreinoDoDia(
                            treino.nome, treino.duracao, treino.intensidade);
                      });
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _navegarParaHistorico() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WorkoutHistoryPage(historicoTreinos: _controller.historicoTreinos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FitnessFusion'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWorkoutOfTheDay(),
              SizedBox(height: 16),
              _buildTrainingsCard(),
              SizedBox(height: 16),
              _buildUpcomingClasses(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateWorkoutPage(controller: _controller),
                    ),
                  );
                },
                child: Text('Cadastrar Novo Treino'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _navegarParaHistorico,
                child: Text('Ver Histórico de Treinos'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutOfTheDay() {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Treino do Dia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _controller.treinoDoDia != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _controller.treinoDoDia!.nome,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${_controller.treinoDoDia!.duracao} • ${_controller.treinoDoDia!.intensidade}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              treinoCheckInFeito
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Colors.blue,
                              size: 30,
                            ),
                            onPressed: _fazerCheckIn,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 30,
                            ),
                            onPressed: _editarTreinoDoDia,
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    'Nenhum treino cadastrado para hoje.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Treinos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '$totalCheckIns',
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClasses() {
    List<Treino> treinosAmanha = _controller.historicoTreinos.where((treino) {
      DateTime treinoDate = DateTime.parse(treino.data);
      DateTime amanha = DateTime.now().add(Duration(days: 1));
      return treinoDate.year == amanha.year &&
          treinoDate.month == amanha.month &&
          treinoDate.day == amanha.day;
    }).toList();

    List<Treino> treinosProximoDia =
        _controller.historicoTreinos.where((treino) {
      DateTime treinoDate = DateTime.parse(treino.data);
      DateTime proximoDia = DateTime.now().add(Duration(days: 2));
      return treinoDate.year == proximoDia.year &&
          treinoDate.month == proximoDia.month &&
          treinoDate.day == proximoDia.day;
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Classes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (treinosAmanha.isNotEmpty) ...[
              Text(
                'Amanhã',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              for (var treino in treinosAmanha)
                _buildClassInfo(treino.nome, 'Amanhã'),
              Divider(),
            ],
            if (treinosProximoDia.isNotEmpty) ...[
              Text(
                'Próximo Dia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              for (var treino in treinosProximoDia)
                _buildClassInfo(treino.nome, 'Próximo Dia'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClassInfo(String className, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          className,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          time,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
