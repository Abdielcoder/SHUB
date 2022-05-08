import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/models/car.dart';

import '../models/user.dart';
import '../provider/car_provider.dart';

class MyDialog {
  static void show(BuildContext context, String title, String desc, String ruta) {
    if (context == null) return;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      btnOkOnPress: () {
        Navigator.pushNamedAndRemoveUntil(context, ruta, (route) => false);
      },
    )..show();
  }

  static void info(BuildContext context, String title, String desc, String ruta,String  id) {
    CarProvider _carProvider = new CarProvider();
    if (context == null) return;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO_REVERSED,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      btnCancelOnPress: () {},
      btnOkOnPress: () async{

        //CALL API TO ELIMINATE CAR
        await _carProvider.deleteCar(id);
        Navigator.pushNamedAndRemoveUntil(context, ruta, (route) => false);
      },
    )..show();
  }

  }