import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import '../utils/httpController.dart';

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
  http.Response res = await HttpController.get(Uri.encodeFull(link));

  if (res.statusCode == 200) {
    return Author.fromJson(json.decode(res.body));
  }
  else {
  throw Exception('Failed to load author');
  }
}