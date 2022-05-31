
import 'dart:convert';
import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_clone_flutter/src/models/batch.dart';
import 'package:uber_clone_flutter/src/pages/home/home_controller.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../models/bottom_bar.dart';

Future<List<Batch>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://vossgps.com/batchjobx/ws/ws_consulta_ProductionPick.php?UsersID=2&clientID=1'));

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
  HomeController _con = new HomeController();

  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://wallpaper.dog/large/10762816.png"),
            fit: BoxFit.cover,
          ),
        ),
    child: ClipRRect( // make sure we apply clip it properly
    child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                  width: 400,
                  height: 700,
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    'BATCH LOG',
                    textAlign:TextAlign.center,
                    style: TextStyle(fontSize: 28,
                    fontFamily: 'Prompt-Italic',
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                  )
              ),
            ),
            Container(
              child: Lottie.asset(
                'assets/json/batch.json',
                width: 200,
                height: 200,
              ),
            ),
            bottomIcons == BottomIcons.Batch
                ? Center(
              child: Container(
                  width: 400,
                  height: 700,
                  margin: EdgeInsets.only(top: 150),
                  child: _listAddress()
              ),
            )
            //     : Container(),
            // bottomIcons == BottomIcons.Favorite
            //     ? Center(
            //   child: Text(
            //     "Hi, this is favorite page",
            //     style: TextStyle(fontSize: 18),
            //   ),
            // )
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
        ))),
      ),
    );
  }

//LIST ADRESS
  Widget _listAddress() {
    return FutureBuilder<List<Batch>>(
      future: fetchPhotos(http.Client()),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const Center(

            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return Padding(
              padding: const EdgeInsets.all(18),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(118),
            child: GridView.builder(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 4),),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100,
                  margin: new EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      colorFilter:
                      ColorFilter.mode(Colors.black.withOpacity(0.2),
                          BlendMode.dstATop),
                image: NetworkImage("https://mecaluxmx.cdnwm.com/blog/img/orden-picking-wms.1.19.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(
                          context,
                          'scanner',
                          arguments: {'batch_number':'${snapshot.data[index].batch_number}','ID':'${snapshot.data[index].ID}'},
                        );
                      },
                      child: Text(
                          '${snapshot.data[index].batch_number}',
                              textAlign:TextAlign.center,
                        style: TextStyle(color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 50),
                        ),

                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            ),
          ));


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
