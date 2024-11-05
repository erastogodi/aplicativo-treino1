import '../models/user_model.dart';

class UserController {
  UserModel? user;
  double _currentWaterIntake = 0;

  // Credenciais fixas para o usuário admin
  final String _adminEmail = "admin";
  final String _adminPassword = "admin";

  // Função para autenticar o usuário
  bool authenticate(String email, String password) {
    if (email == _adminEmail && password == _adminPassword) {
      user = UserModel(
        weight: 70,
        height: 175,
        age: 30,
        gender: 'Masculino',
        activityLevel: 'Médio',
        email: email,
        password: password,
      );
      return true;
    }
    return false;
  }

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
      email: user?.email ?? '',
      password: user?.password ?? '',
    );
  }

  // Get que retorna todos os dados físicos do usuário
  UserModel? getPhysicalData() => user;

  // Atualiza os dados do usuário com os novos valores fornecidos
  void updateUser({
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
    String? email,
    required String password,
  }) {
    if (user != null) {
      user = user!.copyWith(
        weight: weight,
        height: height,
        age: age,
        gender: gender,
        activityLevel: activityLevel,
        email: email ?? user!.email,
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

  // Métodos de cálculo para os macros
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
  double getCurrentWaterIntake() => _currentWaterIntake;

  void addWater(double totalWaterIntake) {
    _currentWaterIntake += 350; // Adiciona 350ml por clique
    if (_currentWaterIntake > totalWaterIntake) {
      _currentWaterIntake =
          totalWaterIntake; // Limita ao total de água recomendado
    }
  }

  void removeWater() {
    _currentWaterIntake -= 350; // Remove 350ml por clique
    if (_currentWaterIntake < 0) {
      _currentWaterIntake = 0; // Limita a zero
    }
  }
}
