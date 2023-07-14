import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trpo_app/screens/api_data/api_data.dart';
import 'dart:convert';
import 'package:trpo_app/screens/components/button_global.dart';
import 'package:trpo_app/screens/components/space.dart';
import 'package:trpo_app/screens/components/text_style.dart';
import 'package:trpo_app/screens/components/text_form_global.dart';
import 'package:trpo_app/screens/lecture_screen/admin_lecture_screen.dart';
import 'package:trpo_app/screens/login_screen/login_student_screen.dart';

class SignUpTeacherScreen extends StatefulWidget {
  final Function()? onTap;
  const SignUpTeacherScreen({Key? key, this.onTap}) : super(key: key);

  @override
  State<SignUpTeacherScreen> createState() => _SignUpTeacherScreenState();
}

class _SignUpTeacherScreenState extends State<SignUpTeacherScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn() async {
    const String apiUrl = ApiData.loginUrl;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'login': loginController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminLectureScreen()),
      );
    } else {
      showErrorMessage('Invalid credentials or not an admin');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Ошибка',
              style: TextStyle(color: Colors.black),
            ),
          ),
          content: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Закрываем диалоговое окно
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 53, 56, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SpaceVH(height: 50.0),
              const Text(
                'Аккаунт преподователя',
                style: headline1,
              ),
              const SpaceVH(height: 10.0),
              const Text(
                'Пожалуйста, заполните форму, чтобы продолжить',
                style: headline3,
              ),
              const SpaceVH(height: 60.0),
              TextFormGlobal(
                controller: loginController,
                text: 'Логин',
                obscure: false,
                textInputType: TextInputType.multiline,
              ),
              TextFormGlobal(
                controller: passwordController,
                text: 'Пароль',
                textInputType: TextInputType.text,
                obscure: true,
              ),
              const SpaceVH(height: 80.0),
              ButtonGlobal(
                text: "Войти",
                onTap: signIn,
              ),
              const SpaceVH(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const LoginStudentScreen()));
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Вы студент? ',
                      style: headline.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                    TextSpan(
                      text: ' Вернуться',
                      style: headlineDot.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
