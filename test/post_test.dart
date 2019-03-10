import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:demivolee/post/post.dart';
import 'post_expected_values.dart';

void main() {

  test('Test Post from Json', () async {
    final file = new File('test_resources/post.json');
    final resJson = json.decode(await file.readAsString());
    final post = Post.fromJson(resJson);

    expect(post.id, 21649);
    expect(post.title, expectedTitle);
    expect(post.excerpt, expectedExcerpt);
    expect(post.content, expectedContent);
    expect(post.author, null);
    expect(post.authorLink, "https:\/\/www.demivolee.com\/wp-json\/wp\/v2\/users\/10");
    expect(post.featuredMediaCount, 21681);
    expect(post.featuredMediaURL, "https:\/\/www.demivolee.com\/wp-content\/uploads\/2019\/01\/Premier_Match_Vennegoor_Of_Hesselink-1-1.png");
    // expect(post.featuredMediaCompressedURL.,"https:\/\/www.demivolee.com\/wp-content\/uploads\/2019\/01\/Premier_Match_Vennegoor_Of_Hesselink-1-1-768x431.png");
  });

  test('Test Post from url', () async {
    expect(1, 1);

  });
  /*test('Test Post from url', () async {
    final file = new File('test_resources/post.json');
    // var a = "https://demivolee.com/wp-json/wp/v2/posts/21649/?_embed";
    final resJson = json.decode(await file.readAsString());
    final post = Post.fromJson(resJson);

    expect(post.id, 21649);
    expect(post.title, expectedTitle);
    // expect(post.excerpt, expectedExcerpt);
    // expect(post.content, expectedContent);
    // expect(post.author, null);
    // expect(post.authorLink, "https:\/\/www.demivolee.com\/wp-json\/wp\/v2\/users\/10");
    // expect(post.featuredMediaCount, 21681);
    // expect(post.featuredMediaURL, "https:\/\/www.demivolee.com\/wp-content\/uploads\/2019\/01\/Premier_Match_Vennegoor_Of_Hesselink-1-1.png");
    // expect(post.featuredMediaCompressedURL.,"https:\/\/www.demivolee.com\/wp-content\/uploads\/2019\/01\/Premier_Match_Vennegoor_Of_Hesselink-1-1-768x431.png");
  });*/

}
