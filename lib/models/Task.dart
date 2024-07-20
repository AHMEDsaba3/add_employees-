import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';

enum TaskStatus { inProgress, done }

class Task with EquatableMixin {
  String? id;
  String? titel;
  int? priority;
  String? desc;
  TaskStatus? taskStatus;
  DateTime? createdDate;

  Task();

  Task.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    titel = data['titel'];
    priority = data['priority'];
    desc = data['desc'];
    taskStatus = EnumToString.fromString(TaskStatus.values, data['taskStatus']);
    createdDate = data['createdDate'].runtimeType == int
        ? DateTime.fromMillisecondsSinceEpoch(data['createdDate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titel': titel,
      'priority': priority,
      'desc': desc,
      "taskStatus": EnumToString.convertToString(taskStatus),
      'joinDate': createdDate?.millisecondsSinceEpoch,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        titel,
        priority,
        desc,
        EnumToString.convertToString(taskStatus),
        createdDate
      ];
}
