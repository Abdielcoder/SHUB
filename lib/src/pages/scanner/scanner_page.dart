import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../../models/consultaBatch.dart';

Future<List<ConsultaBatch>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://3.217.149.82/batchjobx/ws/ws_consultaBatch.php?UsersID=2&clientID=1&bitacoraID=13'));

  print(response.body);
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<ConsultaBatch> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print('print : $parsed');
  return parsed.map<ConsultaBatch>((json) => ConsultaBatch.fromJson(json)).toList();
}

Future<List<ConsultaBatch>> updateBatch(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://3.217.149.82/batchjobx/ws/ws_actualizarBatch.php?UsersID=2&clientID=1&bitacoraID=13&batchID=463&sts=PENDING'));

  print(response.body);
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(passUpdateBatch, response.body);
}

// A function that converts a response body into a List<Photo>.
List<ConsultaBatch> passUpdateBatch(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print('print : $parsed');
  return parsed.map<ConsultaBatch>((json) => ConsultaBatch.fromJson(json)).toList();
}


class ScannerPage extends StatefulWidget {
  const ScannerPage({Key key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  //  scanBarcodeNormal();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    print('Los elementos son : $arguments');
    print(arguments['batch_number']);
    print(arguments['ID']);
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
                          margin: EdgeInsets.only(top: 0),
                          child: Text(
                            'SCAN UTILITY',
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
                          'assets/json/code3.json',
                          width: 200,

                        ),
                      ),
                    SingleChildScrollView(
                           child: Center(
                      child: Container(
                            width: 450,
                            margin: EdgeInsets.only(top: 250),
                            child: _data()
                      ),
                    ),
                         )
                  ],
                ))),
      ),
    );

  }

  Widget _data() {
    if(_scanBarcode=="Unknown" ||_scanBarcode=="-1"){
      return Container(

          alignment: Alignment.topCenter,
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => scanBarcodeNormal(),
                    child: Text('SCAN')),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('Consolidation Group',
                      style: TextStyle(fontSize: 20,
                          color: Colors.white)),
                ),
                _listAddress(),
              ]));
    }else{
      _update();
      return Container(
          alignment: Alignment.topCenter,
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => scanBarcodeNormal(),
                    child: Text('Scan Again')),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('"Updated OK"  With The Barcode\n',
                      style: TextStyle(fontSize: 20,
                          color: Colors.white)),
                ),
                Text('$_scanBarcode\n',
                    style: TextStyle(fontSize: 20,
                        color: Colors.white)),
                Container(
                  child: Lottie.asset(
                    'assets/json/check.json',
                    width: 200,

                  ),
                ),

              ]));
    }

  }
// //LIST ADRESS
//   Widget _batch() {
//     return Container(
//             child: Padding(
//                 padding: const EdgeInsets.all(1),
//                 child: ClipRRect(
//                   child: GridView.builder(
//                     scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     gridDelegate:
//                     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,
//                       childAspectRatio: MediaQuery.of(context).size.width /
//                           (MediaQuery.of(context).size.height / 4),),
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin: new EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
//                         decoration: BoxDecoration(
//                           // color: const Color(0xff7c94b6),
//                           color: Colors.black,
//
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: InkWell(
//                             onTap: (){
//                               // Navigator.pushNamed(
//                               //   context,
//                               //   'scanner',
//                               //   arguments: {'batch_number':'${snapshot.data[index].batch_number}','ID':'${snapshot.data[index].ID}'},
//                               // );
//                             },
//
//                             child: Text(
//                               'CG: ${_scanBarcode} \n Updated OK',
//                               textAlign:TextAlign.center,
//                               style: TextStyle(color: Colors.lightGreen,
//                                 fontSize: MediaQuery.of(context).size.width /
//                                     (MediaQuery.of(context).size.height / 20),
//                               ),
//
//                             ),
//
//                           ),
//                         ),
//                       );
//                     },
//
//                   ),
//                 )),
//           );
//
//         }

  //LIST ADRESS
  Widget _listAddress() {
    return FutureBuilder<List<ConsultaBatch>>(
      future: fetchPhotos(http.Client()),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return Container(
            child: Padding(
                padding: const EdgeInsets.all(1),
                child: ClipRRect(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 4),),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: new EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                        decoration: BoxDecoration(
                          // color: const Color(0xff7c94b6),
                          color: Colors.black,

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: (){
                              // Navigator.pushNamed(
                              //   context,
                              //   'scanner',
                              //   arguments: {'batch_number':'${snapshot.data[index].batch_number}','ID':'${snapshot.data[index].ID}'},
                              // );
                            },
                            child: Text(
                              'CG: ${snapshot.data[index].console_group} \n ST: ${snapshot.data[index].station}',
                              textAlign:TextAlign.center,
                              style: TextStyle(color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 20),
                              ),

                            ),

                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
                )),
          );

        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  //LIST ADRESS
  Widget _update() {
    return FutureBuilder<List<ConsultaBatch>>(
      future: updateBatch(http.Client()),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return Container();

        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}