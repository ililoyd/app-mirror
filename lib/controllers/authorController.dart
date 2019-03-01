
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'package:demivolee/controllers/httpController.dart';
import 'package:demivolee/post/author.dart';

class AuthorController{
  //Author Future Fetcher
  static Future<Author> fetchAuthor(link) async {
    http.Response res = await HttpController.get(Uri.encodeFull(link));

    if (res.statusCode == 200) {
      return Author.fromJson(json.decode(res.body));
    }
    else {
    throw Exception('Failed to load author');
    }
  }
}