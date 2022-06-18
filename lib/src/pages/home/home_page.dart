
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:lottie/lottie.dart';
//import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uber_clone_flutter/src/models/batch.dart';
import 'package:uber_clone_flutter/src/pages/home/home_controller.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../models/bottom_bar.dart';

var UsersID;
var clientID;

Future<List<Batch>> fetchPhotos(http.Client client, String clientID, String UsersID) async {
  final response = await client
      .get(Uri.parse('http://vossgps.com/batchjobx/ws/ws_consulta_ProductionPick.php?UsersID=$UsersID&clientID=$clientID'));

  print(response.body);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Batch> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print('print : $parsed');
  return parsed.map<Batch>((json) => Batch.fromJson(json)).toList();
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
enum BottomIcons { Batch, Search, Account }

class _HomePageState extends State<HomePage> {
  ProgressDialog _progressDialog = new ProgressDialog();
  HomeController _con = new HomeController();

  void initState() {

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
      _progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 5),textToBeDisplayed:'Wait...',onDismiss:(){

      });
      // ProgressDialog _progresDialog = new ProgressDialog(context: context);
      // _progresDialog.show(max: 10, msg: "Waiting");
      // Timer(Duration(seconds: 8), () {
      //   _progresDialog.close();
      // });
    });
  }

  BottomIcons bottomIcons = BottomIcons.Batch;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute
        .of(context)
        ?.settings
        .arguments ?? <String, dynamic>{}) as Map;
    print('Los elementos son : $arguments');
    print(arguments['profile']);
    UsersID = arguments['UsersID'];
    clientID = arguments['clientID'];
    print('ARGUMENTS HOME SCREEN : $arguments');
    return Scaffold(
      body: Container(
       color: Colors.black,
        child: Stack(
          children: <Widget>[

              Container(
                alignment:Alignment.topCenter,
                  margin: EdgeInsets.only(top: 100),
                  child: Text(
                    'BATCH LOG',
                    style: TextStyle(fontSize: 28,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                  ),


            ),
            Container(
              alignment:Alignment.topCenter,
              margin: EdgeInsets.only(top: 150),
              child: Text(
                'Choose One',
                style: TextStyle(fontSize: 24,
                    fontFamily: 'Roboto',
                    color: Colors.white,)
                    //fontWeight: FontWeight.),
              ),


            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Lottie.asset(
                'assets/json/batch.json',
                width: 120,
                height: 120,
              ),
            ),
            bottomIcons == BottomIcons.Batch
                ? Center(
              child: Container(
                  margin: EdgeInsets.only(top: 70),
                  child: _listAddress(),
              ),
            )

                : Container(),
            bottomIcons == BottomIcons.Search
                ? Center(
              child: Text(
                "Hi, this is search page",
                style: TextStyle(fontSize: 18),
              ),
            )
                : Container(),
            bottomIcons == BottomIcons.Account
                ? Center(
              child: Text(
                "Hi, this is account page",
                style: TextStyle(fontSize: 18),
              ),
            )
                : Container(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 54, right: 24, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BottomBar(
                        onPressed: () {
                          setState(() {
                            bottomIcons = BottomIcons.Batch;
                          });
                        },
                        bottomIcons:
                        bottomIcons == BottomIcons.Batch ? true : false,
                        icons: EvaIcons.layersOutline,
                        text: "Batch"),
                    BottomBar(
                        onPressed: () {
                          setState(() {
                            bottomIcons = BottomIcons.Search;
                          });
                        },
                        bottomIcons:
                        bottomIcons == BottomIcons.Search ? true : false,
                        icons: EvaIcons.search,
                        text: "Search"),
                    BottomBar(
                        onPressed: () {
                          setState(() {
                            bottomIcons = BottomIcons.Account;
                          });
                        },
                        bottomIcons:
                        bottomIcons == BottomIcons.Account ? true : false,
                        icons: EvaIcons.settingsOutline,
                        text: "Account"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


//LIST ADRESS
  Widget _listAddress() {
    return FutureBuilder<List<Batch>>(
      future: fetchPhotos(http.Client(),clientID,UsersID),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const Center(

            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return Container(
            margin: new EdgeInsets.only(top: 80),

            child: Padding(
                padding: const EdgeInsets.all(30),

              child: GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 3),),
                itemBuilder: (BuildContext context, int index) {
                 return AnimatedButton(
                    onPress: () {
                      _progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 3),textToBeDisplayed:'Wait...',onDismiss:(){

                      });

                      Timer(Duration(seconds: 2), () {
                        _progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 3),textToBeDisplayed:'Wait...',onDismiss:(){

                        });

                        Navigator.pushNamed(
                          context,
                          'scanner',
                          arguments: {'batch_number':'${snapshot.data[index].batch_number}','ID':'${snapshot.data[index].ID}','UsersID':UsersID, 'clientID':clientID},
                        );
                      });


                    },
                    height: 70,
                    width: 200,
                    text: '${snapshot.data[index].batch_number}',
                    gradient: LinearGradient(colors: [Colors.blue[900], Colors.blue[800]]),
                    selectedGradientColor: LinearGradient(
                        colors: [Colors.red[900], Colors.red[800]]),
                    isReverse: true,
                    selectedTextColor: Colors.white,
                    transitionType: TransitionType.LEFT_CENTER_ROUNDER,
                   textStyle: TextStyle(color: Colors.white,
                       fontSize: MediaQuery.of(context).size.width /
                           (MediaQuery.of(context).size.height / 50),
                     ),
                    borderColor: Colors.white,
                    borderWidth: 1,
                  );
                  // SizedBox(
                  // height: 50,
                  // ),

                  // return  ClipRRect(
                  //     borderRadius: BorderRadius.circular(120),
                  //   child: Container(
                  //     margin: new EdgeInsets.only(right: 10,top: 10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red[900],
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(18.0),
                  //       child: InkWell(
                  //         onTap: (){
                  //           Navigator.pushNamed(
                  //             context,
                  //             'scanner',
                  //             arguments: {'batch_number':'${snapshot.data[index].batch_number}','ID':'${snapshot.data[index].ID}','UsersID':UsersID, 'clientID':clientID},
                  //           );
                  //         },
                  //         child: Text(
                  //             '${snapshot.data[index].batch_number}',
                  //                 textAlign:TextAlign.center,
                  //           style: TextStyle(color: Colors.white,
                  //             fontSize: MediaQuery.of(context).size.width /
                  //                 (MediaQuery.of(context).size.height / 50),
                  //           ),
                  //
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
                itemCount: snapshot.data.length,
              ),
            ),
          );


          // return Container(
          //     child: ListView.builder(
          //         itemCount: snapshot.data.length,
          //         scrollDirection: Axis.horizontal,
          //         itemBuilder: (BuildContext context, int index) {
          //           return Text('${snapshot.data[index].batch_number}');
          //         }));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void refresh() {
    setState(() {

    });
  }

}
