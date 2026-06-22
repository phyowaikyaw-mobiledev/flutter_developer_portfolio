# Phyo Wai Kyaw — Flutter Portfolio

Live portfolio showcasing production Flutter apps, selected projects, and engineering practices.

## Live

Live: [https://phyowaikyaw-portfolio.web.app](https://phyowaikyaw-portfolio.web.app)

## Production apps (store-shipped)

| App | Google Play | App Store |
|-----|-------------|-----------|
| **DrZon Medical Service** (healthcare) | [Play Store](https://play.google.com/store/apps/details?id=asia.rootstudio.drzon) | [App Store (TH)](https://apps.apple.com/th/app/drzon-medical-service/id6762826790) |
| **Phone King Plus** (retail loyalty) | [Play Store](https://play.google.com/store/apps/details?id=com.phonekingplus) | [App Store](https://apps.apple.com/app/phone-king-plus/id6738283921) |
| **VIE Pharma** (pharmaceutical sales) | In release pipeline | In release pipeline |
| **Secure Plus** (security) | In release pipeline | In release pipeline |

## Stack

- **Flutter / Dart** — cross-platform mobile & web
- **State:** BLoC / Cubit
- **Networking:** Dio (REST)
- **Backend:** Firebase (FCM, Firestore)
- **Routing:** go_router
- **Localization:** ARB / l10n

## Highlights

- 3 apps live on Google Play and the App Store (Myanmar / Thailand markets)
- Paid production work at Root Studio (Jan 2026–present)
- Architecture case study: DrZon — presentation → BLoC → repository → Dio API layer
- Curated project showcase (featured work + learning archive)

## Run locally

```bash
flutter pub get
flutter run -d chrome   # web
flutter run             # mobile device / emulator
```

## Tests

```bash
flutter test
flutter analyze
```

## Structure

```
lib/
  data/           # production apps, portfolio projects
  models/         # typed data models
  screens/        # home, work, experience, about, contact
  router/         # go_router shell + navigation
  widgets/        # shared UI
```

## Contact

- **Email:** phyowaikyaw.dev@gmail.com
- **LinkedIn / GitHub:** links on portfolio Contact page
