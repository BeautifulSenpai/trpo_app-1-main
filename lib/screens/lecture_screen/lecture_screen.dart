import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trpo_app/screens/api_data/api_data.dart';
import 'dart:convert';
import 'package:trpo_app/screens/lecture_detail_screen/lecture_detail_screen.dart';

class LectureScreen extends StatefulWidget {
  const LectureScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LectureScreenState createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  List<dynamic> lectures = [];

  @override
  void initState() {
    super.initState();
    fetchLectures();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 53, 56, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 61, 65, 1),
        title: const Text('Лекции'),
      ),
      body: Padding(
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromRGBO(236, 126, 74, 1),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LectureDetailScreen(lecture: lecture),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
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
