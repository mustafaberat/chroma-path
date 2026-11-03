import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';

class BannerSlot extends StatelessWidget {
  const BannerSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BannerAd?>(
      valueListenable: AdService.instance.banner,
      builder: (context, ad, _) {
        if (ad == null) return const SizedBox(height: 50);
        return SizedBox(
          height: ad.size.height.toDouble(),
          width: ad.size.width.toDouble(),
          child: AdWidget(ad: ad),
        );
      },
    );
  }
}
