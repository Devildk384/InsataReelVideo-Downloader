import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:InstaReels/Controller/DownloadController.dart';
import 'package:InstaReels/DownloadedList.dart';
import 'package:InstaReels/GenrateVideoFromPath.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  DownloadController downloadController = Get.put(DownloadController());
  TextEditingController urlController = TextEditingController();
  late BannerAd _bannerAd;
  final bool _isBottomBannerAdLoaded = false;
  late AppOpenAd? myAppOpenAd;
late RewardedAd _rewardedAd;
bool _isRewardedAdLoaded= false;
   
late InterstitialAd _interstitialAd;
bool _isInterstitialAdLoaded = false;

@override
void initState() {
  super.initState();

   _bannerAd =BannerAd(
    adUnitId: "ca-app-pub-8947607922376336/5735343105",
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (_) {
        setState(() {
          // _isBottomBannerAdLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        setState(() {
          // _isBottomBannerAdLoaded = false;
        });
        ad.dispose();
      },
    ),
    request: const AdRequest(),
  )..load();

  // RewardedAd.load(
  //   adUnitId: "ca-app-pub-8947607922376336/5113360720",
  //   request: const AdRequest(),
  //   rewardedAdLoadCallback: RewardedAdLoadCallback(
  //     onAdLoaded: (ad) {
  //       _rewardedAd = ad;
  //       ad.fullScreenContentCallback = FullScreenContentCallback(
  //         onAdDismissedFullScreenContent: (ad) {
  //           setState(() {
  //             _isRewardedAdLoaded = false;
  //           });
  //         },
  //       );
  //       setState(() {
  //         _isRewardedAdLoaded = true;
  //       });
  //     },
  //     onAdFailedToLoad: (err) {
  //       setState(() {
  //         _isRewardedAdLoaded = false;
  //       });
  //     },
  //   ),
  // );

   InterstitialAd.load(
    adUnitId: "ca-app-pub-8947607922376336/2290357465",
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        _isInterstitialAdLoaded = true;
      },
      onAdFailedToLoad: (LoadAdError error) {
        _isInterstitialAdLoaded = false;
        _interstitialAd.dispose();
      },
    ),
  );
}


@override
void dispose() {
  _bannerAd.dispose();
  _interstitialAd.dispose();
  // _rewardedAd.dispose();
  super.dispose();
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Insta Reels Downloader",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
                onTap: () {
                  Get.to(DownloadedList());
                },
                child: Icon(
                  Icons.download,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                      //  Container(
                      //   height: 58,
                      //   child: AdWidget(ad: _bannerAd),
                      //  ),
       
                        // Padding(padding: EdgeInsets.all(5), child: AdWidget(ad: _bannerAd),),
  
                         GetBuilder(
                      init: downloadController,
                      builder: (_) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 150,
                              child: downloadController.path != null
                                  ? Container(
                                      child: GenrateVideoFrompath(
                                          downloadController.path ?? ""))
                                  : Center(child: Text("No recent download")),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextField(
                  controller: urlController,
                  autocorrect: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25),
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      hintText: "Paste instagram reel link here",
                      fillColor: Colors.white70),
                ),
              ),
              Obx(
                () => Container(
                  height: 100,
                  child: 
                  downloadController.processing.value
                      ? Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : Center(
                          child: InkWell(
                            onTap: () {
                              downloadController.downloadReal(
                                  urlController.text, context);
                                  if (_isInterstitialAdLoaded) {  
                          _interstitialAd.show();   // <- here
                            }
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              child: Center(
                                  child: Text(
                                "Download",
                                style: TextStyle(color: Colors.white),
                              )),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              // Container(
              //   height: 200,
              //   child: Center(child: Text("Made in ❤️ with Flutter")),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
