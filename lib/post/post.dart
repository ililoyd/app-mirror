import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'author.dart';
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
  final String link;

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
  String get getLink => link;


  Post({this.id, this.title, this.excerpt, this.content, this.author, 
  this.authorLink, this.featuredMediaURL, this.featuredMediaCount, this.featuredMediaCompressedURL, this.link});

  factory Post.fromJson(json,  [Author author]){
    var unescape = new HtmlUnescape();

    return Post(
      id: json["id"],
      title: unescape.convert(json["title"]["rendered"]),
      excerpt: unescape.convert(json["excerpt"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), '')),
      content : json["content"]["rendered"],
      author : author,
      authorLink : json['_links']["author"][0]["href"],
      featuredMediaCount : json["featured_media"],
      featuredMediaURL: (json["featured_media"] == 0) ? null : json["_embedded"]["wp:featuredmedia"][0]["source_url"],
      featuredMediaCompressedURL: (json["featured_media"] == 0) ? null : PostController.fetchCompressedURL(json["_links"]["wp:featuredmedia"][0]["href"]),
      link: json["link"],
    );
  }
}