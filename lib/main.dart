import 'package:demivolee/theme/themes_collection.dart';
import 'package:flutter/material.dart';
import 'page/splash_Screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
//import 'package:demivolee/controllers/cacheController.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'config/ad_settings.dart';
import 'package:provider/provider.dart';
import 'theme/theme_changer.dart';
import 'controllers/sharedController.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() {
  Admob.initialize(ADMOB_APPID);
  FirebaseAdMob.instance.initialize(appId: ADMOB_APPID);
  //CustomCacheManager();

  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    await SharedController.getInstance();
    runApp(DVApp());
  }, onError: Crashlytics.instance.recordError);
}

class DVApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(),
      child: new MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    
    return MaterialApp(
        title: "Demivolée",
        theme: theme.getTheme(),
        darkTheme: DVThemes.DVDarkTheme,
        home: DVSplashScreen(),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
    );
  }
}