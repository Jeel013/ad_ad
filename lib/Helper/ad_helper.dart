import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdHelper {
  AdHelper._();
  CollectionReference users = FirebaseFirestore.instance.collection("user");

  static final AdHelper adHelper = AdHelper._();

  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  late RewardedAd rewardedAd;
  late AppOpenAd appOpenAd;

  Logger logger = Logger();

  late String bannerAdId;
  late String interstitialAdId;
  late String rewardedAdId;
  late String appOpenAdId;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String adCollection = "AD-IDS";

  Future<String> getAdId({required String docId}) async {
    DocumentSnapshot<Map<String, dynamic>> docs =
        await firestore.collection(adCollection).doc(docId).get();
    Map data = docs.data() as Map<String, dynamic>;
    return data['id'];
  }

  Future<void> loadAds() async {
    bannerAdId = await getAdId(docId: "Banner");
    logger.i("Banner Id = $bannerAdId");
    bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: bannerAdId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          logger.i('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          logger.e("AD Failed to load\nERROR: ${error.message}");
        },
      ),
      request: const AdRequest(),
    )..load();

    interstitialAdId = await getAdId(docId: "Interstitial");
    InterstitialAd.load(
      adUnitId: interstitialAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        interstitialAd = ad;
      }, onAdFailedToLoad: (error) {
        logger.e("error: ${error.message}");
      }),
    );

    rewardedAdId = await getAdId(docId: 'Reward');
    RewardedAd.load(
        adUnitId: rewardedAdId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
        }, onAdFailedToLoad: (error) {
          logger.e("error: ${error.message}");
        }));

    appOpenAdId = await getAdId(docId: "App-Open");
    AppOpenAd.load(
        adUnitId: appOpenAdId,
        request: AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              logger.i("App Open Ad Loaded");
            }, onAdFailedToLoad: (error) {
              logger.e("App-OPEN ERROR: ${error.message}");
        }),
        orientation: AppOpenAd.orientationPortrait);

  }


// loadBannerAd() async {
//
//
// }
//
// loadInterstitialAd() async{
//
// }
//
// loadRewardAd() async {
//
// }
}
