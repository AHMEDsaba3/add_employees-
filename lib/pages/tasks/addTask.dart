import 'dart:convert';

import 'package:flut_grouped_buttons/flut_grouped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:task10/models/Task.dart';
import 'package:task10/services/pref_services.dart';
import 'package:task10/widgets/Text_form_field_widget.dart';
import 'package:task10/widgets/page_template_widget.dart';

import '../../models/Task.dart';

class AddTask extends StatefulWidget {
  final Task? task;

  const AddTask({super.key, this.task});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late TextEditingController titleControler;
  late TextEditingController descControler;
  final formKey = GlobalKey<FormState>();
  int? priority;
  TaskStatus? taskStatus;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    if (widget.task != null) {
      titleControler = TextEditingController(text: widget.task!.titel);
      descControler = TextEditingController(text: widget.task!.desc.toString());
      priority = widget.task?.priority;
      taskStatus = widget.task?.taskStatus;
      setState(() {});
    } else {
      titleControler = TextEditingController();
      descControler = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplateWidget(
      body: bodyData,
      index: 3,
      AppBarTitle: widget.task != null ? 'Edit Task' : 'Add Task',
      ShowBackButton: true,
    );
  }

  int getPriyority(String value) {
    switch (value) {
      case 'Heigh':
        return 1;
      case 'Low':
        return 3;
      default:
        return 2;
    }
  }

  String getPriyorityString(int value) {
    switch (value) {
      case 1:
        return 'Heigh';
      case 3:
        return 'Low';
      default:
        return 'Meduim';
    }
  }

  Widget get bodyData => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'Task Info',
                        style: TextStyle(fontSize: 22),
                      ),
                      if (widget.task != null)
                        IconButton(
                          onPressed: () {
                            deleteTask();
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        )
                    ],
                  ),
                ),
                TextFormWidget(
                    Controller: titleControler,
                    label: 'Title',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'title is required';
                      }
                      return null;
                    }),
                TextFormWidget(
                  maxLine: 7,
                  minLine: 4,
                  Controller: descControler,
                  label: 'Describtion',
                  keyboardType: TextInputType.text,

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Priority",
                        style: TextStyle(fontSize: 18),
                      ),
                      SingleChildScrollView(
                        scrollDirection:Axis.horizontal ,
                        child: Row(
                          children: [
                            FlutGroupedButtons(
                              data: ['Heigh', 'Meduim', 'Low'],
                              selectedList:[getPriyorityString(priority ?? 2)
                              ]
                                    ,
                              isRadio: true,
                              isRow: true,
                              onChanged: (value) {
                                priority = getPriyority(value);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (widget.task != null) {
                        onEditTask();
                      } else {
                        onAddTask();
                      }
                    },
                    child: Text(widget.task != null ? 'Edit Task' : "Add Task"))
              ],
            ),
          ),
        ),
      );

  void onAddTask() async {
    try {
      if (formKey.currentState?.validate() ?? false) {
        var result = await prefServ.prefs?.setStringList('tasks', [
          ...(prefServ.prefs?.getStringList('tasks') ?? []),
          jsonEncode(assignTask().toJson())
        ]);
        if (result ?? false) {
          Alert(
                  buttons: [
                DialogButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
                  context: context,
                  type: AlertType.success,
                  title: 'Task Add success')
              .show()
              .then((value) => Navigator.pop(context, true));
        }
      }
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>>>Excetion${e}');
    }
  }

  Task assignTask() {
    var task = Task();
    task.id =
        widget.task?.id ?? "MMA${DateTime.now().microsecondsSinceEpoch}AA";
    task.titel = titleControler.text;
    task.desc = descControler.text;
    task.priority = priority;
    task.taskStatus = TaskStatus.inProgress;
   // task.createdDate = DateTime.now();

    return task;
  }

  Future<void> onEditTask() async {
     if (formKey.currentState?.validate() ?? false) {
      var NewTask=assignTask();
      if (widget.task == NewTask) {
        Alert(context: context, type: AlertType.error, title: "No Data Changed")
            .show();
        return;
      }
      //get list
      var TaskList = prefServ.prefs
          ?.getStringList('tasks')
          ?.map((e) => Task.fromJson(jsonDecode(e)))
          .toList();
      //delete old record
      TaskList?.removeWhere((e) =>e.id== widget.task?.id);
      //add new record
      TaskList?.add(NewTask);
      //save list
      var  result= await prefServ.prefs?.setStringList('tasks', TaskList?.map((e) => jsonEncode(e.toJson())).toList()??[]);
      if(result ?? false){
        Alert(
            buttons: [
              DialogButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            context: context,
            type: AlertType.success,
            title: 'Task Updated success')
            .show()
            .then((value) => Navigator.pop(context, true));
      }
    }
  }

  void deleteTask() {
     Alert(
        buttons: [
          DialogButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.pop(context);
            },
          ) ,
          DialogButton(
            child: Text('Yes'),
            onPressed: () async{
              //get list
              var TaskList = prefServ.prefs
                  ?.getStringList('tasks')
                  ?.map((e) => Task.fromJson(jsonDecode(e)))
                  .toList();
              //delete old record
              TaskList?.removeWhere((e) =>e.id== widget.task?.id);
              //save list
              var  result= await prefServ.prefs?.setStringList('tasks', TaskList?.map((e) => jsonEncode(e.toJson())).toList()??[]);
              Navigator.pop(context);
              //wait 200 milisecond
              await Future.delayed(Duration(milliseconds: 200));
              Navigator.pop(context,true);

            },
          )
        ],
        context: context,
        type: AlertType.warning,
        title: 'you are sure to want delete this Task ? ')
        .show();
  }
}
