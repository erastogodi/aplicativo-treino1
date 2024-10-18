import 'package:flutter/material.dart';
import 'views/login_view.dart';

void main() {
  runApp(TreinoApp());
}

class TreinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treino App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginView(),
    );
  }
}
