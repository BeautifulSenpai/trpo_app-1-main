class Lecture {
  final int id; // Добавлено поле id
  final String title;
  final String description;
  final String difficulty;

  Lecture({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      difficulty: json['difficulty'],
    );
  }
}

