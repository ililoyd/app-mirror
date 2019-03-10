import 'package:flutter/material.dart';

import '../config/ad_settings.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'home.dart';
import '../utils/launch.dart';
import 'dart:async';
import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';

class DVSplashScreen extends StatefulWidget {
  DVSplashScreen({Key key})  : super(key: key);

  @override
  State<StatefulWidget> createState() => DVStateSplashScreen();
}
class DVStateSplashScreen extends State<DVSplashScreen> {
  AdmobInterstitial homeInterstitialAd;
  InterstitialAd homeInterstitialAd2;

  @override
  void initState() {
    startApp(context);
    super.initState();
  }

  void _listener(AdmobAdEvent event, Map<String, dynamic> args){

        if (event == AdmobAdEvent.loaded){ 
          print("Loaded !");
          this.homeInterstitialAd.show();
          URLController.boolDisplayTimer = false;
          new Timer(Duration(minutes: 15), () => URLController.boolDisplayTimer = true);
          Navigator.pushReplacement(
            context, new MaterialPageRoute(
              builder: (context) => new DVHome(),
            ),              
          );
        }
        if (event == AdmobAdEvent.closed){
          print("Ad Closed");
          this.homeInterstitialAd.dispose();
        }
        if (event == AdmobAdEvent.failedToLoad) {
          print("Error code: ${args['errorCode']}");
          Navigator.pushReplacement(
            context, new MaterialPageRoute(
              builder: (context) => new DVHome(),
            ),              
          );
        }
      
  }

  void _listener2(MobileAdEvent event){

      if (event == MobileAdEvent.loaded){ 
        print("Loaded !");
        this.homeInterstitialAd2.show();
        URLController.boolDisplayTimer = false;
        new Timer(Duration(minutes: 15), () => URLController.boolDisplayTimer = true);
        Navigator.pushReplacement(
          context, new MaterialPageRoute(
            builder: (context) => new DVHome(),
          ),              
        );
      }
      if (event == MobileAdEvent.closed){
        print("Ad Closed");
        this.homeInterstitialAd2.dispose();
      }
      if (event == MobileAdEvent.failedToLoad) {
        Navigator.pushReplacement(
          context, new MaterialPageRoute(
            builder: (context) => new DVHome(),
          ),              
        );
      }
    
}
  
  void startApp(BuildContext context) async {
    this.homeInterstitialAd = AdmobInterstitial(
      adUnitId: ADMOB_InterStartup,
      targetInfo: targetingInfo,
      listener: this._listener
    );

    this.homeInterstitialAd2 = InterstitialAd(
      adUnitId: ADMOB_InterStartup,
      targetingInfo: targetingInfo2,
      listener: this._listener2
    );

    

    this.homeInterstitialAd2.load();

  }

 
  Widget build(BuildContext context) {
  double splashHeight = 1/8 * MediaQuery.of(context).size.height;
  var rng = new Random();
  int pickedSplash = rng.nextInt(3);


    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50.0),
                      ),
                      Container(child: 
                        Text(
                          "Bienvenue sur Demivolee",
                          style: TextStyle(
                            fontFamily: "Bebas Neue",
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                            fontSize: 30.0),
                        ),
                      ),
                       Padding(
                        padding: EdgeInsets.only(top: splashHeight),
                      ),
                      Expanded(
                        child : Image.asset("assets/Splash-fond_"+ pickedSplash.toString() +".png"),      
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}