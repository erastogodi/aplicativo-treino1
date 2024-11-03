import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text('Perfil'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.teal,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://www.example.com/link-da-imagem'), // Substitua pelo link da imagem
                ),
                SizedBox(height: 10),
                Text(
                  'João Silva',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: Text('Informações Pessoais'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        buildEditableRow(
                            context, 'Email:', 'joao.silva@email.com'),
                        buildEditableRow(
                            context, 'Telefone:', '(11) 98765-4321'),
                        buildEditableRow(
                            context, 'Data de Nascimento:', '15/05/1990'),
                        buildEditableRow(
                            context, 'Localização:', 'São Paulo, SP'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: Text('Preferências'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          value: true,
                          onChanged: (bool value) {},
                          title: Text('Notificações'),
                        ),
                        SwitchListTile(
                          value: true,
                          onChanged: (bool value) {},
                          title: Text('Modo Escuro'),
                        ),
                        ListTile(
                          title: Text('Idioma: Português'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                        fieldName: 'Idioma',
                                        initialValue: 'Português')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text('$label $value'),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                  fieldName: label,
                  initialValue: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  final String fieldName;
  final String initialValue;

  EditProfileScreen({required this.fieldName, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: initialValue);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar $fieldName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Novo $fieldName',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para salvar as mudanças
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
