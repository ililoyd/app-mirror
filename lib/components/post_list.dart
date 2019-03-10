import 'package:flutter/material.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/scheduler.dart';

import '../post/post_preload.dart';

import '../post/post.dart';
import 'package:admob_flutter/admob_flutter.dart';

import '../config/ad_settings.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demivolee/controllers/postController.dart';


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
  final int adEveryEach = 5;

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
    List<Post> listPosts = await PostController.fetchPosts(requestUri);

    setState(() {      
      if(this._posts != null){
        this._posts.addAll(listPosts);
      }
      else{
        this._posts = listPosts;
      } 
    });
  }

  Future<void> _refreshList(BuildContext context) async {
    var url = Uri.encodeFull(this.storedRequest);

    final SnackBar snackBar = SnackBar(
      content: Text('Rafraichissement des articles...', textAlign: TextAlign.center,), 
      duration: const Duration(seconds: 1),
      backgroundColor: Color(0xFF323232).withOpacity(0.8),
      );
    Scaffold.of(context).showSnackBar(snackBar);
    List<Post> listPosts = await PostController.fetchPosts(url);

    setState(() {
      this.currentPageNumber = 1; 
      this._posts = listPosts;   
    });

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
            _listBuilder(context),
        ),
    );
  }

  _listBuilder(BuildContext context){

    if(MediaQuery.of(context).size.width <= 600){
      return ListView.builder(
                shrinkWrap: true,
                itemCount: this._posts == null ? 0 : this._posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: 
                      (index % adEveryEach == 1) ? _buildCardWithAdMob(index, _buildCard) : _buildCard(index)
                  );
                },
              );
    }
    return GridView.builder(
              itemCount: this._posts == null ? 0 : this._posts.length,
              padding: EdgeInsets.all(4.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: 
                    _buildGrid(index)
                );
              },
            );
  }
  _buildCardWithAdMob(index, callback){
    int admobIndex = (index ~/ adEveryEach) % ADMOB_BannerPostList.length ; 
    //return _buildCard(index);
    return <Widget>[AdmobBanner(
      adUnitId: ADMOB_BannerPostList[admobIndex] ,
      adSize: (admobIndex == 1) ? AdmobBannerSize.MEDIUM_RECTANGLE : AdmobBannerSize.LARGE_BANNER
    ),]..addAll(callback(index));
  }

  List<Widget> _buildGrid(index){
    return <Widget>[ Card(
      elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      child: InkWell(
        onTap: () { 
          Navigator.push(context, 
            new MaterialPageRoute(
              builder: (context) => new DVPostPreloaded(post: this._posts[index], ),
            ),
          ); 
        },
        child: _buildGridTile(index),
      ),
    )].where(notNull).toList();
  }

  List<Widget> _buildCard(index){
    return <Widget>[ Card( 
      child: InkWell(
        onTap: () { 
          Navigator.push(context, 
            new MaterialPageRoute(
              builder: (context) => new DVPostPreloaded(post: this._posts[index], ),
            ),
          ); 
        },
        child: _buildTile(index)
      ),
    )].where(notNull).toList();
  }

  _buildGridTile(index){
    return Column(
      children: <Widget>[
        _buildImage(index), 
        new ListTile(
            title: new Padding(
              padding: EdgeInsets.symmetric(vertical: 1.0), 
              child: new Text((this._posts[index].getTitle), style: TextStyle(fontWeight: FontWeight.bold),)
            ),
          ),
      ],
    );
  }
  Widget _buildTile(index){
    return Column(
      children: <Widget>[
        _buildImage(index), 

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
    );
  }

  _buildImage(index ){
    return FutureBuilder<String>(
      future : this._posts[index].getFeaturedMediaCompressedURL,
      builder: (context, snapshot){
        if (snapshot.hasData){ 
          if (this._posts[index].getFeaturedMediaCount == 0) {
            return Container(
              child : Image.memory(kTransparentImage),
              alignment: Alignment.center,
            );
          }else{
            return new CachedNetworkImage(
              placeholder: (context, url) => new  Image.memory(kTransparentImage),
              imageUrl: snapshot.data,
              errorWidget: (context, url, error) => new Icon(Icons.error),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else{
          return Container(
            child : Image.memory(kTransparentImage),
            alignment: Alignment.center,
          );
        }
      });
  }
}