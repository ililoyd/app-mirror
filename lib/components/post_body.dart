import 'package:flutter/material.dart';

import 'package:transparent_image/transparent_image.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_html/flutter_html.dart';


import '../post/author.dart';
import '../post/post_newload.dart';
import '../utils/launch.dart';

import '../page/home.dart';

class DVPostBody extends StatelessWidget {
  final int featuredMediaCount;
  final String featuredMediaURL;
  final Future<String> featuredMediaCompressedURL;
  //final MarkdownBody content;
  //final Html content;
  final String content;
  final Author author;
  final bool disqus;

  void onTapLink(String href, BuildContext context) {
    var listSplit = href.split("/");
    var slug;
    var regEx1 = RegExp(r"http[s]?:\/\/www\.demivolee\.com\/[\d]{4}\/\d{2}\/\d{2}\/[\w-]*\/");
    var regEx2 = RegExp(r"http[s]?:\/\/www\.demivolee\.com\/[\d]{4}\/\d{2}\/\d{2}\/[\w-]*\$");
    if (regEx1.hasMatch(href)) {
      slug = listSplit[listSplit.length-2];
    }
    else if (regEx2.hasMatch(href)) {
      slug = listSplit[listSplit.length-1];
    }
    else{
      launchURL(context, href);
      return;
    }

    Navigator.push(
      context, new MaterialPageRoute(
      builder: (context) => new DVPostNewLoad(slug : slug),
      ),
    ); 
    return;
  }

  

  DVPostBody({Key key, this.featuredMediaCount, this.featuredMediaURL, this.featuredMediaCompressedURL, this.content, this.author, this.disqus = false}) : super(key: key);

  Widget build(BuildContext context) {
   return new Padding(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        children: <Widget>[
    
          // Post Featured Image
          FutureBuilder<String>(
            future : this.featuredMediaCompressedURL,
            builder: (context, snapshot){
              if (snapshot.hasData){ 
                return new FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: this.featuredMediaCount == 0
                    ? ''
                    : snapshot.data
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else{
                return Container();
              }
              
          }),
          // Content Body
          new Container(
            padding: const EdgeInsets.only(bottom: 8.0, top:8.0),
            child :  Html(data:this.content, useRichText: true, onLinkTap: (link){onTapLink(link, context);}),
            //child : new MarkdownBody(data: this.content, onTapLink: (link){onTapLink(link,context);} ),
          ),

          new Divider(color: Colors.black,),

          (this.author != null) 
          ?
            // Author Box
            new Container(
              padding:  EdgeInsets.only(bottom: (disqus) ? 6.0 + (MediaQuery.of(context).size.height) * 0.1 - 15.0  : 16.0, top:8.0),
              child :  
                InkWell(
                  child : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : <Widget>[

                      //Author Avatar
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children : <Widget>[Container (
                            padding: const EdgeInsets.only(right: 16.0),
                            child : new FadeInImage.assetNetwork(
                              placeholder: "assets/ph_author96.png",
                              image: this.author.urlAvatar,
                              fit : BoxFit.contain,
                            ),
                          ),
                        ]),

                        // Author Name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children : <Widget>[
                          Container (
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(this.author.name, style : TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
                          ),
            
                          //Author Description
                          Container (
                            width: MediaQuery.of(context).size.width - 96 - 48,
                            child: Text(this.author.description, style : TextStyle(fontSize: 13)), 
                          ),
                        ]  
                      )
                    ],
                  ),
                  onTap: () {
                        Navigator.push(context,
                          new MaterialPageRoute(
                            builder: (context) => new DVHome(queryAPI: "posts?author=" + this.author.id.toString()),
                          ),
                         ); 
                      },
                )
            )
          :
            Container(),
        ],
      ),
    );
  }
}