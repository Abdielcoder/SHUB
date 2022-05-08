import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uber_clone_flutter/src/models/response_api.dart';
import 'package:uber_clone_flutter/src/models/user.dart';
import 'package:uber_clone_flutter/src/provider/car_provider.dart';
import 'package:uber_clone_flutter/src/utils/my_snackbar.dart';
import 'package:uber_clone_flutter/src/utils/shared_pref.dart';
import '../../../models/car.dart';
import '../../../provider/users_provider.dart';
import '../../../utils/dialog.dart';


class ClientCarCreateController {

  String selectedValue;
  String selectedCarColor;
  String cadenaColorHex;

  void onSelected(String value) {
    selectedValue = value;


    print(selectedValue);
  }

  void onSelectedColor(String carColor){
    selectedCarColor = carColor;
    cadenaColorHex = selectedCarColor.substring(10,16);
    print("Current Color State : ${cadenaColorHex}");
  }

  //CONTEX APP
  BuildContext context;
  Function refresh;
  //INPUTS
  TextEditingController marcaController = new TextEditingController();
  TextEditingController modeloController = new TextEditingController();
  TextEditingController placaController = new TextEditingController();
  PickedFile pickedFile;
  File imageFile;

  CarProvider _carProvider = new CarProvider();
  User user;
  UsersProvider usersProvider = new UsersProvider();
  SharedPref sharedPref = new SharedPref();


  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _progressDialog = ProgressDialog(context: context);

    user = User.fromJson(await sharedPref.read('user'));
    usersProvider.init(context, sessionUser: user);
  }


  //IMG FROM GALLERY OR CAMERA
  Future selectImage(ImageSource imageSource) async {
    //DEFINE SOURCE
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  //DIALOG TO PICK UP OR TAKE PHOTO
  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  void createCar() async {
    //GET DATA FROM INPUTS
    String marca = marcaController.text;
    String modelo = modeloController.text;
    String placa = placaController.text;

    //VALIDATED INFO
    if (marca.isEmpty || modelo.isEmpty || placa.isEmpty) {
      MySnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }
    if (imageFile == null) {
      MySnackbar.show(context, 'Selecciona una imagen');
      return;
    }
    _progressDialog.show(max: 100, msg: 'Espere un momento...');

    //CREATE OBJECT FROM INPUTS
    Car mycar = new Car(
      id_user: user.id,
      marca: marca,
      modelo: modelo,
      year: selectedValue,
      placa: placa,
      color: cadenaColorHex,

    );


    print('La ruta de la imagen en el controller: ${imageFile}');
    //SEND DATA INCLUDE DE IMAGE
    Stream stream = await _carProvider.createWithImage(mycar, imageFile);
    stream.listen((res) {
      _progressDialog.close();

      // ResponseApi responseApi = await usersProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA: ${responseApi.toJson()}');
      MySnackbar.show(context, responseApi.message);

      if (responseApi.success) {
        MyDialog.show(context, 'Vehículo Agregado','Tu Informacion se cargo correctamente','client/car/list');
        // Future.delayed(Duration(seconds: 3), () {
        //   Navigator.pushReplacementNamed(context, 'login');
        // });
      }
      // else {
      //   isEnable = true;
      // }
    });

    /*//SEND DATA TO API
    ResponseApi responseApi = await _carProvider.create(mycar);
    //GET RESPONSE FROM SERVER API
    MySnackbar.show(context, responseApi.message);
    //IF RESPONSE IS SUCCESS CLEAR INPUTS
    if (responseApi.success) {
      _progressDialog.close();
      marcaController.text = '';
      modeloController.text = '';
      placaController.text = '';
      MyDialog.show(context, 'Vehículo Agregado','Tu Informacion se cargo correctamente');
    }
*/

  }

}