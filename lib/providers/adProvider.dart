import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class AdProvider with ChangeNotifier {
  BannerAd? _banner;
  bool _isBannerReady = false;
  bool _isLoading = false;

  bool get isBannerReady => _isBannerReady;
  BannerAd? get banner => _banner;

  Future<void> loadBanner(BuildContext context) async {
    // Не загружаем, если уже загружено или идёт загрузка
    if (_isBannerReady || _isLoading) return;

    _isLoading = true;
    notifyListeners(); // опционально, если хотите показывать индикатор загрузки

    final screenWidth = MediaQuery.of(context).size.width.round();
    final adSize = BannerAdSize.sticky(width: screenWidth);

    _banner = BannerAd(
      adUnitId: 'demo-banner-yandex',
      adSize: adSize,
      adRequest: const AdRequest(),
      onAdLoaded: () {
        _isBannerReady = true;
        _isLoading = false;
        notifyListeners();
        debugPrint('YandexAds: Banner loaded');
      },
      onAdFailedToLoad: (error) {
        _isBannerReady = false;
        _isLoading = false;
        notifyListeners();
        debugPrint('YandexAds: Banner failed to load: $error');
      },
      onAdClicked: () {
        debugPrint('YandexAds: Banner clicked');
      },
      onLeftApplication: () {
        debugPrint('YandexAds: Left application');
      },
      onReturnedToApplication: () {
        debugPrint('YandexAds: Returned to application');
      },
      onImpression: (impressionData) {
        debugPrint('YandexAds: Impression - ${impressionData.getRawData()}');
      },
    );

    try {
      await _banner!.loadAd();
    } catch (e) {
      debugPrint('YandexAds: Exception during load: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void disposeBanner() {
    _banner?.destroy();
    _banner = null;
    _isBannerReady = false;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disposeBanner();
    super.dispose();
  }
}