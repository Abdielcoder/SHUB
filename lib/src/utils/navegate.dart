import 'package:flutter/cupertino.dart';

class Navegate{
  static void goToWelcome(BuildContext context){
      Navigator.popAndPushNamed(context, "login");
  }
}