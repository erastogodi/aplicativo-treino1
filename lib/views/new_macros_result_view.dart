import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

class NewMacrosResultView extends StatefulWidget {
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String activityLevel;
  final UserController? controller;

  const NewMacrosResultView({
    super.key,
    this.weight = 70.0, // Valor padrão
    this.height = 170.0, // Valor padrão
    this.age = 25, // Valor padrão
    this.gender = 'Masculino', // Valor padrão
    this.activityLevel = 'Moderado', // Valor padrão
    this.controller,
  });

  @override
  _NewMacrosResultViewState createState() => _NewMacrosResultViewState();
}

class _NewMacrosResultViewState extends State<NewMacrosResultView> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.setPhysicalData(
        weight: widget.weight,
        height: widget.height,
        age: widget.age,
        gender: widget.gender,
        activityLevel: widget.activityLevel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final macros = widget.controller?.calculateMacros() ?? {};

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.6),
                child: const Text(
                  'Cálculo dos Macros',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildWaterIntake(macros['water'] ?? 0),
                        const SizedBox(height: 20),
                        // Substituindo ListView.builder por Column
                        Column(
                          children: [
                            _buildMacroSection('Café da Manhã', macros,
                                'assets/images/icons8-bitten-apple-40.png'),
                            _buildMacroSection('Almoço', macros,
                                'assets/images/icons8-lunch-80.png'),
                            _buildMacroSection('Café da Tarde', macros,
                                'assets/images/icons8-breakfast-64.png'),
                            _buildMacroSection('Jantar', macros,
                                'assets/images/icons8-green-salad-48.png'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterIntake(double waterIntake) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_drink,
                color: Colors.blue.shade700,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.controller?.getCurrentWaterIntake().toStringAsFixed(0) ?? '0'} / ${waterIntake.toStringAsFixed(0)} ml',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (widget.controller?.getCurrentWaterIntake() ?? 0) /
                (waterIntake > 0 ? waterIntake : 1),
            backgroundColor: Colors.blue.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.controller?.removeWater();
                  });
                },
                icon: const Text(
                  '-',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Quantidade de Água',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.controller?.addWater(waterIntake);
                  });
                },
                icon: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroSection(
      String meal, Map<String, dynamic> macros, String iconPath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade100.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  meal,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal.shade900,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Image.asset(
                iconPath,
                width: 30,
                height: 30,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.teal.shade300),
          _buildMacroRow('Calorias',
              macros['calories']?.toStringAsFixed(0) ?? '0', 'kcal'),
          Divider(color: Colors.teal.shade300),
          _buildMacroRow(
              'Proteínas', macros['protein']?.toStringAsFixed(1) ?? '0', 'g'),
          Divider(color: Colors.teal.shade300),
          _buildMacroRow(
              'Gorduras', macros['fat']?.toStringAsFixed(1) ?? '0', 'g'),
          Divider(color: Colors.teal.shade300),
          _buildMacroRow(
              'Carboidratos', macros['carbs']?.toStringAsFixed(1) ?? '0', 'g'),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.teal.shade800,
              ),
            ),
          ),
          Flexible(
            child: Text(
              '$value $unit',
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
