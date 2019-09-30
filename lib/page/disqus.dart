import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';




class DVDisqus extends StatefulWidget {
  final String disqusUri;
  DVDisqus({Key key, @required var this.disqusUri}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DVDisqusState();
}

class DVDisqusState extends State<DVDisqus> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controller;

  //InAppWebViewController webView;
    String url = "";
    double progress = 0;

  final CookieManager cookieManager = CookieManager();

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
      withJavascript: true,
      supportMultipleWindows: true,
      withOverviewMode: true,
    
    );*/
    
    var idPost = widget.disqusUri.substring(47);
    var shortName = "lyon-sc";
    print(widget.disqusUri);
    print(idPost);
    String htmlBase = "<html><head></head><body><div id='disqus_thread'></div></body>"
        + "<meta name= \"viewport\" content=\"width=device-width, initial-scale=1\">"
        + "<script type='text/javascript'>"
        + "var disqus_identifier = '"
        + idPost
        + "';"
        + "var disqus_shortname = '"
        + shortName
        + "';"
        + " (function() { var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;"
        + "dsq.src = 'https://sc-lyon.disqus.com/embed.js';"
        + "(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq); })();"
        + "</script></html>";
      
    print(htmlBase);
    
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Réagissez à l\'article'),
      ),
      body: WebView( 
        initialUrl: new Uri.dataFromString( htmlBase, mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          controller = webViewController;
        },
        onPageFinished: (String url){
          if (url.indexOf("disqus.com/next/login-success") > -1
              ||
              url.indexOf("disqus.com/_ax/facebook/complete") > -1
              ||
              url.indexOf("disqus.com/_ax/google/complete") > -1
              ||
              url.indexOf("disqus.com/_ax/twitter/complete") > -1
              ){
            print("\n\n\n\n\n\n");
            print(cookieManager.getCookies());    
            Future.delayed(const Duration(seconds: 2), (){
              //controller.goBack();
              controller.loadUrl(widget.disqusUri);
              
            });
          }
          
        },
      )
      
    );

    
    /*return Scaffold(
      appBar: new AppBar(
        title: const Text('Réagissez à l\'article'),
      ),
      
      body: WebView(
        initialUrl : widget.disqusUri,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          controller = webViewController;
        },
        onPageFinished: (String url){
          if (url.indexOf("disqus.com/next/login-success") > -1
              ||
              url.indexOf("disqus.com/_ax/facebook/complete") > -1
              ||
              url.indexOf("disqus.com/_ax/google/complete") > -1
              ||
              url.indexOf("disqus.com/_ax/twitter/complete") > -1
              ){
            Future.delayed(const Duration(seconds: 2), (){
              //controller.goBack();
              controller.loadUrl(widget.disqusUri);
              
            });
          }       
        },
      ),
    );*/

    

    /*
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Réagissez à l\'article'),
      ),
      
      body: InAppWebView(
        initialUrl : new Uri.dataFromString( htmlBase, mimeType: 'text/html').toString(),
        initialHeaders: {},
        onWebViewCreated: (InAppWebViewController controller) {
            print("\n\n\n\n\n\n");
            webView = controller;
        },
        onLoadStart: (InAppWebViewController controller, String url) {
          print("started $url");
          setState(() {
            this.url = url;
          });
        },
        onLoadStop: (InAppWebViewController controller, String url) async {
          print("stopped $url");
        },
        onProgressChanged:
            (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
        shouldOverrideUrlLoading: (InAppWebViewController controller, String url) {
          print("override $url");
          controller.loadUrl(url);
        },
        onLoadResource: (InAppWebViewController controller, WebResourceResponse response, WebResourceRequest request) {
          print("Started at: " +
              response.startTime.toString() +
              "ms ---> duration: " +
              response.duration.toString() +
              "ms " +
              response.url);
        },
        onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
          print("""
          console output:
            sourceURL: ${consoleMessage.sourceURL}
            lineNumber: ${consoleMessage.lineNumber}
            message: ${consoleMessage.message}
            messageLevel: ${consoleMessage.messageLevel}
          """);
        },
        /*onLoadStop: (InAppWebViewController controller, String url){
          if (url.indexOf("disqus.com/next/login-success") > -1
              ||
              url.indexOf("disqus.com/_ax/facebook/complete") > -1
              ||
              url.indexOf("disqus.com/_ax/google/complete") > -1
              ||
              url.indexOf("disqus.com/_ax/twitter/complete") > -1
              ){
            Future.delayed(const Duration(seconds: 2), (){
              //controller.goBack();
              controller.loadUrl(widget.disqusUri);
              
            });
          }      
        }, */
      ),
    );*/

  }
  
}

