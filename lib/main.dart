import 'package:flutter/material.dart';
import 'page/splashScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
//import 'package:demivolee/controllers/cacheController.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'config/ad_settings.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() {
  Admob.initialize(ADMOB_APPID);
  FirebaseAdMob.instance.initialize(appId: ADMOB_APPID);
  //CustomCacheManager();

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
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
  }, onError: Crashlytics.instance.recordError);
}