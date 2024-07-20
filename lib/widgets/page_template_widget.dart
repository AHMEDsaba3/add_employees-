import 'package:flutter/material.dart';
import 'package:task10/main.dart';
import 'package:task10/pages/tasks/viewTask.dart';

import '../pages/employee/view_Employee.dart';

class TemplateWidget extends StatefulWidget {
  TemplateWidget({super.key, required this.body, required this.index, this.AppBarTitle, this.fab,this.ShowBackButton=false});

  final Widget body;
  final int index;
  final String? AppBarTitle;
  final Widget? fab;
  final bool ShowBackButton ;

  @override
  State<TemplateWidget> createState() => _TemplateWidgetState();
}

class _TemplateWidgetState extends State<TemplateWidget> {
  var scafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scafoldKey,
        drawer: drawerData,
        floatingActionButton: widget.fab,
        body: MediaQuery.of(context).size.width > 800
            ? Column(
                children: [
                  customAppBar(context),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        drawerData,
                        Expanded(
                            flex: 5,
                            child: Container(
                                height: double.maxFinite,
                                color: Colors.transparent,
                                child: widget.body))
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: Colors.white,
                child: Column(
                  children: [
                    customAppBar(context),
                    Expanded(child: widget.body)
                  ],
                ),
              ));
  }

  Color get selectedWidgetColor => Colors.white;

  Color get selectedBackgroundColor => Colors.deepPurple;

  Widget get drawerData => Container(
      height: double.maxFinite,
      width: 250,
      decoration: BoxDecoration(color: Colors.grey.shade50, boxShadow: [
        BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 5,
            color: Colors.grey,
            spreadRadius: 3)
      ]),
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: widget.index == 1 ? selectedBackgroundColor : null,
                child: ListTile(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => MyHomePage()));
                  },
                  leading: Icon(
                    Icons.home,
                    color: widget.index == 1 ? selectedWidgetColor : null,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                        color: widget.index == 1 ? selectedWidgetColor : null),
                  ),
                ),
              ),
              Container(
                  color: widget.index ==2 ? selectedBackgroundColor : null,
                child: ListTile(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => ViewEmployee()));
                  },
                  leading: Icon(Icons.person,color: widget.index ==2 ? selectedWidgetColor : null),
                  title: Text('Employee',style: TextStyle(color: widget.index ==2 ? selectedWidgetColor : null),),
                ),
              ),
              Container(
                  color: widget.index ==3 ? selectedBackgroundColor : null,
                child: ListTile(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewTask(),));
                  },
                  leading: Icon(Icons.task_alt,color: widget.index ==3 ? selectedWidgetColor : null),
                  title: Text('Tasks',style: TextStyle(color: widget.index ==3 ? selectedWidgetColor : null),),
                ),
              ),
              Container(
                  color: widget.index ==4 ? selectedBackgroundColor : null,
                child: ListTile(
                  leading: Icon(Icons.production_quantity_limits,color: widget.index ==4 ? selectedWidgetColor : null),
                  title: Text('Products',style: TextStyle(color: widget.index ==4 ? selectedWidgetColor : null),),
                ),
              ),
            ],
          ),
        ),
      ));

  Widget customAppBar(context) => Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade50, boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 5,
              color: Colors.grey,
              spreadRadius: 3)
        ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width < 800)
                IconButton(
                    onPressed: () {
                      scafoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(Icons.menu)),
               Expanded(
                child: Text(
                 widget.AppBarTitle ?? "Admin Panel",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              if(widget.ShowBackButton)
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_sharp),
              )
            ],
          ),
        ),
      );
}
