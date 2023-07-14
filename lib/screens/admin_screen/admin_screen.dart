// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trpo_app/screens/api_data/api_data.dart';
import 'package:trpo_app/screens/request/request.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Request> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      final url = Uri.parse(ApiData.adminRequests);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Request> fetchedRequests =
            responseData.map((data) => Request.fromJson(data)).toList();
        setState(() {
          requests = fetchedRequests;
        });
      } else {
        throw Exception('Failed to fetch requests');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> approveRequest(int requestId) async {
    try {
      final url = Uri.parse(ApiData.approveRequest(requestId));
      final response = await http.post(url);

      if (response.statusCode == 200) {
        fetchRequests(); // Fetch updated requests
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Уведомление'),
            content: const Text('Запрос одобрен'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to approve request');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> rejectRequest(int requestId) async {
    try {
      final url = Uri.parse(ApiData.rejectRequest(requestId));
      final response = await http.post(url);

      if (response.statusCode == 200) {
        fetchRequests(); // Fetch updated requests
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Уведомление'),
            content: const Text('Запрос отклонен'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to reject request');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 53, 56, 1),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return ListTile(
            title: Text(
              'ID Студента: ${request.studentId}',
              style: const TextStyle(
                color: Color.fromRGBO(
                    236, 126, 74, 1), // Измените цвет текста заголовка
                fontSize: 16, // Измените размер текста заголовка
                fontWeight:
                    FontWeight.bold, // Измените начертание текста заголовка
              ),
            ),
            subtitle: Text(
              'ID Учителя: ${request.teacherId}',
              style: const TextStyle(
                color: Colors.white54, // Измените цвет текста подзаголовка
                fontSize: 14, // Измените размер текста подзаголовка
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.transparent, // Цвет фона
                    shape: CircleBorder(),
                  ),
                  child: InkWell(
                    onTap: () => approveRequest(request.id),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check,
                        color: Colors
                            .green, // Измените цвет иконки кнопки одобрения
                      ),
                    ),
                  ),
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.transparent, // Цвет фона
                    shape: CircleBorder(),
                  ),
                  child: InkWell(
                    onTap: () => rejectRequest(request.id),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Colors
                            .red, // Измените цвет иконки кнопки отклонения
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
