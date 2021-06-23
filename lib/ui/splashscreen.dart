import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moviesapp/funcs/fadetranslation.dart';
import 'package:moviesapp/ui/colors.dart';
import 'package:moviesapp/ui/homescreen.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  void navigationPage(){
    Navigator.push(context, new MyCustomRoute(builder: (context)=> new HomeScreen()
    ));
  }

  startTime() async{
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //startTime();
     startTime();
    //_showNotifi();

  }

  Future _showNotifi() async{
    // var iOSpec = new IOSNotificationDetails();
     var andrSpec = new AndroidNotificationDetails('channelId', 'channelName',
         'channelDescription', importance: Importance.max,
     priority: Priority.high);
     var platformspec = new NotificationDetails(android: andrSpec);
    await flutterLocalNotificationsPlugin.show(
        0,
        'title',
        'body',
        platformspec,
        payload: 'Default_Sound');
    // flutterLocalNotificationsPlugin.zonedSchedule(
    //     0,
    //     'title', 'body',
    //     tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
    //     NotificationDetails(
    //       android: AndroidNotificationDetails(
    //           'channelId', 'channelName', 'channelDescription'
    //       ),
    //     ),
    //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //     androidAllowWhileIdle: true);

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: bgColor,
      body: new Center(
        child: Image.asset("assets/images/movies.png"),
      ),
    );
  }
}
