import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/models/product.dart';
import 'package:uber_clone_flutter/src/utils/shared_pref.dart';

import '../../../models/car.dart';
import '../../../models/user.dart';
import '../../../provider/car_provider.dart';
import '../../../utils/dialog.dart';


class ListCarPayController {

  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();

  List<Product> selectedProducts = [];
  double total = 0;

  List<Car> cars = [];
  CarProvider _carProvider = new CarProvider();
  User user;
  int radioValue = 0;
  String selectedValue;

  void onSelected(String value) {
    selectedValue = value;


    print(selectedValue);
  }
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _carProvider.init(context, user);
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;

    getTotal();
    refresh();
  }
  Future<List<Car>> getCars() async {
    cars = await _carProvider.getByUser(user.id);
    //
    // Car a = Car.fromJson(await _sharedPref.read('address') ?? {});
    // int index = cars.indexWhere((ad) => ad.id == a.id);

    // if (index != -1) {
    //   radioValue = index;
    //   elestado = true;
    // }

    // print('SE GUARDO LA DIRECCION: ${a.toJson()}');
    print('LO QUE TREA CARS  ${cars.toString()}');
    return cars;
  }
  void getTotal() {
    total = 0;
    selectedProducts.forEach((product) {
      print("Productos Selecionados : ${product.image1}");
      total = total + (product.quantity * product.price);
    });
    refresh();
  }

  void addItem(Product product) {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts[index].quantity = selectedProducts[index].quantity + 1;
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void removeItem(Car cars) {
    // if (cars.quantity > 1) {
    //   int index = selectedProducts.indexWhere((p) => p.id == product.id);
    //   selectedProducts[index].quantity = selectedProducts[index].quantity - 1;
    //   _sharedPref.save('order', selectedProducts);
    //   getTotal();
    // }
  }

  void deleteItem(Car cars) {
    MyDialog.info(context, 'ELIMINAR','¿Quieres eliminar el Vehiculo?...','client/car/list',cars.id);
  }

  void goToAddress(Car cars) async{
    // _sharedPref.save('cars', cars.id);
    // Car idcar = Car.fromJson(await _sharedPref.read('cars') ?? {});
    // print("valor id car : ${idcar}");
    Navigator.pushNamed(context, 'client/address/list');
  }

  void goToNewCard() async {
    var result = await Navigator.pushNamed(context, 'client/create/car');

    if (result != null) {
      if (result) {
        refresh();
      }
    }
  }

  void goBack() async {
    var result = await Navigator.pushNamed(context, 'client/products/list');

    if (result != null) {
      if (result) {
        refresh();
      }
    }
  }
  // void handleRadioValueChange(int value) async {
  //   radioValue = value;
  //   refresh();
  //   print('Valor seleccioonado: $radioValue');
  // }


}