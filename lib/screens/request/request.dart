class Request {
  final int id;
  final int studentId;
  final int teacherId;

  Request({required this.id, required this.studentId, required this.teacherId});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      studentId: json['studentId'],
      teacherId: json['teacherId'],
    );
  }
}
