import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trpo_app/screens/api_data/api_data.dart';
import 'dart:convert';

import '../admin_screen/admin_screen.dart';
import '../lecture_detail_screen/admin_lection_detail_screen.dart';
import '../signup_screen/signup_teacher_screen.dart';
import 'add_lecture_screen.dart';
import 'edit_lecture_screen.dart';

class AdminLectureScreen extends StatefulWidget {
  const AdminLectureScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminLectureScreenState createState() => _AdminLectureScreenState();
}

class _AdminLectureScreenState extends State<AdminLectureScreen> {
  late Color itemTextColor;

  List<dynamic> lectures = [];
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchLectures();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  Future<void> fetchLectures() async {
    try {
      final response = await http.get(Uri.parse(ApiData.lectureScreen));
      if (response.statusCode == 200) {
        setState(() {
          lectures = jsonDecode(response.body);
        });
      } else {
        // ignore: avoid_print
        print('Ошибка при получении лекций');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Ошибка при отправке запроса');
    }
  }

  Future<void> addLecture(
      String title, String description, String difficulty) async {
    try {
      final response = await http.post(
        Uri.parse(ApiData.lectureScreen),
        body: jsonEncode({
          'title': title,
          'description': description,
          'difficulty': difficulty
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final newLecture = jsonDecode(response.body);
        setState(() {
          lectures.add(newLecture);
        });
      } else {
        showErrorMessage('Ошибка при добавлении лекции');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Ошибка при отправке запроса');
    }
  }

  Future<void> deleteLecture(int lectureId) async {
  try {
    final url = ApiData.deleteLecture(lectureId);
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        lectures.removeWhere((lecture) => lecture['id'] == lectureId);
      });
    } else if (response.statusCode == 404) {
      showErrorMessage('Лекция не найдена');
    } else {
      showErrorMessage('Ошибка при удалении лекции');
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

  void openLectureDetail(dynamic lecture) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminLectureDetailScreen(lecture: lecture),
      ),
    );
  }

 void openEditLecturePage(dynamic lecture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLectureScreen(lecture: lecture),
      ),
    ).then((value) {
      if (value == true) {
        fetchLectures();
      }
    });
  }

  void _goToSignUpTeacherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpTeacherScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 53, 56, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 61, 65, 1),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentPageIndex == 0 ? const Text('Лекции') : const Text('Запросы'),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
            ),
            onPressed: _goToSignUpTeacherScreen,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemCount: lectures.length,
              itemBuilder: (context, index) {
                final lecture = lectures[index];
                return Card(
                  color: const Color.fromRGBO(55, 61, 65, 1),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/lecture.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      lecture['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(236, 126, 74, 1),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          _buildDifficultyIndicator(lecture['difficulty'] ?? ''),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            openEditLecturePage(lecture);
                          },
                        ),
                        IconButton(
  icon: const Icon(
    Icons.delete,
    color: Colors.grey,
  ),
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(55, 61, 65, 1),
          title: const Text(
            'Подтверждение удаления',
            style: TextStyle(
              color: Color.fromRGBO(236, 126, 74, 1),
            ),
          ),
          content: Text(
            'Вы уверены, что хотите удалить лекцию "${lecture['title']}"?',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Отмена',
                style: TextStyle(
                  color: Color.fromRGBO(236, 126, 74, 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Удалить',
                style: TextStyle(
                  color: Color.fromRGBO(236, 126, 74, 1),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteLecture(lecture['id']);
              },
            ),
          ],
        );
      },
    );
  },
),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromRGBO(236, 126, 74, 1),
                          ),
                          onPressed: () {
                            openLectureDetail(lecture);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const AdminScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(55, 61, 65, 1),
        currentIndex: _currentPageIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        selectedItemColor: const Color.fromRGBO(236, 126, 74, 1),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          color: Colors.white,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.white,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
            ),
            label: 'Лекции',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article,
            ),
            label: 'Запросы',
          ),
        ],
      ),
      floatingActionButton: _currentPageIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color.fromRGBO(55, 61, 65, 1),
              child: const Icon(
                Icons.add,
                color: Color.fromRGBO(236, 126, 74, 1),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddLectureScreen(),
                  ),
                ).then((value) {
                  if (value == true) {
                    fetchLectures();
                  }
                });
              },
            )
          : null,
    );
  }
}

Widget _buildDifficultyIndicator(String difficulty) {
  Color indicatorColor;
  String difficultyText;

  switch (difficulty) {
    case 'Начинающий':
      indicatorColor = Colors.green;
      difficultyText = 'Начинающий';
      break;
    case 'Средний':
      indicatorColor = Colors.yellow;
      difficultyText = 'Средний';
      break;
    case 'Продвинутый':
      indicatorColor = Colors.red;
      difficultyText = 'Продвинутый';
      break;
    default:
      indicatorColor = Colors.transparent;
      difficultyText = '';
  }

  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: indicatorColor,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        difficultyText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );
}
