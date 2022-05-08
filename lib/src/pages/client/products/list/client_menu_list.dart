import 'package:flutter/material.dart';
import 'package:uber_clone_flutter/src/pages/client/address/list/client_address_list_page.dart';
import 'package:uber_clone_flutter/src/pages/client/products/list/client_products_list_page.dart';

import '../../../drawer/DrawerScreen.dart';

class ClientMenuListPage extends StatefulWidget {
  const ClientMenuListPage({Key key}) : super(key: key);

  @override
  _ClientMenuListPageState createState() => _ClientMenuListPageState();
}

class _ClientMenuListPageState extends State<ClientMenuListPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            DrawerScreen(),
            ClientProductsListPage(),
          ],
        ),
      ),
    );
  }
}