import 'dart:io';
import '../lib/student_manager.dart';
import '../lib/student.dart';

void main() async {
  final manager = StudentManager();
  await manager.loadStudents();

  while (true) {
    print('--- Chương trình quản lý sinh viên ---');
    print('1. Hiển thị toàn bộ sinh viên');
    print('2. Thêm sinh viên');
    print('3. Sửa thông tin sinh viên');
    print('4. Tìm kiếm sinh viên theo Tên hoặc ID');
    print('5. Hiển thị sinh viên có điểm môn thi cao nhất');
    print('6. Thoát');
    print('Chọn chức năng:');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        manager.displayAllStudents();
        break;
      case '2':
        print('Nhập ID:');
        final id = stdin.readLineSync()!;
        print('Nhập tên:');
        final name = stdin.readLineSync()!;
        print('Nhập môn học và điểm :');
        final subjects = <String, double>{};

        for (int i = 0; i < 3; i++) {
          print('Nhập tên môn học (${i + 1}/3):');
          final subject = stdin.readLineSync();
          if (subject == null || subject.isEmpty) {
            print('Tên môn học không được để trống, vui lòng nhập lại.');
            i--; // Lùi lại 1 bước nếu người dùng nhập sai
            continue;
          }
          print('Nhập điểm cho môn $subject:');
          final score = double.tryParse(stdin.readLineSync()!);
          if (score == null) {
            print('Điểm phải là một số, vui lòng nhập lại.');
            i--; // Lùi lại 1 bước nếu người dùng nhập sai
            continue;
          }
          subjects[subject] = score;
        }

        // Xử lý sau khi đã nhập xong 3 môn học và điểm
        print('Thông tin sinh viên ID: $id, Tên: $name');
        print('Môn học và điểm:');
        subjects.forEach((subject, score) {
          print('$subject: $score');
        });

        manager.addStudent(Student(id: id, name: name, subjects: subjects));
        break;
      case '3':
        print('Nhập ID sinh viên cần sửa:');
        final id = stdin.readLineSync()!;
        manager.editStudent(id);
        break;
      case '4':
        print('Nhập tên hoặc ID sinh viên cần tìm:');
        final query = stdin.readLineSync()!;
        manager.searchStudent(query);
        break;
      case '5':
        print('Nhập tên môn thi:');
        final subject = stdin.readLineSync()!;
        manager.displayTopStudentsBySubject(subject);
        break;
      case '6':
        print('Thoát chương trình.');
        return;
      default:
        print('Lựa chọn không hợp lệ.');
    }
  }
}