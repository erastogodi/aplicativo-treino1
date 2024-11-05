class UserModel {
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String activityLevel;
  final String email;
  final String password;

  UserModel({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.email,
    required this.password,
  });

  UserModel copyWith({
    double? weight,
    double? height,
    int? age,
    String? gender,
    String? activityLevel,
    String? email,
    String? password,
  }) {
    return UserModel(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
