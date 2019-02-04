import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/scheduler.dart';

import 'package:firebase_performance/firebase_performance.dart';

import '../post/post_preload.dart';

import '../post/post.dart';

class DVPostList extends StatefulWidget{
  DVPostList({Key key,  @required this.requestUriInit}) : super(key: key);
  final String requestUriInit;


  @override
  _DVPostListState createState() => _DVPostListState();

}

class _DVPostListState extends State<DVPostList> {
  List<Post> _posts;
  String storedRequest;
  int currentPageNumber = 1;
  bool flagReady = true;

  bool notNull(Object o) => o != null;

// Function to fetch list of posts
  Future<void> getPosts(requestUri, {store = true, BuildContext context }) async {
    if(store){
      final SnackBar snackBar = SnackBar(
        content: Text('Chargement des articles...', textAlign: TextAlign.center,), 
        duration: const Duration(seconds: 2),
        backgroundColor: Color(0xFF323232).withOpacity(0.8),
      );
      Scaffold.of(context).showSnackBar(snackBar);
     this.storedRequest = requestUri;
    }else{
      final SnackBar snackBar = SnackBar(
        content: Text('Chargement de nouveaux articles...', textAlign: TextAlign.center,), 
        duration: const Duration(seconds: 1),
        backgroundColor: Color(0xFF323232).withOpacity(0.6),
        );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    requestUri = Uri.encodeFull(requestUri);
    final HttpMetric metric = FirebasePerformance.instance
            .newHttpMetric(requestUri, HttpMethod.Get);
    
    await metric.start();
    try{
      http.Response res = await http.get(requestUri, headers: {"Accept": "application/json"});
      metric
        ..responsePayloadSize = res.contentLength
        ..responseContentType = res.headers['Content-Type']
        ..requestPayloadSize = res.contentLength
        ..httpResponseCode = res.statusCode;

      if (res.statusCode == 200) {
        setState(() {      
          var resBody = json.decode(res.body);
          if(!(resBody is Map)){
            if(this._posts != null){
              this._posts.addAll(List<Post>.from(resBody.map((x) => Post.fromJson(x, context)).toList()));
            }
            else{
              this._posts = List<Post>.from(resBody.map((x) => Post.fromJson(x, context)).toList());
            }
          }
        });
      }
      else {
        if(res.statusCode == 400){
          print("Max Range");
        }
        else{
          throw Exception('Failed to load Post');
        }
      }
    }catch (e) {
      print(e.toString());
    }finally {
      await metric.stop();
    }// fill our posts list with results and update state  
  }

  Future<void> _refreshList(BuildContext context) async {
    var url = Uri.encodeFull(this.storedRequest);
    final HttpMetric metric = FirebasePerformance.instance
            .newHttpMetric(url, HttpMethod.Get);
    await metric.start();
    try{
      final SnackBar snackBar = SnackBar(
        content: Text('Rafraichissement des articles...', textAlign: TextAlign.center,), 
        duration: const Duration(seconds: 1),
        backgroundColor: Color(0xFF323232).withOpacity(0.8),
        );
      Scaffold.of(context).showSnackBar(snackBar);

      http.Response res = await http.get(url, headers: {"Accept": "application/json"});
      metric
        ..responsePayloadSize = res.contentLength
        ..responseContentType = res.headers['Content-Type']
        ..requestPayloadSize = res.contentLength
        ..httpResponseCode = res.statusCode;

      // fill our posts list with results and update state
      if (res.statusCode == 200) {
        setState(() {
          this.currentPageNumber = 1; 
          var resBody = json.decode(res.body);
          this._posts = List<Post>.from(resBody.map((x) => Post.fromJson(x, context)).toList());   
        });
      }
      else {
        throw Exception('Failed to refresh');
      }
    }catch (e) {
      print(e.toString());
    }finally {
      await metric.stop();
    }//

  }

  void loadMorePosts(BuildContext context){
    setState(() {
      this.currentPageNumber++;
      this.getPosts(widget.requestUriInit + "&page=" + this.currentPageNumber.toString(), store: false, context: context); 
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
     this.getPosts(widget.requestUriInit, context: context);
    });
  }

  Widget build(BuildContext context) {
    
    //print(this._posts.length);
    
    return new RefreshIndicator( 
      onRefresh: () => _refreshList(context),
      child:
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && flagReady) {
              flagReady=false;
              new Timer(const Duration(seconds: 4), () => this.flagReady=true);
              this.loadMorePosts(context);
            }
          },
          child:
          ListView.builder(
            itemCount: this._posts == null ? 0 : this._posts.length,
            
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Card(
                    child:InkWell(
                      onTap: () { 
                        Navigator.push(context, 
                          new MaterialPageRoute(
                            builder: (context) => new DVPostPreloaded(post: this._posts[index], ),
                          ),
                        ); 
                      },
                      child: Column(
                        children: <Widget>[
                          FutureBuilder<String>(
                            future : this._posts[index].getFeaturedMediaCompressedURL,
                            builder: (context, snapshot){
                              if (snapshot.hasData){ 
                                return new FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: this._posts[index].getFeaturedMediaCount == 0
                                    ? ''
                                    : snapshot.data
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              } else{
                                return Container(
                                  child : Image.memory(kTransparentImage),
                                  alignment: Alignment.center,
                                );
                              }
                            }), 

                          new Padding(
                            padding: EdgeInsets.all(10.0),
                            child: new ListTile(
                              title: new Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0), 
                                child: new Text((this._posts[index].getTitle))
                              ),
                              subtitle: new Text(
                                this._posts[index].getExcerpt,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), 
                  )
                ].where(notNull).toList(),
              );
            },
        ),
        ),
    );
  }
}