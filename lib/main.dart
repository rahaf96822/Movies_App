import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviesapp/funcs/fadetranslation.dart';
import 'package:moviesapp/ui/appintro.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/homescreen.dart';
import 'package:moviesapp/ui/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CheckPage(),
  ));
}

bool firstRun;

class CheckPage extends StatefulWidget {
  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {


  Future checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstRun = (prefs.getBool('firstRun') ?? true);
    if(!firstRun){
      Navigator.push(context, new MyCustomRoute(builder: (context) => new SplashScreen()));
    }
    else
      {
        await prefs.setBool('firstRun', false);
        Navigator.push(context, new MyCustomRoute(builder: (context) => new AppIntroScreen()));
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFirstRun();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

