// В любом общем файле, например, helpers/ad_helper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:iskai/providers/adProvider.dart';

Widget buildAdBannerBottom(BuildContext context) {
  return Consumer<AdProvider>(
    builder: (context, adProvider, child) {
      if (adProvider.isBannerReady && adProvider.banner != null) {
        return SizedBox(
          height: 60,
          child: AdWidget(bannerAd: adProvider.banner!),
        );
      }
      return const SizedBox.shrink();
    },
  );
}