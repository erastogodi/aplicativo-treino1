import 'package:flutter/material.dart';

class MacrosResultView extends StatelessWidget {
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String activityLevel;

  MacrosResultView({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });

  // Função para calcular os macros
  Map<String, dynamic> calculateMacros() {
    double baseCalories = (10 * weight) + (6.25 * height) - (5 * age);
    if (gender == 'Masculino') {
      baseCalories += 5;
    } else {
      baseCalories -= 161;
    }

    double activityMultiplier = 1.2;
    if (activityLevel == 'Médio') {
      activityMultiplier = 1.55;
    } else if (activityLevel == 'Alto') {
      activityMultiplier = 1.9;
    }
    double totalCalories = baseCalories * activityMultiplier;

    double protein = weight * 1.8;
    double fat = totalCalories * 0.25 / 9;
    double carbs = (totalCalories - (protein * 4 + fat * 9)) / 4;

    // Dividir os macros em 4 refeições
    return {
      'calories': totalCalories / 4,
      'protein': protein / 4,
      'fat': fat / 4,
      'carbs': carbs / 4,
    };
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
                    'assets/images/background.jpg'), // Use the background image you prefer
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent Layer to darken the background slightly for better contrast
          Container(
            color: Colors.black.withOpacity(0.5), // Optional: darken background
          ),
          // Main Content with scroll enabled and no animation on scroll
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Macros por Refeição',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 167, 167, 167),
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
                const SizedBox(height: 20),
                // Seções das refeições uma embaixo da outra
                Expanded(
                  child: ListView.builder(
                    physics:
                        const ClampingScrollPhysics(), // Remove a animação de movimento, mas mantém o scroll
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final meals = [
                        'Café da Manhã',
                        'Almoço',
                        'Café da Tarde',
                        'Jantar'
                      ];
                      return _buildMacroSection(meals[index], macros);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Função para criar as seções das refeições
  Widget _buildMacroSection(String meal, Map<String, dynamic> macros) {
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
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título da refeição sem grifo
          Text(
            meal,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal, // Título sem grifo
              color: Colors.teal.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.teal.shade200),
          // Linha separadora acima das calorias
          _buildMacroRow(
              'Calorias', macros['calories'].toStringAsFixed(0), 'kcal'),
          Divider(color: Colors.teal.shade300), // Linha de separação
          _buildMacroRow(
              'Proteínas', macros['protein'].toStringAsFixed(1), 'g'),
          Divider(color: Colors.teal.shade300), // Linha de separação
          _buildMacroRow('Gorduras', macros['fat'].toStringAsFixed(1), 'g'),
          Divider(color: Colors.teal.shade300), // Linha de separação
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
