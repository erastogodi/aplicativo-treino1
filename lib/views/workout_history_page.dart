import 'package:flutter/material.dart';
import '../models/treino.dart';

class WorkoutHistoryPage extends StatelessWidget {
  final List<Treino>? historicoTreinos; // Parâmetro opcional

  const WorkoutHistoryPage({super.key, this.historicoTreinos});

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
        itemCount: historicoTreinos?.length ?? 0, // Verificação opcional
        itemBuilder: (context, index) {
          final treino = historicoTreinos?[index];
          return ListTile(
            title: Text(treino?.nome ?? 'Sem nome'),
            subtitle: Text(
                '${treino?.duracao ?? 'Sem duração'} • ${treino?.intensidade ?? 'Sem intensidade'}'),
          );
        },
      ),
    );
  }
}
