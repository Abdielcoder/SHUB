import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class MyProgressDialog {
  static void show(BuildContext context, String text, bool state)async {
    if (context == null)
      return;
    final ProgressDialog pr = ProgressDialog(context: context);
    if(state==true){
      await pr.show(max: 100,msg: text);
    }else{
      pr.close();
    }

  }

}