import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:uber_clone_flutter/src/models/user.dart';
import 'package:uber_clone_flutter/src/utils/progress_dialog.dart';

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
    var url = 'http://3.217.149.82/batchjobx/ws/validar_usuario.php?usuario={$email}&password={$password}';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var username = jsonResponse['username'];
      var UsersID = jsonResponse['UsersID'];
      var profile = jsonResponse['profile'];
      var clientID = jsonResponse['clientID'];
      print('Response ### http: $jsonResponse.');

      if(UsersID == 'USER ERROR'){
        _progressDialog.close();
        print('Error de inicio de session');

      }else{

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
}