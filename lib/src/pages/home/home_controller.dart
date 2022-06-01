
import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/models/batch.dart';
import 'package:uber_clone_flutter/src/models/product.dart';
import 'package:uber_clone_flutter/src/utils/shared_pref.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../../provider/batch_provider.dart';


class HomeController {

  BuildContext context;
  Function refresh;
  SharedPref _sharedPref = new SharedPref();

  List<Batch> batch = [];
  BatchProvider _batchProvider = new BatchProvider();
  Batch batchs;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    batchs = Batch.fromJson(await _sharedPref.read('batch'));
    _batchProvider.init(context);
    refresh();
  }
}