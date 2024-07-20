import 'dart:convert';

import 'package:flut_grouped_buttons/flut_grouped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:task10/models/Employee.dart';
import 'package:task10/services/pref_services.dart';
import 'package:task10/widgets/Text_form_field_widget.dart';
import 'package:task10/widgets/page_template_widget.dart';

class AddEmpolyee extends StatefulWidget {
  final Employee? employee;

  const AddEmpolyee({super.key, this.employee});

  @override
  State<AddEmpolyee> createState() => _AddEmpolyeeState();
}

class _AddEmpolyeeState extends State<AddEmpolyee> {
  late TextEditingController nameControler;
  late TextEditingController ageControler;
  late TextEditingController mobileControler;
  late TextEditingController salaryControler;
  final formKey = GlobalKey<FormState>();
  DateTime? joinTime;
  String? gender;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    if (widget.employee != null) {
      nameControler = TextEditingController(text: widget.employee!.name);
      ageControler =
          TextEditingController(text: widget.employee!.age.toString());
      mobileControler =
          TextEditingController(text: widget.employee!.mobileNum.toString());
      salaryControler =
          TextEditingController(text: widget.employee!.salary.toString());
      joinTime = widget.employee?.joinDate;
      gender = widget.employee?.gender;
      setState(() {});
    } else {
      nameControler = TextEditingController();
      ageControler = TextEditingController();
      mobileControler = TextEditingController();
      salaryControler = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplateWidget(
      body: bodyData,
      index: 2,
      AppBarTitle:widget.employee != null?'Edit Employee': 'Add Employee',
      ShowBackButton: true,
    );
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
                        'Employee Info',
                        style: TextStyle(fontSize: 22),
                      ),
                      if(widget.employee!=null)
                        IconButton(onPressed: () {
                          deleteEmployee();
                        }, icon: Icon(Icons.delete),color: Colors.red,)

                    ],
                  ),
                ),
                TextFormWidget(
                    Controller: nameControler,
                    label: 'Name',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'name is required';
                      }
                      return null;
                    }),
                TextFormWidget(
                  Controller: ageControler,
                  label: 'Age',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'age is required';
                    }
                    return null;
                  },
                ),
                TextFormWidget(
                  Controller: mobileControler,
                  label: 'Mobile Number',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Mobile Number is Required';
                    }
                    if (value.length < 11) {
                      return 'Mobile No must be 11 Number';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormWidget(
                    Controller: salaryControler,
                    label: 'Salary',
                    keyboardType: TextInputType.number),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      Text(
                        'Join Date',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                          onPressed: () async {
                            var result = await showDatePicker(
                                context: context,
                                initialDate: joinTime ?? DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2025));
                            if (result != null) {
                              joinTime = result;
                              setState(() {});
                            }
                          },
                          icon: Icon(Icons.calendar_month)),
                      if (joinTime != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                              '${joinTime?.year}-${joinTime?.month}-${joinTime?.day}'),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Gender",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: [
                          FlutGroupedButtons(
                            data: ['Male', 'Female'],
                            selectedList:
                                widget.employee == null ? null : [gender],
                            isRadio: true,
                            isRow: true,
                            onChanged: (value) {
                              gender = value.toString();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (widget.employee != null) {
                        onEditEmployee();
                      } else {
                        onAddEmployee();
                      }
                    },
                    child: Text(widget.employee != null
                        ? 'Edit Employee'
                        : "Add Employee"))
              ],
            ),
          ),
        ),
      );

  void onAddEmployee() async {
    try {
      if (formKey.currentState?.validate() ?? false) {
        var result = await prefServ.prefs?.setStringList('employee', [
          ...(prefServ.prefs?.getStringList('employee') ?? []),
          jsonEncode(assignEmployee().toJson())
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
                  title: 'Employee Add success')
              .show()
              .then((value) => Navigator.pop(context, true));
        }
      }
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>>>>Excetion${e}');
    }
  }

  Employee assignEmployee() {
    var employee = Employee();
    employee.id =
        widget.employee?.id ?? "MMA${DateTime.now().microsecondsSinceEpoch}AA";
    employee.name = nameControler.text;
    employee.age = int.tryParse(ageControler.text);
    employee.mobileNum = mobileControler.text;
    employee.salary = double.tryParse(salaryControler.text);
    employee.joinDate = joinTime;
    employee.gender = gender;
    return employee;
  }

  Future<void> onEditEmployee() async {
    if (formKey.currentState?.validate() ?? false) {
      var NewEmp=assignEmployee();
      if (widget.employee == NewEmp) {
        Alert(context: context, type: AlertType.error, title: "No Data Changed")
            .show();
        return;
      }
      //get list
      var employeeList = prefServ.prefs
          ?.getStringList('employee')
          ?.map((e) => Employee.fromJson(jsonDecode(e)))
          .toList();
      //delete old record
      employeeList?.removeWhere((e) =>e.id== widget.employee?.id);
      //add new record
      employeeList?.add(NewEmp);
      //save list
     var  result= await prefServ.prefs?.setStringList('employee', employeeList?.map((e) => jsonEncode(e.toJson())).toList()??[]);
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
           title: 'Employee Updated success')
           .show()
           .then((value) => Navigator.pop(context, true));
     }
    }
  }
void deleteEmployee() {
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
            var employeeList = prefServ.prefs
                ?.getStringList('employee')
                ?.map((e) => Employee.fromJson(jsonDecode(e)))
                .toList();
            //delete old record
            employeeList?.removeWhere((e) =>e.id== widget.employee?.id);
            //save list
            var  result= await prefServ.prefs?.setStringList('employee', employeeList?.map((e) => jsonEncode(e.toJson())).toList()??[]);
            Navigator.pop(context);
            //wait 200 milisecond
            await Future.delayed(Duration(milliseconds: 200));
            Navigator.pop(context,true);

          },
        )
      ],
      context: context,
      type: AlertType.warning,
      title: 'you are sure to want delete this employee ? ')
      .show();
}
}

