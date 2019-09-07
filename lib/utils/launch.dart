import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../config/ad_settings.dart';
import 'dart:async';

class URLController{
  static AdmobInterstitial interstitialAd;
  static String linkAd;
  static bool boolDisplayTimer = true;
  //static BuildContext staticContext;

  static void preloadAd(){
    interstitialAd = AdmobInterstitial(
      adUnitId: ADMOB_InterURLLaunch,
      //targetInfo: targetingInfo,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.loaded){ 
          print("Interstitial Loaded !");
        }
        if (event == AdmobAdEvent.closed){
          URLController.boolDisplayTimer = false;
          print("Interstitial closed");
          new Timer(Duration(minutes: 15), () => URLController.boolDisplayTimer = true);
          interstitialAd.load();
          _launchURL(linkAd);
        }
        if (event == AdmobAdEvent.failedToLoad) {
          print("Error code: ${args['errorCode']}");
        }
      }
    );
    interstitialAd.load();
  }

  static void launchURL(String link) async {
    linkAd = link;
    //staticContext = context;
    
    if( interstitialAd != null){
      if(await interstitialAd.isLoaded && boolDisplayTimer){
        print("IsLoaded");
        interstitialAd.show();
      }else{
        _launchURL(link);
      }
    }else{
      _launchURL(link);
    }
  }

  static  void _launchURL(String link) async {
    print("called !");
    try {
      await launch(
        link,
        option: new CustomTabsOption(
          toolbarColor: const Color(0xffef5055),
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn(),
          // or user defined animation.
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],        
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

}



