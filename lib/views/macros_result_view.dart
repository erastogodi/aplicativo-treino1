import 'package:flutter/material.dart';

class MacrosResultView extends StatefulWidget {
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String activityLevel;

  const MacrosResultView({
    super.key,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });

  @override
  _MacrosResultViewState createState() => _MacrosResultViewState();
}

class _MacrosResultViewState extends State<MacrosResultView> {
  double currentWaterIntake = 0; // Começa com 0 ml de água

  // Função para calcular os macros e a quantidade de água
  Map<String, dynamic> calculateMacros() {
    double baseCalories =
        (10 * widget.weight) + (6.25 * widget.height) - (5 * widget.age);
    if (widget.gender == 'Masculino') {
      baseCalories += 5;
    } else {
      baseCalories -= 161;
    }

    double activityMultiplier = 1.2;
    if (widget.activityLevel == 'Médio') {
      activityMultiplier = 1.55;
    } else if (widget.activityLevel == 'Alto') {
      activityMultiplier = 1.9;
    }
    double totalCalories = baseCalories * activityMultiplier;

    double protein = widget.weight * 1.8;
    double fat = totalCalories * 0.25 / 9;
    double carbs = (totalCalories - (protein * 4 + fat * 9)) / 4;

    // Cálculo da quantidade de água (ml) recomendada por dia
    double waterIntake =
        widget.weight * 35; // Fórmula simples: 35ml por kg de peso

    // Dividir os macros em 4 refeições
    return {
      'calories': totalCalories / 4,
      'protein': protein / 4,
      'fat': fat / 4,
      'carbs': carbs / 4,
      'water': waterIntake, // Quantidade total de água
    };
  }

  // Função para aumentar a quantidade de água ingerida
  void addWater() {
    final macros = calculateMacros();
    setState(() {
      if (currentWaterIntake < macros['water']) {
        currentWaterIntake += 350;
        if (currentWaterIntake > macros['water']) {
          currentWaterIntake = macros['water']; // Limita ao máximo
        }
      }
    });
  }

  // Função para reduzir a quantidade de água ingerida
  void removeWater() {
    setState(() {
      if (currentWaterIntake >= 350) {
        currentWaterIntake -= 350;
      } else {
        currentWaterIntake = 0; // Limita a zero
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final macros = calculateMacros();
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (ofuscado)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.jpg'), // Use the background image que você preferir
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent Layer to darken the background slightly for better contrast
          Container(
            color: Colors.black.withOpacity(0.5), // Optional: darken background
          ),
          // Main Content
          Column(
            children: [
              // Título "Cálculo dos Macros" (fixo no topo)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  'Cálculo dos Macros',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.8),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Resto da tela com scroll
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Quantidade de água no topo com o contador
                        _buildWaterIntake(macros['water']),
                        const SizedBox(height: 20),
                        // Seções das refeições uma embaixo da outra
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            final meals = [
                              'Café da Manhã',
                              'Almoço',
                              'Café da Tarde',
                              'Jantar'
                            ];
                            final icons = [
                              'assets/images/icons8-bitten-apple-40.png', // Agora este ícone será o do Café da Manhã
                              'assets/images/icons8-lunch-80.png', // Almoço permanece o mesmo
                              'assets/images/icons8-breakfast-64 (1).png', // Agora este ícone será o do Café da Tarde
                              'assets/images/icons8-green-salad-48.png', // Jantar permanece o mesmo
                            ];
                            return _buildMacroSection(
                                meals[index], macros, icons[index]);
                          },
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

  // Função para criar o contador de água com ícones de "mais" e "menos"
  Widget _buildWaterIntake(double waterIntake) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100.withOpacity(0.8), // Cor azul clara (água)
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de copo de água
              Icon(
                Icons.local_drink,
                color: Colors.blue.shade700,
                size: 30,
              ),
              const SizedBox(width: 10),
              // Texto da quantidade de água sem "de Água"
              Text(
                '${currentWaterIntake.toStringAsFixed(0)} / ${waterIntake.toStringAsFixed(0)} ml',
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
          // Barra de progresso de água
          LinearProgressIndicator(
            value: currentWaterIntake / waterIntake, // Progresso da água
            backgroundColor: Colors.blue.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
          const SizedBox(height: 10),
          // Botões minimalistas para adicionar ou remover 350ml de água com o texto "Quantidade de Água"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: removeWater,
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
                onPressed: addWater,
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

  // Função para criar as seções das refeições com os ícones ajustados ao lado direito e exibir os macros
  Widget _buildMacroSection(
      String meal, Map<String, dynamic> macros, String iconPath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade100.withOpacity(0.9), // Cor verde mais suave
        borderRadius: BorderRadius.circular(10), // Menos arredondado
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Espaçamento total
            children: [
              // Texto da refeição
              Expanded(
                child: Text(
                  meal,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.teal.shade900,
                  ),
                  textAlign: TextAlign.left, // Texto à esquerda
                ),
              ),
              // Ícone da refeição ao lado direito
              Image.asset(
                iconPath,
                width: 30, // Mesma largura para todos os ícones
                height: 30, // Mesma altura para todos os ícones
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.teal.shade300), // Linha de separação
          // Informações dos macros
          _buildMacroRow(
              'Calorias', macros['calories'].toStringAsFixed(0), 'kcal'),
          Divider(color: Colors.teal.shade300),
          _buildMacroRow(
              'Proteínas', macros['protein'].toStringAsFixed(1), 'g'),
          Divider(color: Colors.teal.shade300),
          _buildMacroRow('Gorduras', macros['fat'].toStringAsFixed(1), 'g'),
          Divider(color: Colors.teal.shade300),
          _buildMacroRow(
              'Carboidratos', macros['carbs'].toStringAsFixed(1), 'g'),
        ],
      ),
    );
  }

  // Função para exibir os detalhes de cada macro em estilo de linha
  Widget _buildMacroRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4), // Ajustado para espaçamento consistente
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
