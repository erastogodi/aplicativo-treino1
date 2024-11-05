import 'package:flutter/material.dart';
// Importe a tela de login
import 'login_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navega para a tela de login ao clicar em "Sair"
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: Text('Sair'),
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

  const EditProfileScreen(
      {super.key, required this.fieldName, required this.initialValue});

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
