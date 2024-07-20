import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Employee with EquatableMixin {
  String? id;
  String? name;
  int? age;
  String? mobileNum;
  double? salary;
  DateTime? joinDate;
  String? gender;

  Employee();


  Employee.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    age = data['age'];
    mobileNum = data['mobileNo'];
    salary = data['salary'];
    joinDate = data['joinDate'].runtimeType == int
        ? DateTime.fromMillisecondsSinceEpoch(data['joinDate'])
        : null;
    gender = data['gender'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'mobileNo': mobileNum,
      'salary': salary,
      'joinDate': joinDate?.millisecondsSinceEpoch,
      'gender': gender,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,name,age,mobileNum,salary,joinDate,gender];

}
