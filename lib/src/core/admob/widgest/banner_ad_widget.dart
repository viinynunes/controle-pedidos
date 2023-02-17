import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob_helper.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget(
      {Key? key,
      required this.showAd,
      required this.height,
      required this.width})
      : super(key: key);

  final bool showAd;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showAd,
      child: SizedBox(
        height: height,
        width: width,
        child: AdWidget(
          ad: AdMobHelper.getBannerAd()..load(),
        ),
      ),
    );
  }
}
