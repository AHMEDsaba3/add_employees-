import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:task10/models/Employee.dart';
import 'package:task10/models/Task.dart';
import 'package:task10/pages/employee/addEmployee.dart';
import 'package:task10/services/pref_services.dart';
import 'package:task10/widgets/page_template_widget.dart';

import 'addTask.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({super.key});

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  List<Task>? taskList;

  @override
  void initState() {
    init();
    //employeeList = prefServ.prefs.getStringList('employee');
    super.initState();
  }

  void init() {
    taskList = prefServ.prefs
        ?.getStringList('tasks')
        ?.map((e) => Task.fromJson(jsonDecode(e)))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TemplateWidget(
        body: bodyData,
        index: 3,
        AppBarTitle: 'Tasks',
        fab: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddTask()));
            if (result ?? false) {
              init();
            }
          },
          child: Icon(Icons.add),
        ));
  }

  Widget get bodyData => (taskList?.isNotEmpty ?? false)
      ? Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...taskList?.map((e) =>Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey.shade100,
                  child:  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      child: Text(e.titel![0].toUpperCase()),
                    ),
                    title: Text(e.titel ??'no title'),
                    subtitle: Text(e.desc ?? ''),
                    trailing: IconButton(onPressed: () async {
                      var result = await Navigator.push(
                          context, MaterialPageRoute(builder: (_) => AddTask(task: e,)));
                      if (result ?? false) {
                        init();
                      }
                    }, icon: Icon(Icons.edit)),
                  ),
                ),
              ) ).toList() ?? []

            ],
          ),
        )
      )

    /*      ListView(
            children: employeeList
                    ?.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.all(0),
                            title: Row(
                              children: [
                                Text('Name: ${e.name ?? 'No Name'}',style:
                                  TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w500
                                ),),
                                IconButton(onPressed: () async {
                                  var result = await Navigator.push(
                                      context, MaterialPageRoute(builder: (_) => AddEmpolyee(employee: e,)));
                                  if (result ?? false) {
                                    init();
                                  }
                                }, icon: Icon(Icons.edit))
                              ],
                            ),
                            children: [
                              rowInfo("age ", e.age.toString(), Colors.black,
                                  Colors.grey),
                              rowInfo("Mobile Number ", e.mobileNum.toString(),
                                  Colors.black, Colors.grey),
                              rowInfo("Salary ", e.salary.toString(), Colors.black,
                                  Colors.grey),
                              rowInfo("Gender ", e.gender.toString(), Colors.black,
                                  Colors.grey),
                              rowInfo("join Date ", '${e.joinDate?.year}-${e.joinDate?.month}-${e.joinDate?.day}',
                                  Colors.black, Colors.green),
                            ],
                          ),
                    ))
                    .toList() ??
                [],
          ),
  */
  )
      : Center(
    child: Text('no data found'),
  );

}
