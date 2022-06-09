import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../../models/consultaBatch.dart';
import '../scanner_page.dart';
import 'camera_screen.dart';



class DetailScreen extends StatefulWidget {
  final String imagePath;

  const DetailScreen({ this.imagePath});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
   String _imagePath;
   TextDetector _textDetector;
  Size _imageSize;
  List<TextElement> _elements = [];

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
      for (TextLine line in block.lines) {
        print('textoEncontrado lineas : ${line.text}');
        if (regEx.hasMatch(line.text)) {
          emailStrings.add(line.text);

          print('textoEmails emails : ${line.text}');
          for (TextElement element in line.elements) {
            print('textoelements elements : ${line.text}');
            _text(context,line.text);
            _elements.add(element);
           // pref.setStringList('scan', _elements);

          }
        }
      }
    }

    setState(() {
      _listEmailStrings = emailStrings;
    });
  }

  @override
  void initState() {
    _imagePath = widget.imagePath;
    // Initializing the text detector
    _textDetector = GoogleMlKit.vision.textDetector();
    _recognizeEmails();
    super.initState();
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
        title: Text("Image Details"),
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
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "LOG ALGORITM DETECTED FROM IMAGE",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: SingleChildScrollView(
                        child: _listEmailStrings != null
                            ? ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _listEmailStrings.length,
                          itemBuilder: (context, index) =>
                          // _text(context,_listEmailStrings[index],index),
                              Text(_listEmailStrings[index]

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

   Widget _text(BuildContext context, String _lista){
     print('WsAbdiel valor númerico de la lista :{  } valor contenido de la lista : { $_lista }');
     if(_lista == "4000888164"){
     //  print('WsAbdiel valido $station');
       getScanner(context,"4000888164","2","5");
       return Text("400888164");

     }else{
       //return Text("NULL");
     }

   }
}

Future<List<ConsultaBatch>> getScanner(context,String scanner, String bitacora, String station) async {
  print('wsbarcode $scanner ande the bitacora $bitacora');
  print('WsAbdiel 1 $station');
  var url = 'http://3.217.149.82/batchjobx/ws/ws_valida_scanner.php?scanner=$scanner&bitacora=$bitacora';
  print(url);
  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var scanws = jsonResponse['SCAN'];

    print('WsAbdiel ### $scanws');
    if(scanws != 'SCAN ERROR'){
     // AudioCache player = AudioCache();
     // player.play('sounds/beep.mp3');
      print('WsAbdiel 2 $station');
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
                "$station",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                textScaleFactor: 2.2,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "$station",
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

                  Navigator.pushAndRemoveUntil<void>(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => ExamplePage()),
                    ModalRoute.withName('scanner',),
                  );
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.black87),
                  textScaleFactor: 1.3,
                ),
              ),
            ),
          ]).show(context);

    }else{
      // _dialogFail();
      // AudioCache player = AudioCache();
      // player.play('sounds/fail.mp3');

    }

  } else {
   // _dialogFailNet();
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
      ..color = Colors.red
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