import 'package:flutter/material.dart';


class DVSettings extends StatelessWidget {

  DVSettings();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Paramètres de l\'application'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: RichText(text: TextSpan(
          style: new TextStyle(fontFamily: "Materiallcons", fontSize: 15, color: Colors.black),
          children: <TextSpan>[
             TextSpan(text: "Application réalisée par Data & Dev (@betse_DV) pour "), 
             TextSpan(text: "demivolee.com"),
             TextSpan(text: " avec la contribution graphique de Julien K. ("),
             TextSpan(text: "@PrinceOwski"),
             TextSpan(text: "). \n\n\nTout droit réservés.", style: TextStyle(fontWeight: FontWeight.bold)),
             TextSpan(text:"\n\n\nL'application ne stocke pas de données personnelles et respecte la RGPD concernant la collection de données par des services tiers.",
                style: TextStyle(fontSize:12)),
          ])
        ,)
       ),
    );
  }
}