import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
//import 'dart:async';


class DVDisqus extends StatefulWidget {
  final String disqusUri;
  DVDisqus({Key key, @required var this.disqusUri}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DVDisqusState();
}

class DVDisqusState extends State<DVDisqus> {
  //final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: new AppBar(
        title: const Text('Réagissez à l\'article'),
      ),
      
      body: Container()
      
      /*WebView(
        initialUrl : widget.disqusUri,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),*/
    );

  }
}

