import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/app_pages/auth_page/auth_database.dart';
import 'package:petlink_flutter_app/app_pages/auth_page/widget/custom_textfield.dart';
import 'package:petlink_flutter_app/database/connection.dart';
import 'package:petlink_flutter_app/home_page_main.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myDatabase = Database();

  @override
  void initState() {
    super.initState();
    myDatabase.createConnection();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  late bool correct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
          const SizedBox(height: 30),
          customTextFormField(
            context: context,
            padding: const EdgeInsets.all(25),
            controller: emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          customTextFormField(
            context: context,
            padding: const EdgeInsets.all(25),
            controller: passwordController,
            labelText: 'Password',
            keyboardType: TextInputType.name,
            obscureText: passwordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                handleLogin(context, AuthService(myDatabase.connection));
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
                  'LOG IN',
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You do not have an account?",
                style: TextStyle(fontFamily: 'BalooDa2', fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  "  Signup here!",
                  style: TextStyle(
                    fontFamily: 'BalooDa2',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> handleLogin(
      BuildContext context, AuthService authService) async {
    final username = emailController.text;
    final password = passwordController.text;

    if (authService.isValidCredentials(username, password)) {
      final success = await authService.authenticateUser(username, password);
      if (success == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Datos válidos')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Datos inválidos')));
        return success;
      }
    }
    return null;
  }
}
