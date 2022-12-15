import 'package:flutter/material.dart';
import 'package:untitled27/home_screen.dart';
import 'package:untitled27/preferences_helper.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await preferencesHelper.instance.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}



