import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber_clone_flutter/src/models/addresss.dart';
import 'package:uber_clone_flutter/src/models/car.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'package:uber_clone_flutter/src/widgets/no_data_widget.dart';

import 'list_car_pay_controller.dart';


class ListCarPayPage extends StatefulWidget {
  const ListCarPayPage({Key key}) : super(key: key);

  @override
  _ListCarPayPageState createState() => _ListCarPayPageState();
}

class _ListCarPayPageState extends State<ListCarPayPage> {

  ListCarPayController _con = new ListCarPayController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text('Vehiculos'),
        automaticallyImplyLeading: false, //
        actions: [
          _iconAdd()
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: _textSelectAddress()
          ),
          Positioned(
              top: 0,
              child: _textSeleciion()
          ),
          Container(
              margin: EdgeInsets.only(top: 100),
              child: _listAddress()
          ),


        ],
      ),


    );

  }

  Widget _noCars() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 30),
            child: NoDataWidget(text: 'No tienes ningún Vehiculo, agrega uno')
        ),
        _buttonNewCar()
      ],
    );
  }


  Widget _buttonNewCar() {
    return Container(
      height: 40,
      child: ElevatedButton(
        onPressed: _con.goToNewCard,
        child: Text(
            'Nuevo Vehiculo'
        ),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor
        ),
      ),
    );
  }



//LIST ADRESS
  Widget _listAddress() {
    return FutureBuilder(
        future: _con.getCars(),//GET LIST ADRRES FROM PROVIDER
        builder: (context, AsyncSnapshot<List<Car>> snapshot) {
          if (snapshot.hasData) {//VALIDATED
            if (snapshot.data.length > 0) {//VALIDATED

              return Stack(
                  children: [ListView.builder(
                      reverse: false,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (_, index) {
                        return _radioSelectorAddress(snapshot.data[index], index);
                      }
                  ),

                  ]
              );


            }
            else {
              return _noCars();
            }

          }
          else {
            return _noCars();
          }

        }

    );

  }

  Widget _radioSelectorAddress(Car cars, int index) {
    String colorCarBd =cars?.color ?? '';
    String colorWHex = "0xFF${colorCarBd}";
    int colorCar = int.parse(colorWHex);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Row(

            children: [

              // Radio(
              //
              //   value: index,
              //   groupValue: _con.radioValue,
              //   onChanged:  _con.handleRadioValueChange,
              //
              // ),
              Column(children: <Widget>[
              SizedBox(height: 32.0),
              GestureDetector(
              onTap: (){},
              child:  CircleAvatar(
                    backgroundImage: cars.image != null
                        ? NetworkImage(cars.image)
                        : AssetImage('assets/img/placac.png'),
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                  ),
              )],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 5),
                    child: Text(
                      cars?.marca ?? '',
                      style: TextStyle(
                          color: MyColors.colorTitulosSegundos,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 5),
                    child: Text(
                      cars?.modelo ?? '',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 5),
                    child: Text(
                      'AÑO',
                      style: TextStyle(
                          color: MyColors.colorTitulosSegundos,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 5),
                    child: Text(
                      cars?.year ?? '',
                      style: TextStyle(
                        fontSize: 12,

                      ),
                    ),
                  ),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:0, left: 8,bottom: 5),
                    child: Text(
                      'COLOR',
                      style: TextStyle(
                          color: MyColors.colorTitulosSegundos,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18,bottom: 5),
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        backgroundImage: cars.color != null
                            ? AssetImage('')
                            : AssetImage('assets/img/car_color.png'),
                        radius: 7,
                        backgroundColor: Color(colorCar),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:0, left: 8,bottom: 5),
                    child: Text(
                      'PLACA',
                      style: TextStyle(
                          color: MyColors.colorTitulosSegundos,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8,bottom: 5),
                    child: Text(
                      cars?.placa ?? '',
                      style: TextStyle(
                        fontSize: 12,

                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 20,bottom: 5),
                    child: _iconGo(cars),
                  )

                ],
              ),

            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }

  Widget _textSelectAddress() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Text(
        'Selecciona un vehiculo para el servicio ',
        style: TextStyle(
            fontSize: 19,
            fontFamily: 'Lexendeca-Black',
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _textSeleciion() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Text(
        'Presiona el botón para para seleccionar auto',
        style: TextStyle(
          fontFamily: 'Lexendeca-Regular',
          fontSize: 15,

        ),
      ),
    );
  }

  Widget _iconAdd() {

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            children: [
              Row(
                  children: [
                    Text(
                      'Agrega un vehiculo',
                      style: TextStyle(
                        fontFamily: 'Lexendeca-Regular',
                        fontSize: 14,

                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: _con.goToNewCard,
                            icon: Icon(Icons.add, color: Colors.white)
                        ),

                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Regresar',
                          style: TextStyle(
                            fontFamily: 'Lexendeca-Regular',
                            fontSize: 14,

                          ),
                        ),

                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: _con.goBack,
                            icon: Icon(Icons.arrow_back, color: Colors.white)
                        ),

                      ],
                    ),
                  ]

              ),
            ]
        )
    );

  }

  void refresh() {
    setState(() {

    });

  }

  Widget _iconGo(Car cars) {
    return Container(
      child: ElevatedButton(

        child: Text('Seleccionar',
        style: TextStyle(
          fontSize: 10
        ),),
        onPressed: () {
          _con.goToAddress(cars);
        },
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'Lexendeca-Regular',
                fontWeight: FontWeight.bold)),
      ),

    );
  }


}
