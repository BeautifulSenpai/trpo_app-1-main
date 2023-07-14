import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trpo_app/screens/api_data/api_data.dart';
import 'dart:convert';
import 'package:trpo_app/screens/components/button_global.dart';
import 'package:trpo_app/screens/components/space.dart';
import 'package:trpo_app/screens/components/text_style.dart';
import 'package:trpo_app/screens/components/text_form_global.dart';
import 'package:trpo_app/screens/lecture_screen/lecture_screen.dart';
import 'package:trpo_app/screens/signup_screen/signup_teacher_screen.dart';

class LoginStudentScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginStudentScreen({super.key, this.onTap});

  @override
  State<LoginStudentScreen> createState() => _LoginStudentScreenState();
}

class _LoginStudentScreenState extends State<LoginStudentScreen> {
  final TextEditingController bookNumberController = TextEditingController();

  void signUserIn() async {
    final String studentId = bookNumberController.text;

    if (studentId.isEmpty) {
      showErrorMessage('Введите номер зачетки');
      return;
    }

    try {
      const String apiUrl = ApiData.requestUrl;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'studentId': studentId,
        }),
      );

      final responseData = jsonDecode(response.body);
      final String message = responseData['message'];

      if (response.statusCode == 200 &&
          message == 'Студент одобрен, можно войти') {
        // Переход на новую страницу, например:
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LectureScreen()),
        );
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      showErrorMessage('Ошибка при отправке запроса');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 53, 56, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SpaceVH(height: 10.0),
              Image.asset(
                'assets/images/splash.png',
                scale: 3,
              ),
              const SpaceVH(height: 10.0),
              const Text(
                'Пожалуйста, введите номер зачётной книжки',
                style: headline3,
              ),
              const SpaceVH(height: 30.0),
              TextFormGlobal(
                controller: bookNumberController,
                text: 'Номер зачётной книжки',
                obscure: false,
                textInputType: TextInputType.multiline,
              ),
              const SpaceVH(height: 10.0),
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                ),
              ),
              const SpaceVH(height: 50.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    ButtonGlobal(
                      text: "Отправить запрос/Войти",
                      onTap: signUserIn,
                    ),
                    const SpaceVH(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    const SignUpTeacherScreen()));
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Вы преподователь?',
                            style: headline.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ' Войти',
                            style: headlineDot.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
