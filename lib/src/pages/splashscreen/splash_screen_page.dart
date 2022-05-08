import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uber_clone_flutter/src/utils/animacion_particulas.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import 'package:uber_clone_flutter/src/utils/navegate.dart';
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}



class _SplashScreenPageState extends State<SplashScreenPage> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), ()=>Navegate.goToWelcome(context));
  }

  @override
  Widget build(BuildContext context) {
    //PERCENTS TO SIZE ASSETS
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Container(
             decoration: BoxDecoration(
               gradient: LinearGradient(
                 begin: Alignment.centerLeft,
                   end: Alignment.bottomRight,
                   colors: [MyColors.primaryOpacityColor,MyColors.primaryColor])
             ),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: const AnimacionParticulas(60)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Image.asset("assets/img/splash_logo.png",
                width: screenWidth * 0.7,height: screenHeight * 0.5)],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const <Widget>[
              // CircularProgressIndicator(
              //   color: Colors.white,
              // ),
              Text("Voitu",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              fontFamily: "Lexendeca-Regular",
              color: Colors.white
            ),
            ),
              SizedBox(height: 6,),
              Text("Auto lavado App v1.0.0",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    fontFamily: "Lexendeca-Regular",
                    color: Colors.white
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 40))
            ],
          )
        ],
      ),
    );
  }

}