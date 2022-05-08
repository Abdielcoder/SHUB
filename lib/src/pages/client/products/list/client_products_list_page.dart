import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:simple_animations/multi_tween/multi_tween.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';
import 'package:uber_clone_flutter/src/models/category.dart';
import 'package:uber_clone_flutter/src/models/product.dart';
import 'package:uber_clone_flutter/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'package:uber_clone_flutter/src/widgets/no_data_widget.dart';

import '../../../../utils/animacion_particulas.dart';
import '../../../drawer/DrawerScreen.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({Key key}) : super(key: key);

  @override
  _ClientProductsListPageState createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  ProgressDialog _progressDialog;
  ClientProductsListController _con = new ClientProductsListController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //  _con.init(context, refresh);
    });
  }
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.85 : 1.00)
        ..rotateZ(isDrawerOpen ? -50 : 0),
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.purple[900],
        borderRadius:
        isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(

              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  isDrawerOpen
                      ? GestureDetector(
                    child: Icon(Icons.arrow_back_ios,
                    color: MyColors.colorWhite,),
                    onTap: () {
                      setState(() {
                        xOffset = 0;
                        yOffset = 0;
                        isDrawerOpen = false;
                      });
                    },
                  )
                      : GestureDetector(
                    child: Icon(Icons.menu,
                      color: MyColors.colorWhite,),
                    onTap: () {
                      setState(() {
                        xOffset = 290;
                        yOffset = 80;
                        isDrawerOpen = true;
                      });
                    },
                  ),
                  Text(
                    'Solicita servicio',
                    style: TextStyle(
                        fontFamily: "Lexendeca-Regular",
                        fontSize: 39,
                        color: MyColors.colorWhite,
                        decoration: TextDecoration.none),
                  ),
                  Container(),

                ],
              ),



            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: FadeAnimation(
                  1,
                  // Text(
                  //   "Login & Sign Up Screen",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 30,
                  //       fontWeight: FontWeight.w700,
                  //       fontFamily: "Sofia"),
                  // )
                  Stack(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets
                            .only(top: 60,left: 90),
                        child: CircleAvatar(
                          backgroundColor: Colors
                              .white.withOpacity(0.3),
                          radius: 130,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets
                            .only(top: 80,left: 70),
                        child: CircleAvatar(
                          backgroundColor: Colors
                              .white.withOpacity(0.3),
                          radius: 130,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets
                            .only(top: 70),
                        child: Container(
                          width: 400,
                          height: 200,

                          child: Lottie.asset(
                              'assets/json/wash.json',
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets
                            .only(top: 400,left: 50),
                        child: Container(
                          width: 300,
                          height: 70,

                            child: ElevatedButton(
                                onPressed: (){},
                                child: Text('SERVICIO'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15)
                                )
                            )
                        ),
                      ),




                    ],
                  )

              ),
            ),

            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    AnimatedContainer(
                        width: double.infinity,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 1000),
                        decoration: BoxDecoration(
                            gradient: RadialGradient(colors: [
                              Colors.purple[800],
                              Colors.purple[800],
                              Colors.purple[900]


                            ])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 440.0,
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),


                    ),
                    Positioned.fill(
                      child: Opacity(
                          opacity: 0.5,
                          child: const AnimacionParticulas(23)),
                    ),


                  ],
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}

class NewPadding extends StatelessWidget {
  final String image1;
  final String text1;
  final String image2;
  final String text2;

  const NewPadding({
    Key key,
    this.image1,
    this.text1,
    this.image2,
    this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(145),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: MyColors.primaryColor,
            actions: [
              _shoppingBag()
            ],
            flexibleSpace: Column(
              children: [
                SizedBox(height: 30),
                _menuDrawer(),
                SizedBox(height: 40),
                //_textFieldSearch()
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryOpacityColor,
              labelColor: MyColors.colorAmarrillo,
              unselectedLabelColor: Colors.grey[200],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.categories.length, (index) {
                return Tab(
                  child: Text(_con.categories[index].name ?? ''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _con.categories.map((Category category) {
            return FutureBuilder(
                future:_con.getProducts(category.id, _con.productName),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardProduct(snapshot.data[index]);
                          }
                      );
                    }
                    else {
                      return NoDataWidget(text: 'No hay productos');
                    }
                  }
                  else {
                    return NoDataWidget(text: 'No hay productos');
                  }
                }
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget _cardProduct(Product product) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(product);
      },
      child: Container(
        height: 250,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(
                  top: -1.0,
                  right: -1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(20),
                        )
                    ),
                    child: Icon(Icons.add, color: Colors.white,),
                  )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.all(20),
                    child: FadeInImage(
                      image: product.image1 != null
                          ? NetworkImage(product.image1)
                          : AssetImage('assets/img/pizza2.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 30,
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NimbusSans'
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,),
                    child: Text(
                      '\$ ${product.price ?? 0}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSans'
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _shoppingBag() {
    return GestureDetector(
      onTap: _con.goToOrderCreatePage,
      child: Container(
        margin: EdgeInsets.only(right: 20,top:10),
        child: Image.asset('assets/img/carrito.png', width: 64, height: 64),
      ),
    );
  }
  // Widget _textFieldSearch() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     child: TextField(
  //
  //       onChanged: _con.onChangeText,
  //       decoration: InputDecoration(
  //           hintText: 'Buscar',
  //           suffixIcon: Icon(
  //               Icons.search,
  //               color: Colors.grey[400]
  //           ),
  //           hintStyle: TextStyle(
  //               fontSize: 17,
  //               color: Colors.grey[500]
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(25),
  //               borderSide: BorderSide(
  //                   color: Colors.grey[300]
  //               )
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(25),
  //               borderSide: BorderSide(
  //                   color: Colors.grey[300]
  //               )
  //           ),
  //           contentPadding: EdgeInsets.all(15)
  //       ),
  //     ),
  //   );
  // }
  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20,top: 3),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menuamarillo.png', width: 54, height: 52),
      ),
    );
  }
  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: MyColors.primaryColor
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.phone ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      image: _con.user?.image != null
                          ? NetworkImage(_con.user?.image)
                          : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  )
                ],
              )
          ),
          ListTile(
            onTap: _con.goToUpdatePage,
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit_outlined),
          ),
          ListTile(
            onTap: _con.goToCreateCar,
            title: Text('Vehículos'),
            trailing: Icon(Icons.airport_shuttle),
          ),
          ListTile(
            onTap: _con.goToOrdersList,
            title: Text('Mis servicios'),
            trailing: Icon(Icons.shopping_cart_outlined),
          ),
          ListTile(
            onTap: _con.goToCards,
            title: Text('Métodos de pago'),
            trailing: Icon(Icons.account_balance),
          ),
          _con.user != null ?
          _con.user.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Seleccionar rol'),
            trailing: Icon(Icons.person_outline),
          ) : Container() : Container(),
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesion'),
            trailing: Icon(Icons.power_settings_new),
          ),
          // ListTile(
          //   onTap: _con.logout,
          //   title: Text('ss sesion'),
          //   trailing: Icon(Icons.power_settings_new),
          // ),
        ],
      ),
    );
  }
  void refresh() {
    setState(() {}); // CTRL + S
  }*/
  Widget _buttonRequest() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: (){},
        child: Text('REGISTRARSE'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }
}
class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<String>()
      ..add("opacity", Tween(begin: 0.0, end: 1.0),
          Duration(milliseconds: 500))..add(
          "translateY", Tween(begin: -30.0, end: 0.0),
          Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<String>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) =>
          Opacity(
            opacity: animation.get("opacity"),
            child: Transform.translate(
                offset: Offset(0, animation.get("translateY")), child: child),
          ),
    );
  }
}