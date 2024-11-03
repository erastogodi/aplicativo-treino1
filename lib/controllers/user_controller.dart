import '../models/user_model.dart';

class UserController {
  UserModel? user;
  double _currentWaterIntake = 0; // Para rastrear a quantidade de água ingerida

  // Define os dados físicos do usuário
  void setPhysicalData({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
  }) {
    user = UserModel(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      email: '',
      password: '',
    );
  }

  // Define os dados de login do usuário
  void setLoginData(String email, String password) {
    if (user != null) {
      user!.email = email;
      user!.password = password;
    } else {
      user = UserModel(
        weight: 0,
        height: 0,
        age: 0,
        gender: '',
        activityLevel: '',
        email: email,
        password: password,
      );
    }
  }

  // Função para calcular os macros e a quantidade de água
  Map<String, dynamic> calculateMacros() {
    if (user == null) {
      throw Exception("Os dados do usuário não foram definidos.");
    }

    double baseCalories = _calculateBaseCalories();
    double activityMultiplier = _getActivityMultiplier();
    double totalCalories = baseCalories * activityMultiplier;
    double protein = _calculateProtein();
    double fat = _calculateFat(totalCalories);
    double carbs = _calculateCarbs(totalCalories, protein, fat);
    double waterIntake = _calculateWaterIntake();

    return {
      'calories': totalCalories / 4,
      'protein': protein / 4,
      'fat': fat / 4,
      'carbs': carbs / 4,
      'water': waterIntake,
    };
  }

  double _calculateBaseCalories() {
    double baseCalories = (10 * (user?.weight ?? 0)) +
        (6.25 * (user?.height ?? 0)) -
        (5 * (user?.age ?? 0));
    return user?.gender == 'Masculino' ? baseCalories + 5 : baseCalories - 161;
  }

  double _getActivityMultiplier() {
    switch (user?.activityLevel) {
      case 'Médio':
        return 1.55;
      case 'Alto':
        return 1.9;
      default:
        return 1.2;
    }
  }

  double _calculateProtein() => (user?.weight ?? 0) * 1.8;

  double _calculateFat(double totalCalories) => totalCalories * 0.25 / 9;

  double _calculateCarbs(double totalCalories, double protein, double fat) {
    return (totalCalories - (protein * 4 + fat * 9)) / 4;
  }

  double _calculateWaterIntake() => (user?.weight ?? 0) * 35;

  // Métodos para manipular a água ingerida
  double getCurrentWaterIntake() {
    return _currentWaterIntake;
  }

  void addWater(double totalWaterIntake) {
    _currentWaterIntake += 350; // Adiciona 350ml por clique
    if (_currentWaterIntake > totalWaterIntake) {
      _currentWaterIntake =
          totalWaterIntake; // Limita ao total de água recomendado
    }
  }

  // Método para obter os dados físicos do usuário
  UserModel? getUserData() {
    return user;
  }

  void removeWater() {
    _currentWaterIntake -= 350; // Remove 350ml por clique
    if (_currentWaterIntake < 0) {
      _currentWaterIntake = 0; // Limita a zero
    }
  }
}
