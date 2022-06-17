import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:uber_clone_flutter/src/models/user.dart';
import 'package:uber_clone_flutter/src/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
class LoginController {

  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  ProgressDialog _progressDialog;

  Future init(BuildContext context) async {
    this.context = context;
    _progressDialog = new ProgressDialog(context: context);
  }


  void login() async {
   _progressDialog.show(max: 10, msg: "Starting");
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    getRequest(email,password);

    }

  Future<List<User>> getRequest(String email, String password) async {
    var url = 'http://3.217.149.82/batchjobx/ws/validar_usuario.php?usuario=$email&password=$password';
    print(url);
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var username = jsonResponse['username'];
      var UsersID = jsonResponse['UsersID'];
      var profile = jsonResponse['profile'];
      var clientID = jsonResponse['clientID'];
      print('Response ### http: $jsonResponse.');
      print('URL ### http: $clientID.');
      if(UsersID == 'USER ERROR'){
        _progressDialog.close();
        print('Error de inicio de session');
        _customButtonEasyDialog();
      }else{
        _progressDialog.close();
        Navigator.pushNamed(
          context,
          'home',
          arguments: {'username':username,'UsersID':UsersID,'profile':profile,'clientID':clientID},
        );
      }

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _customButtonEasyDialog() {
    EasyDialog(
        closeButton: false,
        cornerRadius: 10.0,
        fogOpacity: 0.7,
        width: 280,
        height: 220,
        // title: Text(
        //   "Custom Easy Dialog Title",
        //   style: TextStyle(fontWeight: FontWeight.bold),
        //   textScaleFactor: 1.2,
        // ),
        descriptionPadding:
        EdgeInsets.only(left: 17.5, right: 17.5, bottom: 12.0),
        // description: Text(
        //   "This is a custom dialog. Easy Dialog helps you easily create basic or custom dialogs.",
        //   textScaleFactor: 1.1,
        //   textAlign: TextAlign.center,
        // ),
        topImage: NetworkImage(
            "https://files.virgool.io/upload/users/81133/posts/iux9rlci4upc/pkecce3o2x9z.png"),
        contentPadding:
        EdgeInsets.only(top: 12.0), // Needed for the button design
        contentList: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Okay",
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ]).show(context);
  }
}