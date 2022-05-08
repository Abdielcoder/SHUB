import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:uber_clone_flutter/src/api/environment.dart';
import 'package:uber_clone_flutter/src/models/response_api.dart';
import 'package:uber_clone_flutter/src/models/user.dart';
import 'package:uber_clone_flutter/src/utils/my_snackbar.dart';
import 'package:uber_clone_flutter/src/utils/shared_pref.dart';

import '../models/car.dart';


class CarProvider {

  String _url = Environment.API_DELIVERY;
  String _api = '/api/cars';
  BuildContext context;
  User sessionUser;


  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;

  }


  Future<List<Car>> getByUser(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByUser/${idUser}');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {

        MySnackbar.show(context, 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body); // CATEGORIAS
      Car cars = Car.fromJsonList(data);
      return cars.toList;
    }
    catch(e) {
      print('Error: $e');
      return [];
    }
  }

  //CREATE CAR WITH IMAGE
  Future<Stream> createWithImage(Car mycar, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/createwimage');
      final request = http.MultipartRequest('POST', url);
      print("La ruta de la imagen en el provider: ${image}");
      if (image != null) {//IF IMAGE != NULL GET IMAGE AND NOW LENGTH
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path)//BASE NAME
        ));
      }

      request.fields['mycar'] = json.encode(mycar);
      print("Body Param OBjeto mycar : ${request.fields['mycar']}");

      final response = await request.send(); // ENVIARA LA PETICION
      return response.stream.transform(utf8.decoder);
    }
    catch(e) {
      print('Error de la API: $e');
      return null;
    }
  }

  //CREATE CAR WITH OUT IMAGE
  Future<ResponseApi> create(Car car) async {
    try {
      //FINAL URL
      Uri url = Uri.http(_url, '$_api/create');
      //DATA FROM JSON OBJECT
      String bodyParams = json.encode(car);
      print("Body Param OBjeto mycar : ${bodyParams}");
      //SEND HEADERS
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      //SEND PETTITION
      final res = await http.post(url, headers: headers, body: bodyParams);
      //VALIDATED SESSION TOKEN
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      //GET RESPONSE DATA
      final data = json.decode(res.body);
      //VALIDATED RESPONSE
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  //DELETE CAR
  Future<ResponseApi> deleteCar(String id) async {
    try {
      //FINAL URL
      Uri url = Uri.http(_url, '$_api/delete/car/${id}');
      //DATA FROM JSON OBJECT
      //String bodyParams = json.encode(id);
     // print("Body Param id delete car : ${bodyParams}");
      //SEND HEADERS
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      //SEND PETTITION
      final res = await http.delete(url, headers: headers);
      //VALIDATED SESSION TOKEN
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      //GET RESPONSE DATA
      final data = json.decode(res.body);
      //VALIDATED RESPONSE
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

}