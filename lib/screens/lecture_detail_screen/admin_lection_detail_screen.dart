import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../lecture_screen/admin_lecture_screen.dart';

class AdminLectureDetailScreen extends StatelessWidget {
  final dynamic lecture;

  const AdminLectureDetailScreen({Key? key, required this.lecture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final String descriptionString = lecture['description'];
     final List<dynamic> descriptionList = jsonDecode(descriptionString);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          material.MaterialPageRoute(builder: (BuildContext context) => const AdminLectureScreen()),
        );
        return false;
      },
      child: material.Scaffold(
        backgroundColor: const Color.fromRGBO(50, 53, 56, 1),
        appBar: material.AppBar(
          backgroundColor: const Color.fromRGBO(55, 61, 65, 1),
          title: const material.Text('Детали лекции'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              material.Text(
                lecture['title'],
                style: const TextStyle(
                  color: Color.fromRGBO(236, 126, 74, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return QuillEditor(
                      controller: QuillController(
                        document: Document.fromJson(descriptionList),
                        selection: const TextSelection.collapsed(offset: 0),
                      ),
                      readOnly: true,
                      scrollable: true,
                      autoFocus: false,
                      expands: true,
                      focusNode: FocusNode(),
                      padding: const EdgeInsets.all(16.0),
                      scrollController: ScrollController(),
                      maxHeight: constraints.maxHeight -
                        material.kToolbarHeight -
                        48.0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
