import 'package:demivolee/post/post.dart';
import 'package:demivolee/post/author.dart';
import 'package:demivolee/controllers/httpController.dart';
//import 'package:demivolee/controllers/cacheController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class PostController {
  static SharedPreferences prefs;

  static Future<Post> fetchPostFromSlug(slug, context) async {
    var url = Uri.encodeFull("https://www.demivolee.com/wp-json/wp/v2/posts?slug=" + slug + "&_embed");
    http.Response res = await HttpController.get(url); 

    try{
      if (res.statusCode == 200) {
        var decodedJson = json.decode(res.body);
        var authorUrl = Uri.encodeFull(decodedJson[0]['_links']["author"][0]["href"].toString());
        http.Response res2 = await HttpController.get(authorUrl); 

        if (res2.statusCode == 200) {
          return Post.fromJson(decodedJson[0], Author.fromJson(json.decode(res2.body)));
        }
        else {
          throw Exception('Failed to load author');
        }
      }
      else {
        throw Exception('Failed to load post !');
      }
    } on Exception {
      return null;
    }
  }

  // Function to fetch list of posts
  static Future<List<Post>> fetchPosts(requestUri) async {
    requestUri = Uri.encodeFull(requestUri);
    http.Response res = await HttpController.get(requestUri);
    //Stream res = CustomCacheManager().getFile(requestUri);

    /*if(res == null){
      return;
    }*/
    try{
      if (res.statusCode == 200) {
        var resBody = json.decode(res.body);
        if(!(resBody is Map)){
          return List<Post>.from(resBody.map((x) => Post.fromJson(x)).toList());
        }
        return null;
      }
      else {
        if(res.statusCode == 400){
          print("Max Range");
          return null;
        }
        else{
          throw Exception('Failed to load Post');
        }
      }
    } on Exception {
      return null;
    }
    /*
    Encoding encoding;
    var resBody = json.decode(encoding.decode(res.));
    if(!(resBody is Map)){
      return List<Post>.from(resBody.map((x) => Post.fromJson(x)).toList());
    }
    return null;*/
  }

  static Future<String> fetchCompressedURL(link) async {
    http.Response res = await HttpController.get(Uri.encodeFull(link)); 
    try{
      
      if (res.statusCode == 200) {
        var jsonSizesList = json.decode(res.body)["media_details"]["sizes"] as Map; 
        if(jsonSizesList.containsKey("medium_large")){
          return jsonSizesList["medium_large"]["source_url"];
        }
        else if(jsonSizesList.containsKey("mh-magazine-content")){
          return jsonSizesList["mh-magazine-content"]["source_url"];
        }
        else if(jsonSizesList.containsKey("medium")){
          return jsonSizesList["medium"]["source_url"];
        }else{
          return jsonSizesList["full"]["source_url"];
        }
      }
      else {
        throw Exception('Failed to load compressed media');
      }
    } on Exception {
      return null;
    }
  }
  static getInstance() async{
    final prefs = await SharedPreferences.getInstance();
    PostController.prefs = prefs;
  }

  static bool isFavorite(index){
    print(index);
    prefs = PostController.prefs;
    
    List<String> list = prefs.getStringList("favorites") ?? List();
    return list.contains(index.toString());
  }

  static toogleFavorite(index){
     prefs = PostController.prefs;

    List<String> list = prefs.getStringList("favorites") ?? List();
    if (list.contains(index.toString())) {
      list.remove(index.toString());
    }
    else{
      list.add(index.toString());
    }
    prefs.setStringList("favorites", list);

  }
}