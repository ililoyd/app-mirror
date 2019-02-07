import 'package:flutter/material.dart';

import 'package:html_unescape/html_unescape.dart';

import 'author.dart';
import 'post.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import '../components/post_body.dart';
import '../utils/httpController.dart';

//Author Future Fetcher
Future<Post> fetchPostFromSlug(slug, context) async {
  var url = Uri.encodeFull("https://www.demivolee.com/wp-json/wp/v2/posts?slug=" + slug + "&_embed");
  http.Response res = await HttpController.get(url); 

  if (res.statusCode == 200) {
    var decodedJson = json.decode(res.body);
    var authorUrl = Uri.encodeFull(decodedJson[0]['_links']["author"][0]["href"].toString());
    http.Response res2 = await HttpController.get(authorUrl); 

    if (res2.statusCode == 200) {
      return Post.fromJson(decodedJson[0], context, Author.fromJson(json.decode(res2.body)));
    }
    else {
      throw Exception('Failed to load author');
    }
  }
  else {
    throw Exception('Failed to load post !');
  }
}

class DVPostNewLoad extends DVPost {
  final slug;

  DVPostNewLoad({Key key, @required var this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var unescape = new HtmlUnescape();

    return FutureBuilder<Post>(
      future : fetchPostFromSlug(slug, context),
      builder: (context, snapshot){
        if (snapshot.hasData){
          return new Scaffold(
            appBar: new AppBar(
              title: new Text(unescape.convert(snapshot.data.title)),
              backgroundColor: const Color(0xffef5055),
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