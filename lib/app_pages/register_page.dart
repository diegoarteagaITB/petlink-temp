import 'package:flutter/material.dart';
import 'package:petlink_flutter_app/app_pages/home_page_main.dart';
import 'package:petlink_flutter_app/app_pages/widgets/custom_textfield.dart';
import 'package:petlink_flutter_app/database/connection/connection.dart';
import 'package:petlink_flutter_app/database/dao/users_dao.dart';
import 'package:petlink_flutter_app/model/users_model.dart';
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

  bool passwordVisible = false;

  final List<TextEditingController> textControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<String> fieldTextType = [
    "First name",
    "Last name",
    "DNI",
    "Phone",
    "Email",
    "Password"
  ];

  final List<TextInputType> fieldInputType = List.generate(
    6,
    (index) {
      if (index == 4) {
        return TextInputType.number;
      } else if (index == 5) {
        return TextInputType.emailAddress;
      } else {
        return TextInputType.text;
      }
    },
  );

  final User? user = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  width: 120,
                ),
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
              for (var i = 0; i < 6; i++)
                customTextFormField(
                  context: context,
                  padding: const EdgeInsets.all(20),
                  controller: textControllers[i],
                  labelText: fieldTextType[i],
                  keyboardType: fieldInputType[i],
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      final user = User(
                        id: 1,
                        name: textControllers[1].text,
                        dni: textControllers[2].text,
                        phone: textControllers[3].text,
                        email: textControllers[4].text,
                        password: textControllers[5].text,
                        profileImg: "placeholder.png",
                      );
                      SignupValidation.validateSignup(
                          connection: myDatabase.connection,
                          user: user,
                          context: context);
                    });
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
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Row(
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
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        "  Log in here!",
                        style: TextStyle(
                          fontFamily: 'BalooDa2',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupValidation {
  static Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?>
      validateSignup(
          {required PostgreSQLConnection connection,
          required User user,
          required BuildContext context}) async {
    final userChecks = UserDao(connection, user);
    if (!userChecks.isValidEmail()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce un email válido'),
        ),
      );
    } else if (!userChecks.isValidPassword()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe contener al menos 6 caracteres'),
        ),
      );
    } else if (userChecks.userNotExists() == false) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Este email ya está en uso, por favor introduce uno nuevo'),
        ),
      );
    } else if (!userChecks.validateDni()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe un DNI válido'),
        ),
      );
    } else if (!userChecks.validPhone()) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe un número de teléfono válido'),
        ),
      );
    } else {
      //userChecks.registerUser();
      final fullName = await userChecks.getUserFullName();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  fullName: fullName.toString(),
                )),
      );
    }
    return null;
  }
}
