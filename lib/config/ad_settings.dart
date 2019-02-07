import 'package:firebase_admob/firebase_admob.dart';

const String ADMOB_APPID= "ca-app-pub-7699075207952561~8874484485";
const String ADMOB_Inter1_ID = 'ca-app-pub-7699075207952561/9899667837';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['demivolee', 'demivolee.com', 'champions league', 'football', 
  'foot', 'french football', 'ligue 1', 'ligue1', 'ligue des champions' 
  'football français', 'serie a', 'Liga', 'Bundesliga', 'Premier League', 'French NT', 'French National Team'
  'Les Bleus', 'histoire du football', 'histoire foot', 'football history', 'french', 'football scouting', 'scout football',
  'wonderkid football'],
  contentUrl: 'https://www.demivolee.com',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
  );