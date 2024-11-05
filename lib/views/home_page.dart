import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treino_app/controllers/user_controller.dart';
import '../controllers/home_controller.dart';
import '../models/treino.dart';
import 'workout_history_page.dart';
import 'create_workout_page.dart';

class HomePage extends StatefulWidget {
  final UserController? userController;

  const HomePage({super.key, this.userController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  int totalCheckIns = 0;

  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller.carregarTreinoDoDia();
    totalCheckIns = _controller.historicoTreinos.length;
  }

  void _alternarCheckIn() {
    if (_controller.treinoDoDia != null) {
      _controller.alternarCheckIn(
        _controller.treinoDoDia!,
        () {
          setState(() {
            totalCheckIns = _controller.historicoTreinos.length;
          });
        },
      );
    }
  }

  void _startPauseTimer() {
    setState(() {
      if (_isRunning) {
        _timer?.cancel();
      } else {
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _seconds++;
          });
        });
      }
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _seconds = 0;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _editarTreinoDoDia() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> nomesTreinos = _controller.getNomesDeTreinos();
        String? treinoSelecionado =
            nomesTreinos.isNotEmpty ? nomesTreinos.first : null;

        return AlertDialog(
          title: Text('Editar Treino do Dia', style: GoogleFonts.lato()),
          content: treinoSelecionado != null
              ? DropdownButtonFormField<String>(
                  value: treinoSelecionado,
                  items: nomesTreinos.map((nome) {
                    return DropdownMenuItem<String>(
                      value: nome,
                      child: Text(nome, style: GoogleFonts.lato()),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      treinoSelecionado = valor;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Selecione o Treino'),
                )
              : Text('Nenhum treino disponível para selecionar.',
                  style: GoogleFonts.lato()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar', style: GoogleFonts.lato()),
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
              child: Text('Salvar', style: GoogleFonts.lato()),
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
        title: Text(
          'FitnessFusion - Bem-vindo, ${widget.userController?.user?.email ?? 'Usuário'}',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_treino.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorkoutOfTheDay(),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Total de Dias',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTrainingsCard(),
                    SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTransparentButton(
                          'Cadastrar Novo Treino',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateWorkoutPage(controller: _controller),
                              ),
                            );
                          },
                          iconPath: 'assets/images/novo.png',
                        ),
                        SizedBox(height: 8),
                        _buildTransparentButton(
                          'Ver Histórico de Treinos',
                          _navegarParaHistorico,
                          iconPath: 'assets/images/historia.png',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Cronômetro',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 21.6,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Image.asset(
                        'assets/images/relogio.png',
                        width: 72,
                        height: 72,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _formatTime(_seconds),
                        style: GoogleFonts.montserrat(
                          fontSize: 32.4,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _startPauseTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.7),
                              foregroundColor: Colors.black,
                              minimumSize: Size(90, 36),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                            ),
                            child: Text(_isRunning ? 'Pausar' : 'Iniciar',
                                style: GoogleFonts.lato()),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _resetTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.7),
                              foregroundColor: Colors.black,
                              minimumSize: Size(90, 36),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                            ),
                            child: Text('Resetar', style: GoogleFonts.lato()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutOfTheDay() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(58, 58, 58, 1), // Cor sólida de fundo do card
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Treino do Dia',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            _controller.treinoDoDia != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.treinoDoDia!.nome,
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${_controller.treinoDoDia!.duracao} • ${_controller.treinoDoDia!.intensidade}',
                        style: GoogleFonts.poppins(color: Colors.grey[200]),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Image.asset(
                            'assets/images/edit.png',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: _editarTreinoDoDia,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Nenhum treino cadastrado para hoje.',
                    style: GoogleFonts.poppins(color: Colors.grey[200]),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingsCard() {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.7),
            Colors.grey[400]!.withOpacity(0.7),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Treinos',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                '$totalCheckIns',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            IconButton(
              icon: Icon(
                _controller.checkInFeito
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.blue,
                size: 30,
              ),
              onPressed: _alternarCheckIn,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransparentButton(String text, VoidCallback onPressed,
      {String? iconPath}) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
              ),
            ),
            if (iconPath != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
