import 'package:intl/intl.dart';
import '../models/treino.dart';

class HomeController {
  List<Treino> historicoTreinos = [];
  Treino? treinoDoDia;

  void carregarTreinoDoDia() {
    String dataHoje = DateFormat('yyyy-MM-dd').format(DateTime.now());
    treinoDoDia = Treino(
      nome: 'Treino de Força do Dia $dataHoje',
      data: dataHoje,
      duracao: '45 minutos',
      intensidade: 'Alta',
    );
  }

  void fazerCheckIn(Treino treino, Function() updateState) {
    historicoTreinos.add(treino);
    updateState();
  }

  void editarTreinoDoDia(String nome, String duracao, String intensidade) {
    if (treinoDoDia != null) {
      treinoDoDia!.nome = nome;
      treinoDoDia!.duracao = duracao;
      treinoDoDia!.intensidade = intensidade;
    }
  }

  void adicionarTreino(Treino treino) {
    historicoTreinos.add(treino);
  }

  List<String> getNomesDeTreinos() {
    return historicoTreinos.map((treino) => treino.nome).toList();
  }
}
