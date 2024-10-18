import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'macros_form_view.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_fitness.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Transparent Layer to darken the background slightly for better contrast
          Container(
            color: Colors.black.withOpacity(0.5), // Optional: darken background
          ),
          // Login Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Texto principal com fonte arredondada e cor branca
                Text(
                  'Treino App',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto branco com sombra
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.8), // Sombra escura
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Texto menor: "Faça Login"
                Text(
                  'Faça Login',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(
                          0.9), // Cor branca com leve transparência
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Campos de texto com opacidade no fundo para melhor legibilidade
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.7), // Fundo dos campos com opacidade
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.7), // Fundo dos campos com opacidade
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),
                // Botão de Entrar com opacidade
                ElevatedButton(
                  onPressed: () {
                    // Implementar lógica de login
                  },
                  child: Text('Entrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white
                        .withOpacity(0.8), // Botão claro para contraste
                    foregroundColor: Colors.black, // Texto do botão em preto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Botão de Pular com estilo transparente
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MacrosFormView()),
                    );
                  },
                  child: Text('Pular'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Botão transparente
                    foregroundColor:
                        Colors.white, // Texto branco para melhor contraste
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
