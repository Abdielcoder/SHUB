import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:uber_clone_flutter/src/models/batch.dart';
import 'package:uber_clone_flutter/src/models/user.dart';

class BatchProvider {
  String _url = "vossgps.com";
  BuildContext context;

  Future init(BuildContext context) {
    this.context = context;
  }


  Future<List<Batch>> getBatchs() async {



  }
}

