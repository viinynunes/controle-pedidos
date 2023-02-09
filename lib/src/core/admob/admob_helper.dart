import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobHelper {
  static String get bannerUnitId => 'ca-app-pub-3940256099942544/6300978111';

  static String get interstitialUnitId =>
      'ca-app-pub-3940256099942544/5354046379';

  static initialization() {
    MobileAds.instance.initialize();
  }

  static BannerAd getBannerAd() {
    return BannerAd(
      adUnitId: bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('Banner loaded');
        },
        onAdFailedToLoad: (ad, error) {
          log('Banner Failed to Load', error: error);
          ad.dispose();
        },
        onAdOpened: (ad) => log('Ad Opened'),
        onAdClosed: (ad) => log('Ad Closed'),
      ),
    );
  }

  static Future<void> getInterstitialAd(RewardedInterstitialAd ad) {
    return RewardedInterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd rewarded) {
            log('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            ad = rewarded;
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }
}
