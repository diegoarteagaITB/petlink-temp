import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/app_pages/home_page_main.dart';
import 'package:petlink_flutter_app/app_pages/widgets/custom_textfield.dart';
import 'package:petlink_flutter_app/database/connection/connection.dart';
import 'package:petlink_flutter_app/database/dao/users_dao.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
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
                final email = emailController.text;
                final password = passwordController.text;
                /*final user = User(
                    firstName: "",
                    lastName: "",
                    dni: "",
                    email: email,
                    password: password,
                    phone: "",
                    profileImg: "placeholder.png");

                handleLogin(context, UserDao(myDatabase.connection, user));*/
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
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  "  Sign up here!",
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

  Future handleLogin(BuildContext context, UserDao userDao) async {
    if (!userDao.isValidEmail()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe un email válido'),
        ),
      );
    } else if (!userDao.isValidPassword()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe una contraseña válida'),
        ),
      );
    } else if (!userDao.isValidCredentials()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rellena correctamente los campos'),
        ),
      );
    } else if (await userDao.loginUser()) {
      final fullName = await userDao.getUserFullName();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            fullName: fullName.toString(),
          ),
        ),
      );
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Algo salió mal'),
        ),
      );
    }
  }
}
