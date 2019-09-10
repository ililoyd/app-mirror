import 'package:demivolee/components/side_menu.dart';
import 'package:flutter/material.dart';

import 'package:html_unescape/html_unescape.dart';

import 'package:demivolee/controllers/postController.dart';
import 'post.dart';
import 'package:share/share.dart';

import '../components/post_body.dart';




class DVPostNewLoad extends DVPost {
  final slug;

  DVPostNewLoad({Key key, @required var this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var unescape = new HtmlUnescape();

    return FutureBuilder<Post>(
      future : PostController.fetchPostFromSlug(slug, context),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return new Scaffold(
            drawer: DVSideMenu(),
            
            appBar: new AppBar(
              leading: const BackButton(),
              title: new Text(unescape.convert(snapshot.data.title)),
              backgroundColor: const Color(0xffef5055),
              actions: <Widget>[IconButton(
                  icon: const Icon(IconData(59405, fontFamily: 'MaterialIcons')),
                  onPressed: (){Share.share(snapshot.data.getLink);},)
                ],
              //backgroundColor: Colors.blueAccent,
            ),
            body: new Stack(
              children : [ new DVPostBody(
                content: snapshot.data.content,
                author: snapshot.data.getAuthor,
                featuredMediaCount: snapshot.data.getFeaturedMediaCount,
                featuredMediaURL: snapshot.data.featuredMediaURL,
                featuredMediaCompressedURL: snapshot.data.featuredMediaCompressedURL,
              ),

              ]
            )
          );      
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } 
        else {
          // By default, show a loading spinner
          return new Scaffold(
              appBar: new AppBar(
                title: new Text("Chargement..."),
                backgroundColor: const Color(0xffef5055),
                //backgroundColor: Colors.blueAccent,
              ),
              body : 
                Container(
                  child : CircularProgressIndicator(),
                  alignment: Alignment.center,
                )
              
          );
        }
      },
    );
  }

}