import 'package:flutter/material.dart';
import 'package:treino_app/views/home_page.dart';
import 'package:treino_app/views/new_macros_result_view.dart';
import 'package:treino_app/views/profile.dart';
import 'package:treino_app/controllers/user_controller.dart';

class MainNavBar extends StatefulWidget {
  final UserController userController;
  final int initialPage;

  // Construtor para Login - Inicia com dados padrão
  MainNavBar.login({super.key})
      : userController = UserController()
          ..setPhysicalData(
            weight: 70.0,
            height: 170.0,
            age: 25,
            gender: 'Masculino',
            activityLevel: 'Moderado',
          ),
        initialPage = 0;

  // Construtor para Calcular Macros - Recebe UserController com dados personalizados
  const MainNavBar.calculateMacros({super.key, required this.userController})
      : initialPage = 1;

  @override
  _MainNavBarState createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPage;
  }

  late final List<Widget> _pagesWithNavBar = [
    HomePage(),
    NewMacrosResultView(
      weight: widget.userController.getPhysicalData()?.weight ?? 70.0,
      height: widget.userController.getPhysicalData()?.height ?? 170.0,
      age: widget.userController.getPhysicalData()?.age ?? 25,
      gender: widget.userController.getPhysicalData()?.gender ?? 'Masculino',
      activityLevel:
          widget.userController.getPhysicalData()?.activityLevel ?? 'Moderado',
      controller: widget.userController,
    ),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pagesWithNavBar[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Macros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
