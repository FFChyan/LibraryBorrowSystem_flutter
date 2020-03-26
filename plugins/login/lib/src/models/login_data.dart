import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

class LoginData {
  final String stu_id;
  final String password;
  final String stuName;
  int overdue = 0;

  LoginData({
    @required this.stu_id,
    @required this.password,
    this.stuName,
    this.overdue,
  });

  @override
  String toString() {
    return '$runtimeType($stu_id, $password)';
  }

  bool operator ==(Object other) {
    if (other is LoginData) {
      return stu_id == other.stu_id && password == other.password;
    }
    return false;
  }

  int get hashCode => hash2(stu_id, password);
}
