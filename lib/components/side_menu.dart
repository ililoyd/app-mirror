import 'package:flutter/material.dart';

/*import '../external/prono.dart';
import '../external/compo.dart';
import '../external/compo_expe.dart';*/

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import '../page/home.dart';


class DVSideMenu extends StatelessWidget {

  final _menuTextStyle = TextStyle(fontFamily: "Tw Cen MT", fontWeight: FontWeight.bold, fontSize: 18);
  
  void launchURL(BuildContext context, String link) async {
    try {
      await launch(
        link,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
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

  Widget build(BuildContext context) {
    var urlProno = "https://pronos.demivolee.com";
    var urlCompo = "http://compo.pierrecormier.fr/";

    return new Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
          height: 90.0,

          child :  DrawerHeader(
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
              launchURL(context, urlProno);
              /*Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVProno(),
                ),
              );*/

            },
          ),
          ListTile(
            title: Text('Faites votre composition !', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              launchURL(context, urlCompo);
              /*Navigator.push(
                context, new MaterialPageRoute(
                  builder: (context) => new DVCompo(),
                ),
              );*/
            },
          ),
          /*ListTile(
            title: Text('Heroku composition ! \n(Experimental - chargement long)', style: _menuTextStyle,),
            onTap: () {
              Navigator.of(context).pop();
              launchURL(context, urlCompoExpe);

            },
          ),*/
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