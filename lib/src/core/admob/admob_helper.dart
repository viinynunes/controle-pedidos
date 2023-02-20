import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobHelper {
  static String get bannerUnitId => 'ca-app-pub-7284245723023607/4730913507';

  static String get interstitialUnitId =>
      'ca-app-pub-7284245723023607/6788754108';

  static String get rewardedUnitId => 'ca-app-pub-7284245723023607/8557400845';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  int timesAttemptToLoad = 0;

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

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            timesAttemptToLoad = 0;
            log('Interstitial AD loaded');
          },
          onAdFailedToLoad: (error) {
            timesAttemptToLoad += 1;
            _interstitialAd = null;

            if (timesAttemptToLoad <= 2) {
              createInterstitialAd();
            }
          },
        ));
  }

  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        log('Rewarded Ad Loaded');
        _rewardedAd = ad;
      }, onAdFailedToLoad: (error) {
        log('Failed to load rewarded ad', error: error);
        _rewardedAd = null;
      }),
    );
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        log('Rewarded AD showing');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('Rewarded AD failed to show', error: error);
        ad.dispose();
        createRewardedAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        log('Rewarded AD disposed');
        ad.dispose();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (_, __) {});

    _rewardedAd = null;
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        log('Interstitial AD showing');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('Interstitial AD failed to show', error: error);
        ad.dispose();
        createInterstitialAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        log('Interstitial AD disposed');
        ad.dispose();
      },
    );

    _interstitialAd!.show();

    _interstitialAd = null;
  }
}
