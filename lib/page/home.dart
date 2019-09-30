import 'package:flutter/material.dart';

import '../components/side_menu.dart';
import '../components/post_list.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:demivolee/utils/getSlug.dart';
import 'package:demivolee/post/post_newload.dart';
import 'package:flutter/services.dart';

class DVHome extends StatefulWidget {
  DVHome({Key key, this.queryAPI, this.appBarTitle, this.isStartup = false}) : super(key: key);

  final String appBarTitle;
  final String queryAPI;
  final bool isStartup;

  @override
  State<StatefulWidget> createState() => DVHomeState();
}

class DVHomeState extends State<DVHome> {
  StreamSubscription _sub;
  final TextEditingController _filter = new TextEditingController();

  final String apiUrl = "https://demivolee.com/wp-json/wp/v2/";

  DVPostList bodyList;
  Icon _searchIcon = new Icon(Icons.search);

  Widget _appBarTitle = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [ Image.asset('assets/title-v2.png', 
      fit: BoxFit.contain,height: 32,),]
  ,);

  Widget _legacyAppBarTitle;

  

  Future<Null> initUniLinks() async {

    try {
      String initialLink = await getInitialLink();
      if(initialLink != null){
        String slug = extractSlugFromLink(initialLink);
        if (slug != null){
          Navigator.push(
            context, new MaterialPageRoute(
            builder: (context) => new DVPostNewLoad(slug : slug),
            ),
          ); 
        }
      }
    } on PlatformException {
      print("Message erreur");
    }
    

    // Attach a listener to the stream
    _sub = getLinksStream().listen((String link) {
      print("URL DEEP LINK");
      String slug = extractSlugFromLink(link);
      if (slug != null){
        Navigator.push(
          context, new MaterialPageRoute(
          builder: (context) => new DVPostNewLoad(slug : slug),
          ),
        ); 
      }

      print(link);
    }, onError: (err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    this.initUniLinks();
  }

  void _searchPressed(BuildContext context) {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._legacyAppBarTitle = this._appBarTitle;
        this._appBarTitle = new TextField(
          autofocus: true,
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Rechercher...'
          ),
          onSubmitted: _submitSearch,
        );
        
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = this._legacyAppBarTitle;
      }
    });
  }

  void _submitSearch(String submit){
    this._searchIcon = new Icon(Icons.search);
    this._appBarTitle = this._legacyAppBarTitle;
    //this._searchText = "";
    this._filter.clear();

    Navigator.push(
      context, new MaterialPageRoute(
        builder: (context) => new DVHome(queryAPI: "posts?search=" + submit),
      ),              
    );
    
  }

  @override
  Widget build(BuildContext context) {
    this.bodyList = (widget.queryAPI !=null) 
                  ?
                    new DVPostList(requestUriInit: apiUrl+ widget.queryAPI + "&_embed")
                  :
                    new DVPostList(requestUriInit: apiUrl + "posts?_embed",);

    
    return Scaffold(
      drawer : new DVSideMenu(),

      appBar: AppBar(
        leading: (widget.queryAPI !=null) ? BackButton() : null,
        title: this._appBarTitle,
        actions : <Widget>[new IconButton( icon : _searchIcon, onPressed: () => _searchPressed(context),)],
        backgroundColor: Theme.of(context).primaryColor,
        //backgroundColor: Colors.blueAccent
      ),

      body: this.bodyList,
    );
  }

  @override
  void dispose() {
    if (this._sub != null){
      this._sub.cancel();
    }
    super.dispose();
  }
}