import 'package:flutter/material.dart';

import 'package:html_unescape/html_unescape.dart';

import 'author.dart';
import 'post.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'package:firebase_performance/firebase_performance.dart';
import '../components/post_body.dart';

//Author Future Fetcher
Future<Post> fetchPostFromSlug(slug, context) async {
  var url = Uri.encodeFull("https://www.demivolee.com/wp-json/wp/v2/posts?slug=" + slug + "&_embed");
  
  final HttpMetric metric1 = FirebasePerformance.instance
            .newHttpMetric(url, HttpMethod.Get);
  
  await metric1.start();

  try{
    http.Response res = await http.get(url, headers: {"Accept": "application/json"});
    metric1
      ..responsePayloadSize = res.contentLength
      ..responseContentType = res.headers['Content-Type']
      ..requestPayloadSize = res.contentLength
      ..httpResponseCode = res.statusCode;

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);
      var authorUrl = Uri.encodeFull(decodedJson[0]['_links']["author"][0]["href"].toString());
      final HttpMetric metric2 = FirebasePerformance.instance
            .newHttpMetric(authorUrl, HttpMethod.Get);
      try{
          res = await http.get(authorUrl, headers: {"Accept": "application/json"});
          metric2
            ..responsePayloadSize = res.contentLength
            ..responseContentType = res.headers['Content-Type']
            ..requestPayloadSize = res.contentLength
            ..httpResponseCode = res.statusCode;
          if (res.statusCode == 200) {
            return Post.fromJson(decodedJson[0], context, Author.fromJson(json.decode(res.body)));
          }
          else {
            throw Exception('Failed to load author');
          }
      }catch (e) {
        print(e.toString());
        return null;
      }finally {
        await metric2.stop();
      }
    }
    else {
      throw Exception('Failed to load post !');
    }
  }catch (e) {
    print(e.toString());
    return null;
  }finally {
    await metric1.stop();
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