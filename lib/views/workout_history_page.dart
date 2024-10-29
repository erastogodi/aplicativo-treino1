import 'package:flutter/material.dart';
import '../models/treino.dart';

class WorkoutHistoryPage extends StatelessWidget {
  final List<Treino> historicoTreinos;

  WorkoutHistoryPage({required this.historicoTreinos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Treinos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: historicoTreinos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(historicoTreinos[index].nome),
            subtitle: Text(
                '${historicoTreinos[index].duracao} • ${historicoTreinos[index].intensidade}'),
          );
        },
      ),
    );
  }
}
