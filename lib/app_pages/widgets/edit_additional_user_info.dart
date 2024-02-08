import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/authentication_service.dart';
import 'package:petlink_flutter_app/app_pages/account_page_main.dart';
import 'package:petlink_flutter_app/model/additional_info_model.dart';

class EditUserInfo extends StatelessWidget {
  final int userId;

  const EditUserInfo({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Formulario(userId: userId),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Formulario extends StatefulWidget {
  final int userId;

  const Formulario({Key? key, required this.userId}) : super(key: key);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();
  bool _foster = false;
  String _slogan = '';
  int _age = 0;
  String _city = '';
  String _description = '';

Future<void> _submitForm(int userId) async {
  if (_formKey.currentState!.validate()) {
    String slogan = _slogan.isNotEmpty ? _slogan : ''; // Valor predeterminado para el slogan
    int age = _age ?? 0; // Valor predeterminado para la edad
    String city = _city.isNotEmpty ? _city : ''; // Valor predeterminado para la ciudad
    String description = _description.isNotEmpty ? _description : ''; // Valor predeterminado para la descripción

    bool success = await AuthService().updateAdditionalUserInfo(
      userId,
      age,
      city,
      slogan,
      description,
      _foster,
    );
    if (success) {
      // Actualización exitosa, maneja la navegación o muestra un mensaje de éxito.
      print('Información actualizada con éxito');
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage(userId: userId),)
            );
    } else {
      // Fallo en la actualización, maneja el error.
      print('Error al actualizar la información');
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Slogan'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Por favor ingresa un slogan';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _slogan = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Edad'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Por favor ingresa una edad';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _age = int.tryParse(value) ?? 0;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Ciudad'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Por favor ingresa una ciudad';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _city = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Descripción'),
            maxLines: null,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Por favor ingresa una descripción';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _description = value;
              });
            },
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: _foster,
                onChanged: (value) {
                  setState(() {
                    _foster = value ?? false;
                  });
                },
              ),
              Text('Foster')
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => _submitForm(widget.userId),
              child: Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }
}
