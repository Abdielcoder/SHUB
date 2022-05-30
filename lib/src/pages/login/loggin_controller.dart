import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:uber_clone_flutter/src/models/user.dart';


import 'package:uber_clone_flutter/src/utils/progress_dialog.dart';
import 'package:uber_clone_flutter/src/utils/shared_pref.dart';


class LoginController {

  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  // UsersProvider usersProvider = new UsersProvider();
  // PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
  SharedPref _sharedPref = new SharedPref();
  ProgressDialog _progressDialog;

  Future init(BuildContext context) async {
    this.context = context;

    User user = User.fromJson(await _sharedPref.read('user') ?? {});

    // print('Usuario: ${user.toJson()}');

    MyProgressDialog.show(context, 'Validando Información', false);


  }


  void login() async {
    MyProgressDialog.show(context, 'Validando Información', true);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    getRequest();

    }

  Future<List<User>> getRequest() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = 'http://3.217.149.82/batchjobx/ws/validar_usuario.php?usuario=tjop1&password=op1';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse['username'];
      print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}