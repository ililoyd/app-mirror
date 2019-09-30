import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/cupertino.dart';

class PhotoViewDialog extends StatefulWidget {
  final String imageUrl;
  PhotoViewDialog({Key key, @required var this.imageUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PhotoViewDialogState();
}

class PhotoViewDialogState extends State<PhotoViewDialog> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(imageProvider: NetworkImage(widget.imageUrl), 
                        loadingChild: CupertinoActivityIndicator(),),
    );
  }

}