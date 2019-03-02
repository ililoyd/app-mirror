//import 'package:firebase_admob/firebase_admob.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';

//const String ADMOB_APPID= "ca-app-pub-7699075207952561~8874484485";
//const String ADMOB_InterStartup  = 'ca-app-pub-7699075207952561/9899667837';

const String ADMOB_APPID= "ca-app-pub-2822886786382553~5046850306";
const String ADMOB_InterStartup = 'ca-app-pub-2822886786382553/3206045208';
const List<String>  ADMOB_BannerPostBody = ['ca-app-pub-2822886786382553/6598495306', 'ca-app-pub-2822886786382553/9305000379'];
const List<String> ADMOB_BannerPostList = [ 'ca-app-pub-2822886786382553/9264063382', 
                                            'ca-app-pub-2822886786382553/7752838459',
                                            'ca-app-pub-2822886786382553/4408366102',
                                            'ca-app-pub-2822886786382553/1670522122'];
const String ADMOB_InterURLLaunch = 'ca-app-pub-2822886786382553/8813595103';



/*MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['demivolee', 'demivolee.com', 'champions league', 'football', 
  'foot', 'french football', 'ligue 1', 'ligue1', 'ligue des champions' 
  'football français', 'serie a', 'Liga', 'Bundesliga', 'Premier League', 'French NT', 'French National Team'
  'Les Bleus', 'histoire du football', 'histoire foot', 'football history', 'french', 'football scouting', 'scout football',
  'wonderkid football'],
  contentUrl: 'https://www.demivolee.com',
  childDirected: false,
  birthday: new DateTime.now(),
  gender: MobileAdGender.unknown,
  testDevices: <String>[], // Android emulators are considered test devices
  );*/

AdmobTargetInfo targetingInfo = AdmobTargetInfo(
  keywords: <String>['demivolee', 'demivolee.com', 'champions league', 'football', 
  'foot', 'french football', 'ligue 1', 'ligue1', 'ligue des champions' 
  'football français', 'serie a', 'Liga', 'Bundesliga', 'Premier League', 'French NT', 'French National Team'
  'Les Bleus', 'histoire du football', 'histoire foot', 'football history', 'french', 'football scouting', 'scout football',
  'wonderkid football'],
  contentUrl: 'https://www.demivolee.com',
  tagForChildDirectedTreatment: false,
  testDevices: <String>[],
  networkExtraBundle: <String, dynamic> {
    "tag_for_under_age_of_consent" : true, //https://developers.google.com/admob/android/targeting#users_under_the_age_of_consent
    "max_ad_content_rating": "T" //https://developers.google.com/admob/android/targeting#ad_content_filtering
  }
);

MobileAdTargetingInfo targetingInfo2 = MobileAdTargetingInfo(
  keywords: <String>['demivolee', 'demivolee.com', 'champions league', 'football', 
  'foot', 'french football', 'ligue 1', 'ligue1', 'ligue des champions' 
  'football français', 'serie a', 'Liga', 'Bundesliga', 'Premier League', 'French NT', 'French National Team'
  'Les Bleus', 'histoire du football', 'histoire foot', 'football history', 'french', 'football scouting', 'scout football',
  'wonderkid football'],
  contentUrl: 'https://www.demivolee.com',
  testDevices: <String>[],
);
