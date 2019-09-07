import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


class DVDisqus extends StatefulWidget {
  final String disqusUri;
  DVDisqus({Key key, @required var this.disqusUri}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DVDisqusState();
}

class DVDisqusState extends State<DVDisqus> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    
    /*return new WebviewScaffold(
      url: widget.disqusUri,
      appBar: new AppBar(
        title: const Text('Réagissez à l\'article'),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
*/
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Réagissez à l\'article'),
      ),
      
      body: WebView(
        initialUrl : widget.disqusUri,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },

      ),

      
    );

  }
  
}

