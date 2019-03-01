import 'package:flutter/material.dart';

import 'package:html_unescape/html_unescape.dart';
// import 'package:html2md/html2md.dart' as html2md;
// import 'package:flutter_markdown/flutter_markdown.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'author.dart';

import 'dart:async';

import 'post_newload.dart';
import '../utils/launch.dart';

import 'package:demivolee/controllers/postController.dart';

class DVPost extends StatelessWidget {

  DVPost({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class Post {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  //final Html content;
  final Author author;
  final String authorLink;
  final String featuredMediaURL;
  final int featuredMediaCount;
  final Future<String> featuredMediaCompressedURL;

  int get getId => id;
  String get getTitle => title;
  String get getExcerpt => excerpt;
  //MarkdownBody get getContent => content;
  String get getContent => content;
  Author get getAuthor => author;
  String get getAuthorLink => authorLink;
  String get getFeaturedMediaURL => featuredMediaURL;
  Future<String> get getFeaturedMediaCompressedURL => featuredMediaCompressedURL;
  int get getFeaturedMediaCount => featuredMediaCount;

  Post({this.id, this.title, this.excerpt, this.content, this.author, 
  this.authorLink, this.featuredMediaURL, this.featuredMediaCount, this.featuredMediaCompressedURL});

  factory Post.fromJson(json,  [Author author]){
    var unescape = new HtmlUnescape();

    return Post(
      id: json["id"],
      title: unescape.convert(json["title"]["rendered"]),
      excerpt: unescape.convert(json["excerpt"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), '')),
      content : json["content"]["rendered"],
      //content: new MarkdownBody(data: html2md.convert(json["content"]["rendered"]), onTapLink: (link){onTapLink(link, context);} ),
      //content: new Html(data: json["content"]["rendered"], useRichText: true, onLinkTap: (link){onTapLink(link, context);}),
      author : author,
      authorLink : json['_links']["author"][0]["href"],
      featuredMediaCount : json["featured_media"],
      featuredMediaURL: (json["featured_media"] == 0) ? null : json["_embedded"]["wp:featuredmedia"][0]["source_url"],
      featuredMediaCompressedURL: (json["featured_media"] == 0) ? null : PostController.fetchCompressedURL(json["_links"]["wp:featuredmedia"][0]["href"]),
    );
  }
}



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
    URLController.launchURL(href);
    return;
  }

  Navigator.push(
    context, new MaterialPageRoute(
    builder: (context) => new DVPostNewLoad(slug : slug),
    ),
  ); 
  return;
}