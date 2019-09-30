import 'package:demivolee/controllers/sharedController.dart';
import 'package:demivolee/wrapper/admob_wrapper.dart';
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
  bool _stopScroller = false;
  bool _noPosts = false;
  bool _noConnectivity = false;

  bool pressed = false;
  

  bool notNull(Object o) => o != null;

// Function to fetch list of posts
  Future<void> getPosts(requestUri, {override = true, BuildContext context }) async {
    Duration duration;
    String text;

    if(override){
      duration = Duration(seconds: 2);
      text = "Chargement des articles...";
      this.storedRequest = requestUri;
    }else{
      duration = Duration(seconds: 1);
      text = "Chargement de nouveaux articles...";
    }

    final SnackBar snackBar = SnackBar(
        content: Text(text, textAlign: TextAlign.center,), 
        duration: duration,
        backgroundColor: Color(0xFF323232).withOpacity(0.8),
      );
    Scaffold.of(context).showSnackBar(snackBar);

    List<Post> listPosts = await PostController.fetchPosts(requestUri);
    if(listPosts == null ){
      if(this._posts == null){
        setState(() {    
          this._noConnectivity = true;
        });
      }
    }
    else{
      if (listPosts.length < 10){
        this._stopScroller = true;
      }

      if(listPosts.length == 0 && this._posts == null){
        this._noPosts = true;
      }

      setState(() {      
        if(this._posts != null){
          this._posts.addAll(listPosts);
        }
        else{
          this._posts = listPosts;
        } 
      });
    }
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
    if(this._stopScroller){
      return;
    }
    setState(() {
      this.currentPageNumber++;
      this.getPosts(widget.requestUriInit + "&page=" + this.currentPageNumber.toString(), override: false, context: context); 
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
    if(_noConnectivity){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Center( child: Text("Probème de connectivité. ", style: TextStyle( fontSize: 17),)),
          Center( child: Text("Vérifier votre connexion et rafraichissez.", style: TextStyle( fontSize: 17),)),
          Center( child : IconButton(icon: Icon(Icons.refresh, size: 35, color: Colors.grey,), onPressed: (){ _refreshList(context);},),),
        ]
      );
    }
    return new NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && flagReady) {
          flagReady=false;
          new Timer(const Duration(seconds: 4), () => this.flagReady=true);
          this.loadMorePosts(context);
        }
        return true;
      },
      child: 
        RefreshIndicator( 
        onRefresh: () => _refreshList(context),
        child:
          _listBuilder(context),
        ),
    );
  }

  _listBuilder(BuildContext context){
    if(this._noPosts){
      return Center(child: Text("Pas de résultats pour : \"" + widget.requestUriInit.substring(49, widget.requestUriInit.length - 7) +"\"", style: TextStyle( fontSize: 17),),);
    }

    if(MediaQuery.of(context).size.width <= 600){
      return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
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
              physics: const AlwaysScrollableScrollPhysics(),
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
    return <Widget>[AdmobBannerWrapper(
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
    
    return Stack(
      children: <Widget>[
        Column(
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
          ]
        ),
        Align(alignment: Alignment.topRight,
          child: 
          Padding(
            padding: EdgeInsets.only(right:10, top: 0),
            child : IconButton(
                icon : (SharedController.isFavorite(this._posts[index].getId)) 
                          ? Icon(Icons.star, size: 32, color: Colors.amber,) 
                          : Icon(Icons.star_border, size: 32, color: Colors.amber,),
                onPressed: () {
                  setState(() => SharedController.toogleFavorite(this._posts[index].getId));
                }
            )
          )
          
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