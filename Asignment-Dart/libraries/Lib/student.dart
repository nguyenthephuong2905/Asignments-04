class Student {
  String id;
  String name;
  Map<String, double> subjects;

  Student({required this.id, required this.name, required this.subjects});

  // Chuyển đối tượng Student thành dạng JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects,
    };
  }

  // Tạo đối tượng Student từ dữ liệu JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      subjects: Map<String, double>.from(json['subjects']),
    );
  }
}