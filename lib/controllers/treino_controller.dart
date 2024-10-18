import '../models/treino_model.dart';

class TreinoController {
  List<Treino> _treinos = [];

  List<Treino> getTreinos() {
    return _treinos;
  }

  void addTreino(Treino treino) {
    _treinos.add(treino);
  }
}
