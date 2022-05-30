
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

  // void onSelected(String value) {
  //   selectedValue = value;
  //
  //
  //   print(selectedValue);
  // }
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    batchs = Batch.fromJson(await _sharedPref.read('batch'));
    _batchProvider.init(context);
    refresh();
  }


  Future<List<Batch>> getBatch() async {
    // print('ENTRE 33 ${batch.toString()}');
    // batch = await _batchProvider.getBatchs();
    // print('LO QUE TREA BATCHS 33 ${batch.toString()}');
    // return batch;

    var url = 'http://3.217.149.82/batchjobx/ws/validar_usuario.php?usuario=tjop1&password=op1';
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body).cast<Map<String, dynamic>>();

     // print('Responses Batches 33: $jsonResponse.');


      print('DATA : W '+jsonResponse.map<Batch>((json) => Batch.fromJson(json)).toList());
      //return jsonResponse.map<Batch>((json) => Batch.fromJson(json)).toList();
      // print(posts);
      return jsonResponse;

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }



  }

}