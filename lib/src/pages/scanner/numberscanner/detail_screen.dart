import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uber_clone_flutter/src/pages/scanner/numberscanner/detail_screen_controller.dart';

import '../../../models/consultaBatch.dart';
import '../scanner_page.dart';
import 'camera_screen.dart';


Future<List<ConsultaBatch>> updateBatchScan(http.Client client, String UsersID, String clientID, String ID,String barcode, String batchID  ) async {
  print('URL VAR ::   http://3.217.149.82/batchjobx/ws/ws_actualizarBatch.php?UsersID=$UsersID&clientID=$clientID&bitacoraID=$ID&console_group=$barcode&batchID=$batchID&sts=OK');


  final response = await client
      .get(Uri.parse('http://3.217.149.82/batchjobx/ws/ws_actualizarBatch.php?UsersID=$UsersID&clientID=$clientID&bitacoraID=$ID&console_group=$barcode&batchID=$batchID&sts=OK'));

  print(response.body);
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(passUpdateBatch, response.body);
}


class DetailScreen extends StatefulWidget {

  String imagePath;
  List<String> groupConsole;
  String ID;
  String batchID;
  String clientID;
  String UsersID;
  DetailScreen({ this.imagePath ,this.ID ,this.batchID,this.clientID, this.UsersID,this.groupConsole});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DetailScreenController _con = new DetailScreenController();
  String lecturaScanner;
  String _imagePath;
  String ID;
  String  batchID;
  String clientID;
  String UsersID;
  List<String>groupConsole;
  ProgressDialog _progresDialog;
  TextDetector _textDetector;
  int contador = 0;
  Size _imageSize;
  List<TextElement> _elements = [];
  int cuentaRex =0;
  List<String> _listEmailStrings;

  // Fetching the image size from the image file
  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  // To detect the email addresses present in an image
  void _recognizeEmails() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final RecognisedText  text = await _textDetector.processImage(inputImage);

    // Pattern of RegExp for matching a general email address
    String pattern =r"^[0-9]*$";
    //   r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(pattern);

    List<String> emailStrings = [];

    // Finding and storing the text String(s) and the TextElement(s)
    for (TextBlock block in text.blocks) {
      cuentaRex = cuentaRex+1;
      print('tnumeros : $cuentaRex');
      for (TextLine line in block.lines) {
        print('textoEncontrado lineas : ${line.text}');
        if (regEx.hasMatch(line.text)) {
          emailStrings.add(line.text);
          //  var numeroR = emailStrings.
          // print('textoEmails emails : ${line.text}');
          print('textoEmails emails : ${line.text}');
          for (TextElement element in line.elements) {
            print('textoelements elements : ${line.text}');

            _elements.add(element);
            // pref.setStringList('scan', _elements);

          }
        }
      }

    }

    setState(() {
      _listEmailStrings = emailStrings;
      _text(context,_listEmailStrings,ID,clientID,UsersID,batchID);
    });
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    groupConsole =widget.groupConsole;
    ID =widget.ID;
    batchID =widget.batchID;
    clientID=widget.clientID;
    UsersID=widget.UsersID;
    // Initializing the text detector
    _progresDialog = new ProgressDialog();
    _textDetector = GoogleMlKit.vision.textDetector();
    _recognizeEmails();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // Disposing the text detector when not used anymore
    _textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Image Analysis"),
      ),
      body: _imageSize != null
          ? Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.black,
            child: CustomPaint(
              foregroundPainter: TextDetectorPainter(
                _imageSize,
                _elements,
              ),
              child: AspectRatio(
                aspectRatio: _imageSize.aspectRatio,
                child: Image.file(
                  File(_imagePath),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 10,
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.only(top:10,bottom: 70,right: 50,left: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Center(
                        child: Text(
                          "LOG ALGORITM DETECTED FROM IMAGE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Prompt-Italic',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      child: SingleChildScrollView(
                        child: _listEmailStrings != null
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _listEmailStrings.length,
                          itemBuilder: (context, index) =>
                          // _text(context,_listEmailStrings[index],index),
                          Container(

                              child: Text(
                                _listEmailStrings[index],
                                style: TextStyle(
                                  color: Colors.lightGreen,
                                  fontSize: 17,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                          ),
                        )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }


  Widget _text(BuildContext context, List<String> _lista, String batch, String clientID, String UsersID, String batchID){
    print('WsAbdiel valor númerico de la lista :{  } valor contenido de la lista : { $_lista }');
    print('WsAbdiel selectedScanned previus : { $groupConsole }');
    bool encuentra = false;
    for(var i = 0; i < _lista.length; i++){

      print('lista tamaño $contador');
      if (groupConsole.contains(_lista[i])) {
        AudioCache player = AudioCache();
        player.play('sounds/beep.mp3');

        encuentra = true;
        print('wsbarcode 3w3 $_lista[i]');
        getScanner(context,_lista[i],batch,clientID,UsersID,batchID);

        groupConsole.clear();
        return Text('LA LISTA : $_lista');
      }else{
        groupConsole.clear();
        AudioCache player = AudioCache();
        player.play('sounds/fail.mp3');
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

                    // Navigator.pushNamed(
                    //   context,
                    //   'scanner',
                    //   arguments: {
                    //     'ID':batch, 'UsersID':UsersID, 'clientID':clientID,
                    //   },
                    // );
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

    }
    if(encuentra==false){
      groupConsole.clear();
      AudioCache player = AudioCache();
      player.play('sounds/fail.mp3');
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

                  // Navigator.pushNamed(
                  //   context,
                  //   'scanner',
                  //   arguments: {
                  //     'ID':batch, 'UsersID':UsersID, 'clientID':clientID,
                  //   },
                  // );
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


  }

  void refresh() {
    setState(() {});
  }
}

//LIST ADRESS
Widget _update(String UsersID,String clientID , String ID,String console_group,String batchID ) {
  return FutureBuilder<List<ConsultaBatch>>(
    future: updateBatchScan(http.Client(),UsersID,clientID,ID,console_group,batchID),
    builder: (context, snapshot) {

      if (snapshot.hasError) {
        print('URL VARSS');
        return const Center(
          child: Text('An error has occurred!'),
        );
      } else if (snapshot.hasData) {
        print('URL VAR 2');
        return Container();

      } else {
        print('URL VAR 3');
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

Future<List<ConsultaBatch>> getScanner(context,String scanner, String bitacora, String clientID, String UsersID, String batchID ) async {
  print('wsbarcode 333-');
  print('wsbarcode $scanner ande the bitacora $bitacora');
  // print('WsAbdiel 1 $station');
  var url = 'http://3.217.149.82/batchjobx/ws/ws_valida_scanner.php?scanner=$scanner&bitacora=$bitacora';
  print(url);
  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    print('wsbarcode 333-6');
    var jsonResponse = convert.jsonDecode(response.body);
    var scanws = jsonResponse['SCAN'];
    var sts = jsonResponse['STS'];

    if(sts!= 'OK'){
      sts = 'Dont Updated';
    }else{
      sts = 'Already updated';
    }
    var console = jsonResponse['CONSOLE'];
    var strlen = scanws.length;
    var operlen = strlen-7;

    var stws = scanws.substring(0,7);
    var nuws = scanws.substring(8,strlen);
    print('HYUYY ### $scanws');
    print('HYUYY ### $sts');
    print('HYUYY ### $console');
    if(scanws != 'SCAN ERROR'){

      print('WsAbdiel 333-66');
      _update(UsersID,clientID,bitacora,scanner,batchID);
      // AudioCache player = AudioCache();
      // player.play('sounds/beep.mp3');
      // print('WsAbdiel 2 $station');
      //  _dialogSucces(scanws);
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
                "CONSOLO GROUP:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                textScaleFactor: 2.2,
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  "$console",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  textScaleFactor: 2.2,
                ),
              ),
            ),
            Container(
              child: Text(
                "STATUS: $sts",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
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
                  // Navigator.of(context).pop();
                  //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  //      ExamplePage()), (Route<dynamic> route) => false);

                  // Navigator.pushAndRemoveUntil<void>(
                  //   context,
                  //   MaterialPageRoute<void>(builder: (BuildContext context) => ExamplePage()),
                  //   ModalRoute.withName('scanner',),
                  // );
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
      console = '';

    }else{
      print('WsAbdiel 333-666-');


    }

  } else {
    AudioCache player = AudioCache();
    player.play('sounds/fail.mp3');
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

                // Navigator.pushNamed(
                //   context,
                //   'scanner',
                //   arguments: {
                //     'ID':batch, 'UsersID':UsersID, 'clientID':clientID,
                //   },
                // );
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




}





// Helps in painting the bounding boxes around the recognized
// email addresses in the picture
class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextElement container) {
      return Rect.fromLTRB(
        container.rect.left * scaleX,
        container.rect.top * scaleY,
        container.rect.right * scaleX,
        container.rect.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.yellowAccent
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}