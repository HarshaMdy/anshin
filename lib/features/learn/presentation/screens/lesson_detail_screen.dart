import 'package:flutter/material.dart';

class LessonDetailScreen extends StatelessWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Lesson: $lessonId')),
    );
  }
}
