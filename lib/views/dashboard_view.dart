import 'package:flutter/material.dart';
import 'rotina_view.dart';
import 'macros_form_view.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treino App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bem-vindo de volta!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RotinaView()),
                );
              },
              child: Text('Criar Nova Rotina'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MacrosFormView()),
                );
              },
              child: Text('Calcular Macros'),
            ),
          ],
        ),
      ),
    );
  }
}
