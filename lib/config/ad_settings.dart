import 'package:firebase_admob/firebase_admob.dart';

//const String ADMOB_APPID= "ca-app-pub-7699075207952561~8874484485";
const String ADMOB_APPID= "ca-app-pub-2822886786382553~5046850306";
const String ADMOB_InterStartup = 'ca-app-pub-2822886786382553/3206045208';
const String ADMOB_BannerPostBody = 'ca-app-pub-2822886786382553/6598495306';
const String ADMOB_BannerPostList = 'ca-app-pub-2822886786382553/9264063382';
const String ADMOB_InterURLLaunch = 'ca-app-pub-2822886786382553/8813595103';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
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
  );
