import 'package:flutter/material.dart';
import 'package:demivolee/components/side_menu.dart';

import '../utils/launch.dart';
import 'post.dart';
import 'author.dart';
import '../components/post_body.dart';
import 'package:demivolee/controllers/authorController.dart';
import '../page/disqus.dart';
import 'package:share/share.dart';

//https://www.demivolee.com/wp-json/wp/v2/posts?include[]=21649&include[]=35&include[]=22076

class DVPostPreloaded extends DVPost {
  final Post post;

  DVPostPreloaded({Key key, @required var this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    URLController.preloadAd();
    var disqusUuid = post.getId.toString() + " https://www.demivolee.com/?p="+ post.getId.toString();
    var disqus = "https://www.datandev.com/disqus_test.html?t_id=" + disqusUuid;

    var link = post.getAuthorLink;
    
    return new Scaffold(
      drawer: DVSideMenu(),
      appBar: new AppBar( 
        leading: const BackButton(),
        title: new Text(post.getTitle),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[IconButton(
                  icon: const Icon(IconData(59405, fontFamily: 'MaterialIcons')),
                  onPressed: (){Share.share(post.getLink);},)
                ],
      ),
      body: new Stack(
        children : [
          FutureBuilder<Author>(
            future : AuthorController.fetchAuthor(link),
            builder: (context, snapshot){
              if (snapshot.hasData){ 
                return new DVPostBody(
                  featuredMediaCount: this.post.getFeaturedMediaCount,
                  featuredMediaURL: this.post.getFeaturedMediaURL,
                  content: this.post.getContent,
                  author: snapshot.data,
                  disqus: true,
                  featuredMediaCompressedURL: this.post.getFeaturedMediaCompressedURL,
                );
              } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
              }
              else{
                return DVPostBody(
                  featuredMediaCount: this.post.getFeaturedMediaCount,
                  featuredMediaURL: this.post.getFeaturedMediaURL,
                  content: this.post.getContent,
                );
              }
            }),
        ]
     ),
     floatingActionButton: FloatingActionButton(
      //onPressed: () {URLController.launchURL(disqus); },
      onPressed: () {
        Navigator.push(
          context, new MaterialPageRoute(
            builder: (context) => new DVDisqus(disqusUri: disqus,),
          ),
        );
       },
      child: Image.asset("assets/disqus.png",height: 70, ),
      backgroundColor: Colors.white10,

     ),
    );
  }
}