import 'package:flutter/material.dart';
import 'page/splashScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'config/ad_settings.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() {
  //FirebaseAdMob.instance.initialize(appId: ADMOB_APPID);
  Admob.initialize(ADMOB_APPID);
  
    runApp(MaterialApp(
        theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xffef5055), //Changing this will change the color of the TabBar
          accentColor: const Color(0x7def5055),
        ),
        home: DVSplashScreen(),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
  ));
}