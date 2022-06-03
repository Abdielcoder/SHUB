import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/multi_tween/multi_tween.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uber_clone_flutter/src/utils/my_colors.dart';
import '../../models/response_api.dart';
import '../../models/user.dart';
import '../../utils/my_snackbar.dart';
import '../../utils/shared_pref.dart';

import 'loggin_controller.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  //
  int _pageState = 1;

  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB40284A);
  double _headingTop = 100;
  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;
  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;
  double windowWidth = 0;
  double windowHeight = 0;
  bool _keyboardVisible = false;
  bool  _passwordVisible;
//


  // PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
  // UsersProvider usersProvider = new UsersProvider();
  ProgressDialog _progressDialog;
  LoginController _con = new LoginController();
  SharedPref _sharedPref = new SharedPref();
  //GENERETED ALEATORI ID SESSION.

  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });

  }


  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;

    switch (_pageState) {
      case 0:
        _backgroundColor = Colors.white;
        _headingColor = Color(0xFFB40284A);

        _headingTop = 100;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 1:
        _backgroundColor = Color(0xFFB40284A);
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 270;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 2:
        _backgroundColor = Color(0xFFB40284A);
        _headingColor = Colors.white;

        _headingTop = 80;

        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 30 : 240;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _loginXOffset = 20;
        _registerYOffset = _keyboardVisible ? 55 : 270;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
              width: double.infinity,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                    MyColors.colorAqua,
                    MyColors.primaryColor,
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 50.0,
                        ),
                        FadeAnimation(
                            1,
                            // Text(
                            //   "Login & Sign Up Screen",
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 30,
                            //       fontWeight: FontWeight.w700,
                            //       fontFamily: "Sofia"),
                            // )
                        Image.asset('assets/img/login_art.png',
                        width: 240,
                        height: 240,)
                        ),

                      ],
                    ),
                  ),
                ],
              )),
          AnimatedContainer(
            margin: EdgeInsets.only(top:20),
            padding: EdgeInsets.only(top: 70,left: 32,right: 32,bottom: 32),
            width: _loginWidth,
            height: _loginHeight,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform:
            Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60))),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    FadeAnimation(
                        1.4,
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(32, 132, 232, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200))),
                                child: TextField(
                                  controller: _con.emailController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                      ),
                                      hintText: "Correo o telefono",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "Sofia"),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200))),
                                child: TextField(
                                  obscureText: !_passwordVisible,
                                  controller: _con.passwordController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.vpn_key),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                      hintText: "Contraseña",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "Sofia"),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('forget working working');
                      },
                      child: Container(
                        child: FadeAnimation(
                            1.5,
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: "Sofia"),
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      1.6,
                      FlatButton(
                        onPressed: _con.login,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: MyColors.primaryColor),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // FadeAnimation(
                    //     1.7,
                    //     Text(
                    //       "Continua con login social & OTP",
                    //       style: TextStyle(
                    //           color: Colors.grey, fontFamily: "Sofia"),
                    //     )),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //       child: FadeAnimation(
                    //           1.8,
                    //           Container(
                    //               child: MaterialButton(
                    //                 onPressed: () {},
                    //                 color: Color(0xFF3b5998),
                    //                 textColor: Colors.white,
                    //                 child: Icon(
                    //                   FontAwesomeIcons.facebookF,
                    //                   size: 22,
                    //                 ),
                    //                 padding: EdgeInsets.all(16),
                    //                 shape: CircleBorder(),
                    //               ))),
                    //     ),
                    //     // SizedBox(width: 10,),
                    //     Container(
                    //       child: FadeAnimation(
                    //           1.9,
                    //           Container(
                    //               child: MaterialButton(
                    //                 onPressed: () {},
                    //                 color: Color(0xFFEA4335),
                    //                 textColor: Colors.white,
                    //                 child: Icon(
                    //                   FontAwesomeIcons.google,
                    //                   size: 22,
                    //                 ),
                    //                 padding: EdgeInsets.all(16),
                    //                 shape: CircleBorder(),
                    //               ))),
                    //     ),
                    //     Container(
                    //       child: FadeAnimation(
                    //           1.9,
                    //           Container(
                    //               child: MaterialButton(
                    //                 onPressed: () {},
                    //                 color: Color(0xFF34A853),
                    //                 textColor: Colors.white,
                    //                 child: Icon(
                    //                   FontAwesomeIcons.mobileAlt,
                    //                   size: 22,
                    //                 ),
                    //                 padding: EdgeInsets.all(16),
                    //                 shape: CircleBorder(),
                    //               ))),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        print('sign up working');
                        setState(() {
                          _pageState = 2;
                        });
                      },
                      child: Container(
                        child: FadeAnimation(
                            1.5,
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Power By Bitlabs Systems ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Sofia"),
                                  ),
                                  Text(
                                    "© copyright 2022",
                                    style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.bold),
                                  )
                                ])),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class InputWithIcon extends StatefulWidget {
  final IconData icon;
  final String hint;
  InputWithIcon({this.icon,this.hint});

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF000000), width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(fontFamily: "Sofia"),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: widget.hint),
            ),
          )
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final String btnText;
  PrimaryButton({this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFB40284A), borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFB40284A), width: 2),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          widget.btnText,
          style: TextStyle(color: Color(0xFFB40284A), fontSize: 16),
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
