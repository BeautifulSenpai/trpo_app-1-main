import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:trpo_app/screens/api_data/api_data.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

class EditLectureScreen extends StatefulWidget {
  final dynamic lecture;

  const EditLectureScreen({Key? key, required this.lecture}) : super(key: key);

  @override
  _EditLectureScreenState createState() => _EditLectureScreenState();
}

class _EditLectureScreenState extends State<EditLectureScreen> {
  late TextEditingController _titleController;
  late QuillController _descriptionController;
  late String _selectedDifficulty = 'Начинающий';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.lecture['title']);
    _descriptionController = QuillController(
       document: Document.fromJson(jsonDecode(widget.lecture['description'])),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _selectedDifficulty = widget.lecture['difficulty'];
  }

  Future<void> updateLecture(int id, String title, Document description, String difficulty) async {
    final apiUrl = ApiData.editLecture(id);

    // Create the request body
    final requestBody = {
      'title': title,
      'description': jsonEncode(description.toDelta().toJson()),
      'difficulty': difficulty,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Lecture successfully updated
        Navigator.pop(context, true); // Return to the previous screen
      } else {
        showErrorMessage('Error updating the lecture');
      }
    } catch (e) {
      // Handle request sending errors
      print('Error sending the request: $e');
    }
  }

  void showErrorMessage(String message) {
    material.showDialog(
      context: context,
      builder: (context) {
        return material.AlertDialog(
          title: const material.Text('Error'),
          content: material.Text(message),
          actions: [
            material.ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const material.Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        title: const material.Text('Редактировать лекцию'),
        actions: [
          material.IconButton(
            onPressed: () {
              final title = _titleController.text;
              final description = _descriptionController.document;
              updateLecture(widget.lecture['id'], title, description, _selectedDifficulty);
            },
            icon: const Icon(material.Icons.check),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          material.TextField(
            controller: _titleController,
            decoration: const material.InputDecoration(
              labelText: 'Название лекции',
            ),
          ),
          const SizedBox(height: 16.0),
          material.DropdownButtonFormField<String>(
            value: _selectedDifficulty,
            onChanged: (value) {
              setState(() {
                _selectedDifficulty = value!;
              });
            },
            items: <String>['Начинающий', 'Средний', 'Продвинутый']
                .map<material.DropdownMenuItem<String>>((String value) {
              return material.DropdownMenuItem<String>(
                value: value,
                child: material.Text(value),
              );
            }).toList(),
            decoration: const material.InputDecoration(
              labelText: 'Уровень сложности',
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QuillEditor(
                    controller: _descriptionController,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: FocusNode(),
                    autoFocus: true,
                    readOnly: false,
                    placeholder: 'Введите описание лекции...',
                    expands: true,
                    padding: const EdgeInsets.all(16.0),
                    maxHeight: constraints.maxHeight -
                        material.kToolbarHeight -
                        48.0, // Adjust the maxHeight
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: material.BottomAppBar(
        child: QuillToolbar.basic(
          controller: _descriptionController,
          showCodeBlock: false,
          showListCheck: true,
        ),
      ),
    );
  }
}
