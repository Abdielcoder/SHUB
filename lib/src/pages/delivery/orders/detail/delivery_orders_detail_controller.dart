import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/models/order.dart';
import 'package:uber_clone_flutter/src/models/product.dart';
import 'package:uber_clone_flutter/src/models/response_api.dart';
import 'package:uber_clone_flutter/src/models/user.dart';
import 'package:uber_clone_flutter/src/provider/orders_provider.dart';
import 'package:uber_clone_flutter/src/provider/users_provider.dart';
import 'package:uber_clone_flutter/src/utils/my_snackbar.dart';
import 'package:uber_clone_flutter/src/utils/shared_pref.dart';

import '../../../../provider/push_notifications_provider.dart';


class DeliveryOrdersDetailController {

  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();

  double total = 0;
  Order order;
  PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

  User user;
  List<User> users = [];
  UsersProvider _usersProvider = new UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  String idDelivery;
  String idClient;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }

  // void sendNotification(String tokenDelivery) {
  //
  //   Map<String, dynamic> data = {
  //     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //     "screen": "client/orders/list",
  //   };
  //
  //   pushNotificationsProvider.sendMessage(
  //       tokenDelivery,
  //       data,
  //       'SERVICIO DESPACHADO',
  //       'Tu servicio esta en proceso...'
  //   );
  // }

  void updateOrder() async {

    // order.idClient = idClient;

    if (order.status == 'DESPACHADO') {
      ResponseApi responseApi = await _ordersProvider.updateToOnTheWay(order);

      MySnackbar.show(context, responseApi.message);
      if (responseApi.success) {
        // User idClient = await _usersProvider.getById(order.idClient);
        // print("TU ID CLIENTE ES ${idClient}");

        Navigator.pushNamed(context, 'delivery/orders/map', arguments: order.toJson());
      }
    }
    else {
      Navigator.pushNamed(context, 'delivery/orders/map', arguments: order.toJson());
    }
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryMen();
    refresh();
  }

  void getTotal() {
    total = 0;
    order.products.forEach((product) {
      total = total + (product.price * product.quantity);
    });
    refresh();
  }

}