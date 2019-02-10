import 'package:flutter/material.dart';

import '../config/ad_settings.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'home.dart';

class DVSplashScreen extends StatefulWidget {
  DVSplashScreen({Key key})  : super(key: key);

  @override
  State<StatefulWidget> createState() => DVStateSplashScreen();
}
class DVStateSplashScreen extends State<DVSplashScreen> {
  AdmobInterstitial homeInterstitialAd;

  @override
  void initState() {
    startApp(context);
    super.initState();
  }
  
  void startApp(BuildContext context) async {
    this.homeInterstitialAd = AdmobInterstitial(
      adUnitId: ADMOB_InterStartup,
      targetInfo: targetingInfo,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.loaded){ 
          print("Loaded !");
          this.homeInterstitialAd.show();
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
    );
    this.homeInterstitialAd.load();
  }

 
  Widget build(BuildContext context) {
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
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Bienvenue sur Demivolee",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
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
                    CircularProgressIndicator(),
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