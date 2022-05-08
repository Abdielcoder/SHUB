import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/pages/client/address/create/client_address_create_page.dart';
import 'package:uber_clone_flutter/src/pages/client/address/list/client_address_list_page.dart';
import 'package:uber_clone_flutter/src/pages/client/address/map/client_address_map_page.dart';
import 'package:uber_clone_flutter/src/pages/client/create/client_car_create_page.dart';
import 'package:uber_clone_flutter/src/pages/client/listcars/client_car_list_page.dart';
import 'package:uber_clone_flutter/src/pages/client/listcarspay/list_car_pay_page.dart';
import 'package:uber_clone_flutter/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:uber_clone_flutter/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:uber_clone_flutter/src/pages/client/orders/map/client_orders_map_page.dart';
import 'package:uber_clone_flutter/src/pages/client/payments/create/client_payments_create_page.dart';
import 'package:uber_clone_flutter/src/pages/client/payments/installments/client_payments_installments_page.dart';
import 'package:uber_clone_flutter/src/pages/client/payments/status/client_payments_status_page.dart';
import 'package:uber_clone_flutter/src/pages/client/payments/stripe/existingcards/stripe_existing_cards_menu_page.dart';
import 'package:uber_clone_flutter/src/pages/client/payments/stripe/stripe_existing_cards_page.dart';
import 'package:uber_clone_flutter/src/pages/client/payments/stripe/stripe_store_cards_page.dart';
import 'package:uber_clone_flutter/src/pages/client/products/list/client_menu_list.dart';
import 'package:uber_clone_flutter/src/pages/client/update/client_update_page.dart';
import 'package:uber_clone_flutter/src/pages/delivery/orders/finish/finish_clean_page.dart';
import 'package:uber_clone_flutter/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:uber_clone_flutter/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:uber_clone_flutter/src/pages/login/login_page.dart';
import 'package:uber_clone_flutter/src/pages/register/register_page.dart';
import 'package:uber_clone_flutter/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:uber_clone_flutter/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:uber_clone_flutter/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:uber_clone_flutter/src/pages/roles/roles_page.dart';
import 'package:uber_clone_flutter/src/pages/splashscreen/splash_screen_page.dart';
import 'package:uber_clone_flutter/src/provider/push_notifications_provider.dart';

import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initPushNotifications();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pushNotificationsProvider.onMessageListener();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Voitu',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'splashScreen':(BuildContext context) => SplashScreenPage(),
        'login':(BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'roles': (BuildContext context) => RolesPage(),
        'client/products/list': (BuildContext context) => ClientMenuListPage(),
        'client/update': (BuildContext context) => ClientUpdatePage(),
        'client/create/car': (BuildContext context) => CLientCarCreatePage(),
        'client/car/list': (BuildContext context) => ClientCarsListPage(),
        'client/list/car/pay': (BuildContext context) => ListCarPayPage(),
        'client/orders/create' : (BuildContext context) => ClientOrdersCreatePage(),
        'client/address/list' : (BuildContext context) => ClientAddressListPage(),
        'client/address/create' : (BuildContext context) => ClientAddressCreatePage(),
        'client/address/map' : (BuildContext context) => ClientAddressMapPage(),
        'client/orders/list' : (BuildContext context) => ClientOrdersListPage(),
        'restaurant/orders/list': (BuildContext context) => RestaurantOrdersListPage(),
        'client/orders/map' : (BuildContext context) => ClientOrdersMapPage(),
        'client/payments/create' : (BuildContext context) => ClientPaymentsCreatePage(),
        'client/payments/installments' : (BuildContext context) => ClientPaymentsInstallmentsPage(),
        'client/payments/status' : (BuildContext context) => ClientPaymentsStatusPage(),
        'restaurant/categories/create' : (BuildContext context) => RestaurantCategoriesCreatePage(),
        'restaurant/products/create' : (BuildContext context) => RestaurantProductsCreatePage(),
        'delivery/orders/list': (BuildContext context) => DeliveryOrdersListPage(),
        'delivery/orders/map' : (BuildContext context) => DeliveryOrdersMapPage(),
        'client/payments/stripe' : (BuildContext context) => StripeStoreCardPage(),
        'client/payments/stripe/existingcards' : (BuildContext context) => ExistingCardsPage(),
        'client/payments/stripe/existingcards/menu' : (BuildContext context) => ExistingCardsMenuPage(),
        'client/finish/clean' : (BuildContext context) => FinishCleanPage(),


      },
      theme: ThemeData(
          primaryColor: MyColors.primaryColor
      ),
    );
  }
}
