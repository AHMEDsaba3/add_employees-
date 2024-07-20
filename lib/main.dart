import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task10/pages/employee/view_Employee.dart';
import 'package:task10/services/pref_services.dart';
import 'package:task10/widgets/page_template_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await prefServ.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _homepageState();
}

class _homepageState extends State<MyHomePage> {
  var scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return TemplateWidget(body: bodyData, index: 1, AppBarTitle: 'Home',);
  }



  Widget get bodyData =>  SingleChildScrollView(
    child: Column(
      children: [
        ... List.generate(10, (index) =>   Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey.shade100,
            child: const ListTile(
              leading: CircleAvatar(
                radius: 25,
              ),
              title: Text('Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing'),
              subtitle: Text('Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing'),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),
        ))

      ],
    ),
  );


}