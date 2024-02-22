import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/api/ktor/authentication_service.dart';
import 'package:petlink_flutter_app/app_pages/account_page_main.dart';
import 'package:petlink_flutter_app/model/additional_info_model.dart';

class EditUserInfo extends StatelessWidget {
  final int userId;
  final String slogan;
  final int age;
  final String city;
  final String description;
  final bool foster;
  final String imgId;

  const EditUserInfo({
    Key? key,
    required this.userId,
    required this.slogan,
    required this.age,
    required this.city,
    required this.description,
    required this.foster,
    required this.imgId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Formulario(
                userId: userId,
                slogan: slogan,
                age: age,
                city: city,
                description: description,
                foster: foster,
                imgId: imgId,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Formulario extends StatefulWidget {
  final int userId;
  final String slogan;
  final int age;
  final String city;
  final String description;
  final bool foster;
  final String imgId;

  const Formulario({
    Key? key,
    required this.userId,
    required this.slogan,
    required this.age,
    required this.city,
    required this.description,
    required this.foster,
    required this.imgId,
  }) : super(key: key);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();
  late String _slogan;
  late int _age;
  late String _city;
  late String _description;
  late bool _foster;
  late String _imgId;

  @override
  void initState() {
    super.initState();
    _slogan = widget.slogan;
    _age = widget.age;
    _city = widget.city;
    _description = widget.description;
    _foster = widget.foster;
    _imgId = widget.imgId;
  }

 Future<void> _submitForm(int userId) async {
  if (_formKey.currentState!.validate()) {
    bool success = await AuthService().updateAdditionalUserInfo(
      userId,
      _age,
      _city,
      _slogan,
      _description,
      _foster,
      _imgId
    );
    if (success) {
      // Actualización exitosa, maneja la navegación o muestra un mensaje de éxito.
      print('Información actualizada con éxito');
      Navigator.pop(context);
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
            initialValue: widget.slogan,
            decoration: InputDecoration(
              labelText: 'Slogan',
              hintText: 'Ingrese su eslogan aquí',
            ),
            onChanged: (value) {
              setState(() {
                _slogan = value;
              });
            },
          ),
          TextFormField(
            initialValue: widget.age.toString(),
            decoration: InputDecoration(
              labelText: 'Edad',
              hintText: 'Ingrese su edad aquí',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _age = int.tryParse(value) ?? 0;
              });
            },
          ),
          TextFormField(
            initialValue: widget.city,
            decoration: InputDecoration(
              labelText: 'Ciudad',
              hintText: 'Ingrese su ciudad aquí',
            ),
            onChanged: (value) {
              setState(() {
                _city = value;
              });
            },
          ),
          TextFormField(
            initialValue: widget.description,
            decoration: InputDecoration(
              labelText: 'Descripción',
              hintText: 'Ingrese su descripción aquí',
            ),
            maxLines: null,
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
