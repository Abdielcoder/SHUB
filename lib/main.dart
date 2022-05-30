import 'package:flutter/material.dart';

import 'package:uber_clone_flutter/src/pages/login/login_page.dart';
import 'package:uber_clone_flutter/src/pages/splashscreen/splash_screen_page.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      title:'Voitu',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'splashScreen':(BuildContext context) => SplashScreenPage(),
        'login':(BuildContext context) => LoginPage(),
      },
      theme: ThemeData(
          primaryColor: MyColors.primaryColor
      ),
    );
  }
}
