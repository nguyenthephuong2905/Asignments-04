import 'dart:convert';
import 'dart:io';
import 'student.dart';

class StudentManager {
  List<Student> students = [];

  // Đọc dữ liệu từ file JSON
  Future<void> loadStudents() async {
    final file = File('data/Student.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(content);
      students = jsonData.map((json) => Student.fromJson(json)).toList();
    }
  }

  // Lưu dữ liệu vào file JSON
  Future<void> saveStudents() async {
    final file = File('data/Student.json');
    final jsonData = jsonEncode(students.map((s) => s.toJson()).toList());
    await file.writeAsString(jsonData);
  }

  // Hiển thị toàn bộ sinh viên
  void displayAllStudents() {
    if (students.isEmpty) {
      print('Không có sinh viên nào trong danh sách.');
    } else {
      for (var student in students) {
        print('ID: ${student.id}, Tên: ${student.name}');
        print('Môn học và điểm thi:');
        student.subjects.forEach((subject, score) {
          print('  - $subject: $score');
        });
      }
    }
  }

  // Thêm sinh viên
  void addStudent(Student student) {
    students.add(student);
    saveStudents();
    print('Đã thêm sinh viên.');
  }

  // Sửa thông tin sinh viên
  void editStudent(String id) {
    final student = students.firstWhere((s) => s.id == id, orElse: () => throw Exception('Không tìm thấy sinh viên.'));

    print('Sửa tên (bỏ qua nếu không muốn thay đổi):');
    final newName = stdin.readLineSync();
    if (newName != null && newName.isNotEmpty) {
      student.name = newName;
    }

    print('Sửa môn học và điểm thi (nhập "done" để dừng):');
    while (true) {
      print('Nhập tên môn học (hoặc "done" để hoàn tất):');
      final subject = stdin.readLineSync();
      if (subject == 'done') break;
      print('Nhập điểm:');
      final score = double.parse(stdin.readLineSync()!);
      student.subjects[subject!] = score;
    }

    saveStudents();
    print('Đã sửa thông tin sinh viên.');
  }

  // Tìm kiếm sinh viên theo tên hoặc ID
  void searchStudent(String query) {
    final results = students.where((s) => s.name.contains(query) || s.id == query).toList();
    if (results.isEmpty) {
      print('Không tìm thấy sinh viên.');
    } else {
      for (var student in results) {
        print('ID: ${student.id}, Tên: ${student.name}');
      }
    }
  }

  // Hiển thị sinh viên có điểm môn thi cao nhất
  void displayTopStudentsBySubject(String subject) {
    final filteredStudents = students.where((s) => s.subjects.containsKey(subject)).toList();
    if (filteredStudents.isEmpty) {
      print('Không có sinh viên nào học môn $subject.');
      return;
    }

    double maxScore = filteredStudents.map((s) => s.subjects[subject]!).reduce((a, b) => a > b ? a : b);
    final topStudents = filteredStudents.where((s) => s.subjects[subject] == maxScore).toList();

    print('Sinh viên có điểm môn $subject cao nhất ($maxScore):');
    for (var student in topStudents) {
      print('ID: ${student.id}, Tên: ${student.name}');
    }
  }
}
