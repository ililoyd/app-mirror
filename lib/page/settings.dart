import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demivolee/theme/theme_changer.dart';


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
            RaisedButton(
                color: ( _themeChanger.isDark() ) ? Theme.of(context).primaryColor :  Colors.white ,
                highlightColor:  Theme.of(context).primaryColor ,
                hoverColor:  Theme.of(context).primaryColor,

                shape: RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(10.0)),
                child: Text((  _themeChanger.isDark() ) ? "Utiliser le mode jour" : 'Utiliser le mode nuit'),

                onPressed: () => _themeChanger.toogletheme()),
        
            RichText(text: TextSpan(
              style: new TextStyle(fontFamily: "Materiallcons", fontSize: 15, color: Theme.of(context).textTheme.body1.color),
              children: <TextSpan>[
                TextSpan(text: "\n\n\nPlaceholder --- Placeholder --- Placeholder --- Placeholder.\nBeta version interne, ne pas publier.\n\n\n\n\n"), 
                TextSpan(text: "Application réalisée par Data & Dev (@betse_DV) pour "), 
                TextSpan(text: "demivolee.com"),
                TextSpan(text: " avec la contribution graphique de Julien K. ("),
                TextSpan(text: "@PrinceOwski"),
                TextSpan(text: "). \n\n\nTout droit réservés. ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Les contenus sont la propriété intellectuelle de demivolee.com. L'application et ses contenus graphiques sont la propriété de leurs créateurs."),
                TextSpan(text:"\n\n\nL'application ne stocke pas de données personnelles et respecte la RGPD concernant la collection de données par des services tiers.",
                    style: TextStyle(fontSize:12)),
              ])
            ,)
          ]
          ,)

       ),
    );
  }
}