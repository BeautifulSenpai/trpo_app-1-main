class ApiData {
  static const String requestUrl = 'http://localhost:5000/request';
  static const String loginUrl = 'http://localhost:5000/login';
  static const String adminRequests = 'http://localhost:5000/admin/requests';
  static const String lectureScreen = 'http://localhost:5000/lectures';
  static const String addLecture = 'http://localhost:5000/addLecture';
  static String approveRequest(int requestId) =>
      'http://localhost:5000/admin/requests/$requestId/approve';
  static String rejectRequest(int requestId) =>
      'http://localhost:5000/admin/requests/$requestId/reject';
  static String editLecture(int lectureId) =>
      'http://localhost:5000/lectures/$lectureId';
  static String deleteLecture(int lectureId) =>
      'http://localhost:5000/lectures/$lectureId';
}
