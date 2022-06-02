import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/pages/home/home_page.dart';

import 'package:uber_clone_flutter/src/pages/login/login_page.dart';
import 'package:uber_clone_flutter/src/pages/scanner/scanner_page.dart';
import 'package:uber_clone_flutter/src/pages/splashscreen/splash_screen_page.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';






void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'splashScreen':(BuildContext context) => SplashScreenPage(),
        'login':(BuildContext context) => LoginPage(),
        'home':(BuildContext context) => HomePage(),
        'scanner':(BuildContext context) => ScannerPage(),
      },
      theme: ThemeData(
          primaryColor: MyColors.primaryColor
      ),
    );
  }
}
