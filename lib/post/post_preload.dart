import 'package:flutter/material.dart';

import '../utils/launch.dart';
import 'post.dart';
import 'author.dart';
import '../components/post_body.dart';
//import '../page/disqus.dart';

class DVPostPreloaded extends DVPost {
  final Post post;

  DVPostPreloaded({Key key, @required var this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    URLController.preloadAd();
    var disqusUuid = post.getId.toString() + " https://www.demivolee.com/?p="+ post.getId.toString();
    var disqus = "https://www.datandev.com/disqus_test.html?t_id=" + disqusUuid;

    var link = post.getAuthorLink;
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(post.getTitle),
        //backgroundColor: Colors.blueAccent,
        backgroundColor: const Color(0xffef5055),
      ),
      body: new Stack(
        children : [
          FutureBuilder<Author>(
            future : fetchAuthor(link),
            builder: (context, snapshot){
              if (snapshot.hasData){ 
                return new DVPostBody(
                  featuredMediaCount: this.post.getFeaturedMediaCount,
                  featuredMediaURL: this.post.getFeaturedMediaURL,
                  content: this.post.getContent,
                  author: snapshot.data,
                  disqus: true,
                  featuredMediaCompressedURL: this.post.getFeaturedMediaCompressedURL,
                );
              } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
              }
              else{
                return DVPostBody(
                  featuredMediaCount: this.post.getFeaturedMediaCount,
                  featuredMediaURL: this.post.getFeaturedMediaURL,
                  content: this.post.getContent,
                );
              }
            }),

          /*Center(
              child : 
                Container(
                    child : InkWell(
                    onTap: () { 
                      launchURL(context, disqus);
                    },
                    child : Image.asset(
                      "assets/disqus.png",
                      height: 70, 
                    ),
                  ),
                  alignment: Alignment(0.9,0.9),  
                )
          )*/
        ]
     ),
     floatingActionButton: FloatingActionButton(
      onPressed: () {URLController.launchURL(disqus); },
      /*onPressed: () {
        Navigator.push(
          context, new MaterialPageRoute(
            builder: (context) => new DVDisqus(disqusUri: disqus,),
          ),
        );
       },*/
      child: Image.asset("assets/disqus.png",height: 70, ),
      backgroundColor: Colors.white10,

     ),
    );
  }
}