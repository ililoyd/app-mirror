import 'package:flutter/material.dart';

/*import '../external/prono.dart';
import '../external/compo.dart';
import '../external/compo_expe.dart';*/

import '../page/home.dart';
import '../utils/launch.dart';


class DVSideMenu extends StatelessWidget {
  final interstitialAd;

  DVSideMenu({this.interstitialAd});

  final _menuTextStyle = TextStyle(fontFamily: "Tw Cen MT", fontWeight: FontWeight.bold, fontSize: 18);

  Widget build(BuildContext context) {
    URLController.preloadAd();
    var urlProno = "https://pronos.demivolee.com";
    var urlCompo = "http://compo.pierrecormier.fr/";

    return new Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 90.0,
            child :  
              DrawerHeader(
                child: Row(
                  children: <Widget> [
                    /*Container(
                      child : Text('Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Tw Cen MT", fontSize: 22))
                    ),*/
                    Expanded(
                      child : Image.asset(
                      //'assets/logo.jpg',
                        //'assets/title.png',
                        'assets/title-v2.png',
                        fit: BoxFit.contain,
                        height: 40,
                        ),
                      //alignment: Alignment.bottomRight,
                    ),
                  ]
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffef5055),
                  //color: Colors.blueAccent,
                ),
              ),
          ),
          ListTile(
            title: Text('Participez aux pronos DV', style: _menuTextStyle,),
            onTap: () { 
              Navigator.of(context).pop();
              URLController.launchURL(urlProno);
            },
          ),
          ListTile(
            title: Text('Faites votre composition !', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              URLController.launchURL(urlCompo);
            },
          ),
          new Divider(color: Colors.black,),
          ListTile(
            title: Text('Dossiers Demivolee', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVHome(queryAPI: "posts?categories=40"),
                ),              
              );
            },
          ),
          /*Container(
          color: Colors.grey[350],
          child:
            ListTile(
              title: Text('Billets d\'humeur'),
              onTap: () {
                //Navigator.of(context).pop();
                //launchURL(context, urlCompoExpe);
              },
        ),
          ),*/
          ListTile(
            title: Text('Contributions', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVHome(queryAPI: "posts?categories=23"),
                ),              
              );
            },
          ),
          ListTile(
            title: Text('Ligue 1', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVHome(queryAPI: "posts?categories=5"),
                ),              
              );
            },
          ),
          ListTile(
            title: Text('Autres Championnats', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVHome(queryAPI: "posts?categories=46"),
                ),              
              );
            },
          ),
          ListTile(
            title: Text('Coupes d\'Europe', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVHome(queryAPI: "posts?categories=45"),
                ),              
              );
            },
          ),
          ListTile(
            title: Text('Football des nations', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVHome(queryAPI: "posts?categories=129"),
                ),              
              );
            },
          ),
          ListTile(
            title: Text('Paramètres', style: _menuTextStyle,),
            leading: new Icon(Icons.settings),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}