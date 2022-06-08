import 'dart:convert';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/consultaBatch.dart';
import '../../utils/shared_pref.dart';
import 'dart:convert' as convert;

var UsersID;
var clientID;
var ID;
var batch_number;
var batchID;
var consoleGroup;
var station;
List<String> scanSelected = [];
SharedPreferences pref;
Barcode text;
int barnumber;
bool insection;

Future<List<ConsultaBatch>> fetchPhotos(http.Client client, String UsersID, String clientID, String ID ) async {
  final response = await client
      .get(Uri.parse('http://3.217.149.82/batchjobx/ws/ws_consultaBatch.php?UsersID=$UsersID&clientID=$clientID&bitacoraID=$ID'));

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

///
///





///
///

Future<List<ConsultaBatch>> updateBatch(http.Client client, String UsersID, String clientID, String ID,String barcode, String batchID  ) async {
  final response = await client
      .get(Uri.parse('http://3.217.149.82/batchjobx/ws/ws_actualizarBatch.php?UsersID=$UsersID&clientID=$clientID&bitacoraID=$ID&console_group=$barcode&batchID=$batchID&sts=369'));

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

  static Future init() async {
    pref = await SharedPreferences.getInstance();

  }
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController cameraController;
  bool initialized = false;
  ////////
  // Takes picture with the selected device camera, and
  // returns the image path
  Future<String> _takePicture() async {
    if (!cameraController.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    String imagePath;

    if (cameraController.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }

    try {
      // Turning off the camera flash
      cameraController.setFlashMode(FlashMode.off);
      // Returns the image in cross-platform file abstraction
      final XFile file = await cameraController.takePicture();
      // Retrieving the path
      imagePath = file.path;
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }


  String _scanBarcode = 'Unknown';

  bool isInitilized = false;

  @override
  void initState() {
    FlutterMobileVision.start().then((value){
      isInitilized = true;
    });
    super.initState();
    //  scanBarcodeNormal();
  }

  _startScan()async{
    List<Barcode> barcodes = [];
    try{
      final player = AudioCache();
      setState(() {});
      barcodes = await FlutterMobileVision.scan(
        waitTap: true,
        fps: 5,
        multiple: true,
      );


      for( text in barcodes){
        print('inset *OCR* ${text.displayValue}');
        _scanBarcode = "Tengo data";
      }

      setState(() {});
      _yelloBox();
      getScanner(text.displayValue,ID,station);

    }catch(e){
      print('El error es : $e');
    }
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
    UsersID = arguments['UsersID'];
    clientID = arguments['clientID'];
    batch_number = arguments['batch_number'];
    ID = arguments['ID'];

    print('lOS ARGUMENTOS SON : $arguments ');
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

                       Container(
                         alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 50),
                          child: Text(
                            'SCAN UTILITY',
                            textAlign:TextAlign.center,
                            style: TextStyle(fontSize: 28,
                                fontFamily: 'Prompt-Italic',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.topLeft,
                      child: Lottie.asset(
                        'assets/json/code3.json',
                        width: 120,

                      ),
                    ),
                    SingleChildScrollView(
                      child: Center(
                        child: Container(
                            width: 300,
                            margin: EdgeInsets.only(top: 150),
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
                  //Teseo
                    onPressed: (){
      Navigator.pushNamed(
      context,
      'scanner',
      arguments: {'batch_number':'$batch_number','ID':'$ID','UsersID':UsersID, 'clientID':clientID},
      );
      },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
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
      return Container(

          alignment: Alignment.topCenter,
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  //Teseo
                    onPressed: (){
      Navigator.pushNamed(
      context,
      'scanner',
      arguments: {'batch_number':'$batch_number','ID':'$ID','UsersID':UsersID, 'clientID':clientID},
      );
      },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    child: Text('SCAN')),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text('Consolidation Group',
                      style: TextStyle(fontSize: 20,
                          color: Colors.white)),
                ),
                _yelloBox(),
              ]));

    }

  }


  //LIST ADRESS
  Widget _listAddress() {
    return FutureBuilder<List<ConsultaBatch>>(
      future: fetchPhotos(http.Client(),UsersID,clientID,ID),
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
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2),),
                    itemBuilder: (BuildContext context, int index) {
                      batchID =snapshot.data[index].ID;

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

                            child: Container(
                              child: Text(
                                '${snapshot.data[index].console_group} \n\n ${snapshot.data[index].station}',
                                textAlign:TextAlign.center,
                                style: TextStyle(color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 33),
                                ),

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
  Widget _yelloBox() {
    return FutureBuilder<List<ConsultaBatch>>(
      future: fetchPhotos(http.Client(),UsersID,clientID,ID),
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
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2),),
                    itemBuilder: (BuildContext context, int index) {
                      batchID =snapshot.data[index].ID;
                      consoleGroup = snapshot.data[index].console_group;
                      station = snapshot.data[index].station;
                      print('WsBenjamin 4 $station');
                      final condition =  _whateverLogicNeeded(consoleGroup,text.displayValue);
                      return condition
                          ?Container(
                        margin: new EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                        decoration: BoxDecoration(
                          // color: const Color(0xff7c94b6),
                          color: Colors.teal,

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

                              '${snapshot.data[index].console_group} \n\n ${snapshot.data[index].station}',
                              textAlign:TextAlign.center,
                              style: TextStyle(color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 33),
                              ),

                            ),

                          ),
                        ),
                      )
                          :Container(
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

                              '${snapshot.data[index].console_group} \n\n ${snapshot.data[index].station}',
                              textAlign:TextAlign.center,
                              style: TextStyle(color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 33),
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
  Widget _update(String UsersID,String clientID , String ID,String console_group,String batchID ) {
    return FutureBuilder<List<ConsultaBatch>>(
      future: updateBatch(http.Client(),UsersID,clientID,ID,console_group,batchID),
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

  bool _whateverLogicNeeded(String console ,String scanner) {
    //
    try{
      scanSelected.add(scanner);
      pref.setStringList('scan', scanSelected);

    }catch(e){

    }

    if(scanSelected.contains(console)){

      print('scaned #### : $scanSelected');
      _update(UsersID, clientID,ID,scanner,batchID);

      print('vali #### true');
      return true;
    }else{

     // barnumber = 1;
     print('vali #### false');
      return false;
    }

  }


  void _dialogFail() {
    EasyDialog(
        closeButton: true,
        width: 280,
        height: 500,
        contentPadding:
        EdgeInsets.only(top: 1.0),
        // Needed for the button design
        contentList: [
          Container(
            child: Lottie.asset(
              'assets/json/fail.json',
              width: 200,
              height: 200,
            ),
          ),
          Container(
            child: Text(
              "Fail!! we not found the station",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.redAccent,),
              textScaleFactor: 2.8,
            ),
          ),
          Container(
            child: Text(
              "\n Scan again or check if information  are correct \n",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
              textScaleFactor: 1.7,
            ),
          ),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.black87),
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ]).show(context);
  }

  void _dialogFailNet() {
    EasyDialog(
        closeButton: true,
        width: 280,
        height: 500,
        contentPadding:
        EdgeInsets.only(top: 1.0),
        // Needed for the button design
        contentList: [
          Container(
            child: Lottie.asset(
              'assets/json/fail.json',
              width: 200,
              height: 200,
            ),
          ),
          Container(
            child: Text(
              "Fail!! SERVER CONNECTION",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.redAccent,),
              textScaleFactor: 2.8,
            ),
          ),
          Container(
            child: Text(
              "\n Scan again or check your Internet Conection \n",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
              textScaleFactor: 1.7,
            ),
          ),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.black87),
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ]).show(context);
  }

  void _dialogSucces(String stationWS) {
    print('WsBenjamin 1 $stationWS');
    var strlen = stationWS.length;
    var operlen = strlen-7;

    var stws = stationWS.substring(0,7);
    var nuws = stationWS.substring(8,strlen);
    print('jolines 1 $strlen');
    print('jolines 2 $stws');
    print('jolines 3 $nuws');
    // insection= false;
    EasyDialog(
        closeButton: true,
        width: 280,
        height: 500,
        contentPadding:
        EdgeInsets.only(top: 1.0), // Needed for the button design
        contentList: [
          Container(
            child: Lottie.asset(
              'assets/json/success2.json',
              width: 200,
              height: 200,
            ),
          ),
          Container(
            child: Text(
              "Success!! we found the station",
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.teal),
              textScaleFactor: 1.2,
            ),
          ),
          Container(
            child: Text(
              "$stws",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
              textScaleFactor: 2.2,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "$nuws",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
              textScaleFactor: 6.2,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.black87),
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ]).show(context);
  }

    Future<List<ConsultaBatch>> getScanner(String scanner, String bitacora, String station) async {
    print('wsbarcode $scanner ande the bitacora $bitacora');
    print('WsBenjamin 1 $station');
    var url = 'http://3.217.149.82/batchjobx/ws/ws_valida_scanner.php?scanner=$scanner&bitacora=$bitacora';
    print(url);
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var scanws = jsonResponse['SCAN'];

      print('wsvalor ### $scanws');
      if(scanws != 'SCAN ERROR'){
         AudioCache player = AudioCache();
        player.play('sounds/beep.mp3');
        print('WsBenjamin 2 $station');
        _dialogSucces(scanws);
      }else{
        _dialogFail();
         AudioCache player = AudioCache();
        player.play('sounds/fail.mp3');

      }

    } else {
      _dialogFailNet();
    }
  }

}