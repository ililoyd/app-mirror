import 'package:flutter/material.dart';
import 'page/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'config/ad_settings.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() {
  FirebaseAdMob.instance.initialize(appId: ADMOB_APPID);

  
    print("Loaded");
    runApp(MaterialApp(
        theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xffef5055), //Changing this will change the color of the TabBar
          accentColor: const Color(0x7def5055),
        ),
        home: DVHome(isStartup: true),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
  ));
}