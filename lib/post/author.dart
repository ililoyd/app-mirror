import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:firebase_performance/firebase_performance.dart';
// Author Class
class Author {
  final int id;
  final String name;
  final String urlAvatar;
  final String description;

  String get getName => name;
  String get getUrlAvatar => urlAvatar;
  String get getDescription => description;

  Author({this.id, this.name, this.urlAvatar, this.description});

  factory Author.fromJson(Map<String, dynamic> json){
    return Author(
      id: json["id"],
      name: json["name"],
      urlAvatar: json["avatar_urls"]["96"],
      description: json["description"],
    );
  }
}

//Author Future Fetcher
Future<Author> fetchAuthor(link) async {
  final HttpMetric metric = FirebasePerformance.instance
            .newHttpMetric(link, HttpMethod.Get);
    
  await metric.start();
  try{
    http.Response res = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    metric
      ..responsePayloadSize = res.contentLength
      ..responseContentType = res.headers['Content-Type']
      ..requestPayloadSize = res.contentLength
      ..httpResponseCode = res.statusCode;

    if (res.statusCode == 200) {
      return Author.fromJson(json.decode(res.body));
    }
    else {
    throw Exception('Failed to load author');
    }
  }
  catch (e) {
      print(e.toString());
      return null;
  }finally {
      await metric.stop();
  }

}