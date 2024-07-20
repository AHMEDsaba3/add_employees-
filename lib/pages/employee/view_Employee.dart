import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:task10/models/Employee.dart';
import 'package:task10/pages/employee/addEmployee.dart';
import 'package:task10/services/pref_services.dart';
import 'package:task10/widgets/page_template_widget.dart';

class ViewEmployee extends StatefulWidget {
  const ViewEmployee({super.key});

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  List<Employee>? employeeList;

  @override
  void initState() {
    init();
    //employeeList = prefServ.prefs.getStringList('employee');
    super.initState();
  }

  void init() {
    employeeList = prefServ.prefs
        ?.getStringList('employee')
        ?.map((e) => Employee.fromJson(jsonDecode(e)))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TemplateWidget(
        body: bodyData,
        index: 2,
        AppBarTitle: 'Employee',
        fab: FloatingActionButton(
          onPressed: () async {
            var result = await Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddEmpolyee()));
            if (result ?? false) {
              init();
            }
          },
          child: Icon(Icons.add),
        ));
  }

  Widget get bodyData => (employeeList?.isNotEmpty ?? false)
      ? Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 600,
                columns: [
                  DataColumn2(
                    label: Text('Id'),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text('Name'),
                  ),
                  DataColumn(
                    label: Text('MobileNo'),
                  ),
                  DataColumn(
                    label: Text('JoinDate'),
                  ),
                  DataColumn(
                    label: Text('Actions'),
                  ),
                ],
                rows: employeeList
                        ?.map((e)=> DataRow(cells: [
                              DataCell(Text(e.id.toString())),
                              DataCell(Text(e.name.toString())),
                              DataCell(Text(e.mobileNum.toString())),
                              DataCell(Text('${e.joinDate?.day}-${e.joinDate?.month}-${e.joinDate?.year}')),
                              DataCell(Row(
                                children: [
                                  IconButton(onPressed: () async {
                              var result = await Navigator.push(
                              context, MaterialPageRoute(builder: (_) => AddEmpolyee(employee: e,)));
                              if (result ?? false) {
                              init();
                              }
                              }, icon: Icon(Icons.edit))
                                ],
                              )),
                            ]))
                        .toList() ??
                    []),
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

  Widget rowInfo(
      String title, String value, Color titleColor, Color valueColor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: titleColor),
        ),
        const SizedBox(
          height: 15,
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: valueColor,
            ),
          ),
        )
      ],
    );
  }
}
