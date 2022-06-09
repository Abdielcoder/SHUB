import 'dart:convert';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/consultaBatch.dart';
import 'detail_screen.dart';

var UsersID;
var clientID;
var ID;
var batch_number;
var batchID;
var consoleGroup;
var station;
List<String> scanSelected = [];
SharedPreferences pref;

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



// Future<void> main() async {
//   runApp(
//     MaterialApp(
//       title: 'Camera Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ExamplePage(),
//     ),
//   );
// }
class ExamplePage extends StatefulWidget {
  static Future init() async {
    pref = await SharedPreferences.getInstance();

  }

  @override
  State<StatefulWidget> createState() => ExamplePageState();
}

class ExamplePageState extends State<ExamplePage> {
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

  ////////

  @override
  void initState() {
    super.initState();

    _initCamera();
  }

  ////
  @override
  void dispose() {
    // dispose the camera controller when navigated
    // to a different page
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute
        .of(context)
        ?.settings
        .arguments ?? <String, dynamic>{}) as Map;
    print('Los elementos son : $arguments');
    print(arguments['batch_number']);
    print(arguments['ID']);
    UsersID = arguments['UsersID'];
    clientID = arguments['clientID'];
    batch_number = arguments['batch_number'];
    ID = arguments['ID'];

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
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 40),
                            child: Text(
                              'SCAN UTILITY',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 28,
                                  fontFamily: 'Prompt-Italic',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          alignment: Alignment.topCenter,
                          child: Lottie.asset(
                            'assets/json/code3.json',
                            width: 120,

                          ),
                        ),
                        Container(
                            width: 500,
                            height: 300,
                            child: _cameraPreview()),
                        Container
                          (
                            margin: EdgeInsets.only(top: 30),
                            child: _button()),
                        Center(
                          child: Container(
                              height:150,
                              margin: EdgeInsets.only(top: 0),
                              child: Visibility(
                                  visible: true,
                                  child: _listAddress())
                          ),
                        ),
                        // ),

                      ],
                    )
                  // ))
                  //   ),
                )
            )
        )
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    if (cameras.length >= 0) {
      cameraController = CameraController(cameras.first, ResolutionPreset.max);
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          initialized = true;
        });
      });
    }
  }


  //LIST ADRESS
  Widget _listAddress() {
    return FutureBuilder<List<ConsultaBatch>>(
      future: fetchPhotos(http.Client(), UsersID, clientID, ID),
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
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,
                      childAspectRatio: MediaQuery
                          .of(context)
                          .size
                          .width /
                          (MediaQuery
                              .of(context)
                              .size
                              .height / 15),),
                    itemBuilder: (BuildContext context, int index) {
                      batchID = snapshot.data[index].ID;
                      var consoleg = snapshot.data[index].console_group;
                      print('WsAbdiel valor camera1 : $consoleg');
                      scanSelected.add(consoleg);
                      //print('WsAbdiel camera2 : $scanSelected');

                      return Container(
                        margin: new EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          // color: const Color(0xff7c94b6),
                          color: Colors.black,

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   'scanner',
                              //   arguments: {'batch_number':'${snapshot.data[index].batch_number}','ID':'${snapshot.data[index].ID}'},
                              // );
                            },

                            child: Container(
                              child: Text(
                                ' ð Console Group :${snapshot.data[index]
                                    .console_group} / ${snapshot.data[index]
                                    .station}',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.lightGreen,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .width /
                                      (MediaQuery
                                          .of(context)
                                          .size
                                          .height / 33),
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

  Widget _button() {
    print("############");
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(120),
        child: Container(
          color: Colors.black,
          child: IconButton(
            iconSize: 60,
            icon: Icon(Icons.camera_alt),
            color: Colors.white,
            onPressed: () async {
              // If the returned path is not null navigate
              // to the DetailScreen
              await _takePicture().then((String path) {
                print("############" + path);
                if (path != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(
                            imagePath: path,
                            groupConsole: scanSelected,
                          ),
                    ),
                  );
                } else {
                  print('Image path not found!');
                }
              });
            },
/////
          ),
        ),
      ),
    );
  }

  Widget _cameraPreview() {
    if (initialized) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 82),
        child: _CroppedCameraPreview(
          cameraController: cameraController,
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
/*Widget _cameraPreview() {
    if (initialized) {
      return AspectRatio(
        aspectRatio: 1,
        child: ClipRect(
          child: Transform.scale(
            scale: cameraController.value.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1 / cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }*/

}
////////////
class _CroppedCameraPreview extends StatelessWidget {
  const _CroppedCameraPreview({
     this.cameraController,
  });

  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          ClipRect(
            child: Transform.scale(
              scale: cameraController.value.aspectRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1 / cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
              ),
            ),
          ),
          Container(
            decoration: ShapeDecoration(
              shape: CardScannerOverlayShape(
                borderColor: Colors.yellow,
                borderRadius: 12,
                borderLength: 32,
                borderWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
////////////
// クレカ標準の比
const _CARD_ASPECT_RATIO = 1 / 9;
// 横の枠線marginを決める時用のfactor
// 横幅の5%のサイズのmarginをとる
const _OFFSET_X_FACTOR = 0.05;

class CardScannerOverlayShape extends ShapeBorder {
  const CardScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 8.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 12,
    this.borderLength = 32,
    this.cutOutBottomOffset = 0,
  });

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutBottomOffset;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    final offsetX = rect.width * _OFFSET_X_FACTOR;
    final cardWidth = rect.width - offsetX * 2;
    final cardHeight = cardWidth * _CARD_ASPECT_RATIO;
    final offsetY = (rect.height - cardHeight) / 2;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + offsetX,
      rect.top + offsetY,
      cardWidth,
      cardHeight,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
    // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + borderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + borderLength,
          cutOutRect.top + borderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - borderLength,
          cutOutRect.bottom - borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - borderLength,
          cutOutRect.left + borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return CardScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
