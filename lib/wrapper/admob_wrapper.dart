import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';

class AdmobBannerWrapper extends StatefulWidget {
  final String adUnitId;
  final AdmobBannerSize adSize;

  AdmobBannerWrapper({
    Key key,
    this.adUnitId, this.adSize
  }) : super(key: key);

  @override
  AdmobBannerWrapperState createState() => AdmobBannerWrapperState();
}

class AdmobBannerWrapperState extends State<AdmobBannerWrapper> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AdmobBanner(
            adUnitId: widget.adUnitId, 
            adSize: widget.adSize
    );
  }
}