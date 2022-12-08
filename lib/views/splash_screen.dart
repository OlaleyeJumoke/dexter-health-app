import 'dart:async';

import 'package:dexter_health/constant.dart';
import 'package:dexter_health/views/home.dart';
import 'package:dexter_health/views/register_nurse.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  var _animationReady = Completer();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var _size = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = ColorTween(begin: appColor, end: appColor)
        .animate(controller);
    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 2.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
       Future.microtask(() =>  navigateToHome());
      }
    });
    controller.addListener(() {
      setState(() {});
    });
    Future.microtask(() => navigateToHome());

    initStateAsync();
  }

  void initStateAsync() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _size = 30.0;
      });
      printOnlyInDebug("animation ready");
      _animationReady.complete(true);
    });
  }

  navigateToHome() async {
    var id;
    final SharedPreferences prefs = await _prefs;
    id =  prefs.getString("id");

    if (id == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          ResgisterNurse.id, (Route<dynamic> route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Home.id, (Route<dynamic> route) => false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20),
            Hero(
              tag: "main_logo",
              child: Align(
                child: Container(
                  child: Image.asset(
                    "assets/images/dexter_logo.png",
                    height: 55.0,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
