import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/treino.dart';
import '../models/user_model.dart';
import 'workout_history_page.dart';
import 'create_workout_page.dart';
import 'profile.dart'; // Importe a página de perfil
import 'new_macros_result_view.dart'; // Importe a página de macros (NewMacrosResultView)
import '../controllers/user_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  final UserController _userController =
      UserController(); // Mover a instância do UserController aqui
  bool treinoCheckInFeito = false;
  int totalCheckIns = 0;
  int _selectedIndex = 0; // Adiciona o índice selecionado

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home
        break; // Fica na mesma página
      case 1: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen()), // Altere para a sua página de perfil
        );
        break;
      case 2: // Macro
        // Obter os dados do controlador
        UserModel? userData =
            _userController.getUserData(); // Usando a instância criada

        if (userData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewMacrosResultView('algum valor',
                    weight: userData.weight,
                    age: userData
                        .age, // Certifique-se de que 'age' é uma propriedade do UserModel
                    height: userData
                        .height, // Certifique-se de que 'height' é uma propriedade do UserModel
                    gender: userData
                        .gender, // Certifique-se de que 'gender' é uma propriedade do UserModel
                    activityLevel: userData
                        .activityLevel, // Certifique-se de que 'activityLevel' é uma propriedade do UserModel
                    controller:
                        _userController)), // Usar a instância correta do UserController
          );
        } else {
          // Lidar com o caso onde userData é null, se necessário
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dados do usuário não disponíveis.')),
          );
        }
        break;
    }
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood), // ícone representando "Macros"
            label: 'Macro',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
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
              '$totalCheckIns check-ins realizados',
              style: TextStyle(color: Colors.grey[600]),
            ),
            // Aqui você pode adicionar mais informações sobre treinos se necessário
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClasses() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Próximas Aulas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Adicione aqui as informações sobre as próximas aulas
          ],
        ),
      ),
    );
  }
}
