import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demivolee/theme/theme_changer.dart';
import 'package:demivolee/utils/link_span.dart';
import 'package:demivolee/utils/launch.dart';

import 'package:package_info/package_info.dart';



class DVSettings extends StatelessWidget {

  DVSettings();

  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: new AppBar(
        title: const Text('Paramètres de l\'application'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: 
          Column(children: <Widget>[
            Row(
              children: [RichText(
                text: TextSpan(
                style: new TextStyle(fontFamily: "Materiallcons", fontSize: 15, color: Theme.of(context).textTheme.body1.color),
                children: <TextSpan>[
                  TextSpan(text : "Mode jour / nuit :", style: TextStyle(fontWeight: FontWeight.bold)),
                ]),)],
            ),

            RaisedButton(
                color: ( _themeChanger.isDark() ) ? Theme.of(context).primaryColor :  Colors.white ,
                highlightColor:  Theme.of(context).primaryColor ,
                hoverColor:  Theme.of(context).primaryColor,

                shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(10.0)),
                child: Text((  _themeChanger.isDark() ) ? "Utiliser le mode jour" : 'Utiliser le mode nuit'),

                onPressed: () => _themeChanger.toogletheme()),

            Row(
              children: [RichText(
                text: TextSpan(
                style: new TextStyle(fontFamily: "Materiallcons", fontSize: 15, color: Theme.of(context).textTheme.body1.color),
                children: <TextSpan>[
                  TextSpan(text : "\nAfficher plus d'options :", style: TextStyle(fontWeight: FontWeight.bold)),
                ]),)],
            ),

            RaisedButton(
                disabledColor: ( _themeChanger.isDark() ) ? Colors.grey[600] : Colors.grey[300],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text("En construction"),
                onPressed: null,
                ),
            Row(
              children : [Expanded(child: Divider(
                                            color: ( _themeChanger.isDark() ) ? Colors.grey[100] : Colors.grey,
                                            height: 36,))],
            ),
            RichText(text: TextSpan(
              style: new TextStyle(fontFamily: "Materiallcons", fontSize: 15, color: Theme.of(context).textTheme.body1.color),
              children: <TextSpan>[
                TextSpan(text: "Application réalisée par "),
                LinkTextSpan(text:"@betse_DV",
                            url: "https://twitter.com/betse_DV",
                            style: linkStyle,
                            onLinkTap: (link){URLController.launchURL(link);},), 
                TextSpan(text: " pour "),
                LinkTextSpan(text: "demivolee.com",
                            url: "https://www.demivolee.com/",
                            style: linkStyle,
                            onLinkTap: (link){URLController.launchURL(link);},),
                TextSpan(text: ".\nAvec la contribution graphique de "),
                LinkTextSpan(text: "Julien K",
                            url: "https://www.instagram.com/julien_kozlowski/", 
                            style: linkStyle,
                            onLinkTap: (link){URLController.launchURL(link);},
                            ),
                TextSpan(text: ".\n\n\nTous droit réservés. ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Les contenus sont la propriété intellectuelle de demivolee.com. L'application et ses contenus graphiques sont la propriété de leurs créateurs."),
                TextSpan(text:"\n\n\nL'application ne stocke pas de données personnelles. ",
                    style: TextStyle(fontSize:12)),
                
              ])
            ,),
              FutureBuilder(
                future: getVersionNumber(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if(snapshot.hasData){
                    return Row(
                    children: [RichText(
                    text: TextSpan(
                    style: new TextStyle(fontFamily: "Materiallcons", fontSize: 15, color: Theme.of(context).textTheme.body1.color),
                    children: <TextSpan>[
                      TextSpan(text: "\nVersion ${snapshot.data}. Publication 01-2020. \n\n\n\n\n\n", style: TextStyle(fontSize:12)),
                    ])
                    )]);
                  }
                  return Text("Chargement des informations....", style: TextStyle(fontFamily: "Materiallcons", color: Theme.of(context).textTheme.body1.color, fontSize:12));
                }),
          ]
          ,)

       ),
    );
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    return version;
  }
}