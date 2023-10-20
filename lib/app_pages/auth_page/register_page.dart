import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/app_pages/auth_page/auth_database.dart';
import 'package:petlink_flutter_app/app_pages/auth_page/widget/custom_textfield.dart';
import 'package:petlink_flutter_app/database/connection.dart';
import 'package:postgres/postgres.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final myDatabase = Database();

  @override
  void initState() {
    super.initState();
    myDatabase.createConnection();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController secondPasswordController =
      TextEditingController();
  bool passwordVisible = false;

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app_icon.png',
                width: 120,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'PetLink',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BalooDa2',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              customTextFormField(
                context: context,
                padding: const EdgeInsets.all(20),
                controller: emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              customTextFormField(
                context: context,
                padding: const EdgeInsets.all(20),
                controller: passwordController,
                labelText: 'Password',
                keyboardType: TextInputType.emailAddress,
              ),
              customTextFormField(
                context: context,
                padding: const EdgeInsets.all(20),
                controller: secondPasswordController,
                labelText: 'Confirm password',
                keyboardType: TextInputType.emailAddress,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;

                    if (AuthService(myDatabase.connection)
                            .isValidEmail(email) &&
                        AuthService(myDatabase.connection)
                            .isValidPassword(password)) {
                      final success = await AuthService(myDatabase.connection)
                          .registerUser(email, password);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registro exitoso')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registro fallido')));
                      }
                      ;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Datos inválidos')));
                    }
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColorDark,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                    child: const Text(
                      'SIGN UP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'BalooDa2',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Do you already have an account?",
                    style: TextStyle(fontFamily: 'BalooDa2', fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      "  Login here!",
                      style: TextStyle(
                        fontFamily: 'BalooDa2',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'BalooDa2',
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

/*
  void _signup() async {
    final email = emailController.text;
    final password = passwordController.text;
    final secondPassword = secondPasswordController.text;

    final emailExists = await checkEmail(myDatabase.connection, email);

    final errorMessage = SignupValidation.validateSignup(
      email: email,
      password: password,
      secondPassword: password,
      availableEmail: emailExists,
    );
  }

  Future<bool> checkEmail(PostgreSQLConnection connection, String email) async {
    final results = await connection.query(
      'SELECT * FROM users WHERE email = @email',
      substitutionValues: {
        'email': email,
      },
    );

    return results.isEmpty;
  }*/
}
/*
class SignupValidation {
  static String? validateSignup(
      {required String email,
      required String password,
      required String secondPassword,
      required bool availableEmail}) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Ingresa un correo electrónico válido.';
    }
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (availableEmail == false) {
      return 'Lo siento este correo ya está en uso.';
    }
    if (password != secondPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}*/
