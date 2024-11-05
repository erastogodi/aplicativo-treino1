import 'package:intl/intl.dart';
import '../models/treino.dart';

class HomeController {
  List<Treino> historicoTreinos = [];
  Treino? treinoDoDia;
  bool checkInFeito = false; // Indica se o check-in foi feito

  void carregarTreinoDoDia() {
    String dataHoje = DateFormat('yyyy-MM-dd').format(DateTime.now());
    treinoDoDia = Treino(
      nome: 'Treino de Força do Dia $dataHoje',
      data: dataHoje,
      duracao: '45 minutos',
      intensidade: 'Alta',
    );
  }

  void alternarCheckIn(Treino treino, Function() updateState) {
    if (checkInFeito) {
      // Se o check-in já foi feito, remove o treino do histórico
      historicoTreinos.removeWhere((t) => t.data == treino.data);
      checkInFeito = false;
    } else {
      // Caso contrário, adiciona o treino ao histórico
      historicoTreinos.add(treino);
      checkInFeito = true;
    }
    updateState(); // Atualiza o estado da interface
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
