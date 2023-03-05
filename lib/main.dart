import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:InstaReels/Home.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? myAppOpenAd;

loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: "ca-app-pub-8947607922376336/2279313827", //Your ad Id from admob
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            myAppOpenAd = ad;
            myAppOpenAd!.show();
          },
          onAdFailedToLoad: (error) {}),
      orientation: AppOpenAd.orientationPortrait);
}

Future<void> main() async {
  await GetStorage.init();
  await MobileAds.instance.initialize();
  // loadAppOpenAd();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Reels Downloader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
