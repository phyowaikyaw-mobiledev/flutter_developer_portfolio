import 'package:flutter_test/flutter_test.dart';
import 'package:phyowaikyaw_portfolio/data/production_apps.dart';
import 'package:phyowaikyaw_portfolio/models/production_app.dart';

void main() {
  test('DrZon Medical Service is published with store links', () {
    final drZon = kProductionApps.firstWhere(
      (app) => app.title == 'DrZon Medical Service',
    );

    expect(drZon.releaseStatus, AppReleaseStatus.live);
    expect(
      drZon.playUrl,
      'https://play.google.com/store/apps/details?id=asia.rootstudio.drzon',
    );
    expect(
      drZon.appStoreUrl,
      'https://apps.apple.com/th/app/drzon-medical-service/id6762826790',
    );
    expect(drZon.isLive, isTrue);
    expect(drZon.slug, 'drzon-medical-service');
    expect(productionAppBySlug('drzon-medical-service'), drZon);
  });

  test('TeeXpress is in review without store links', () {
    final teeXpress = kProductionApps.firstWhere(
      (app) => app.title == 'TeeXpress',
    );

    expect(teeXpress.releaseStatus, AppReleaseStatus.inReview);
    expect(teeXpress.playUrl, isNull);
    expect(teeXpress.appStoreUrl, isNull);
    expect(teeXpress.isLive, isFalse);
    expect(teeXpress.gallery.length, 6);
    expect(teeXpress.gallery, contains('assets/images/teexpress_3.png'));
  });

  test('three production apps are live on stores', () {
    final liveApps =
        kProductionApps.where((app) => app.isLive).toList(growable: false);

    expect(liveApps.length, 3);
  });
}
