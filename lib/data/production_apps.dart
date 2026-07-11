import 'package:flutter/material.dart';
import '../models/production_app.dart';
import '../utils/constants.dart';

ProductionApp? productionAppBySlug(String slug) {
  for (final app in kProductionApps) {
    if (app.slug == slug) return app;
  }
  return null;
}

const kProductionApps = <ProductionApp>[
  ProductionApp(
    slug: 'phone-king-plus-customer',
    title: 'Phone King Plus Customer',
    fullBleedIcon: true,
    description:
        'Consumer-facing loyalty app for Phone King — customers scan to pay in-store, earn and redeem points, track membership tiers, and manage their profile. Live in production on Play Store & App Store, paired with the Phone King Plus Admin app used by store staff.',
    keyContributionPoints: [
      'OTP-based authentication flow — signup, login, forgot-password, with resend cooldown handling',
      'Scan-to-pay flow — customer scans a staff-generated QR to complete an in-store payment, protected by a PIN-entry step',
      'Rewards system — browse rewards, redeem via QR scan-to-confirm, and view claim/redemption history',
      'Member tier & points balance display, plus activity/transaction history',
      'Onboarding & splash flow — server-driven banner content shown before login, with image pre-caching for a smooth first launch',
      'Light/dark theme support and bilingual UI (English/Myanmar) via persisted user preferences',
      'Consumed a shared internal design system package (phoneking_design_system) across the app for consistent UI components with the Admin app',
      'Push notifications (Firebase Cloud Messaging), in-app update prompts, and profile management (change PIN, share app, contact branches, help & support)',
    ],
    iconAsset: 'assets/images/phoneking_icon.png',
    icon: Icons.phone_android,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLive,
    companyBadge: 'Root Studio Asia',
    tags: [
      'Flutter',
      'Dart',
      'Provider',
      'Dio (REST API)',
      'Firebase Cloud Messaging',
      'mobile_scanner',
      'qr_flutter',
      'pinput',
      'easy_localization',
      'json_serializable',
      'cached_network_image',
      'Shared internal design system package',
    ],
    impact:
        'Live in production and actively used by 1,000+ users across 4 countries — Myanmar, Thailand, Singapore, and the US. Forms the customer half of Phone King\'s full loyalty ecosystem, sharing a common QR payload contract and backend with the Admin app so points, payments, and redemptions stay in sync between customer and staff apps in real time.',
    challenges: [
      ProductionAppChallenge(
        title: 'Smooth first-launch experience',
        solution:
            'Cold-start splash could flash awkwardly before server-driven banner content loaded — solved by pre-caching the splash image and sequencing banner fetch before navigation, so the transition feels seamless rather than jumpy.',
      ),
      ProductionAppChallenge(
        title: 'OTP resend abuse/spam',
        solution:
            'Users could repeatedly hit "resend code" — implemented a cooldown-aware resend button and a dedicated exception type to handle and communicate the cooldown state cleanly.',
      ),
      ProductionAppChallenge(
        title: 'Consistent UI across two apps',
        solution:
            'Customer and Admin apps needed matching visual language without duplicating widgets — solved by extracting a shared local phoneking_design_system package consumed by both.',
      ),
    ],
    keyFeatures: [
      'OTP-based signup/login & forgot password',
      'Scan-to-pay (QR + PIN confirmation)',
      'Points balance & member tier tracking',
      'Reward browsing & redemption (QR scan-to-confirm)',
      'Transaction/activity history',
      'Light/dark theme toggle',
      'Bilingual UI (English/Myanmar)',
      'Push notifications & in-app update prompts',
      'Profile management (change PIN, share app, branch directory, help & support)',
    ],
    playUrl:
        'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_customer',
    appStoreUrl:
        'https://apps.apple.com/th/app/phoneking-plus/id6757488887',
    gallery: [
      'assets/images/pk.png',
      'assets/images/pk_1.png',
      'assets/images/pk_2.png',
      'assets/images/pk_3.png',
      'assets/images/pk_4.png',
      'assets/images/pk_5.png',
      'assets/images/pk_6.png',
      'assets/images/pk_7.png',
    ],
    releaseStatus: AppReleaseStatus.live,
    industries: [AppIndustry.retailCommerce],
  ),
  ProductionApp(
    slug: 'phone-king-plus-admin',
    title: 'Phone King Plus Admin',
    description:
        'Staff-facing companion app to Phone King Plus Customer — used by store staff to process in-store loyalty transactions: awarding points, handling top-ups, confirming reward redemptions, and tracking store performance. Live on Play Store & App Store.',
    keyContributionPoints: [
      'QR-based points award flow — staff generates a signed QR payload (invoice + point amount) for the customer app to scan and claim',
      'Reward redemption flow — QR scan-to-confirm for in-store reward pickups, with success/confirmation screens',
      'Staff-authorized top-up flow — PIN-protected transaction entry (via pinput) before processing a customer top-up',
      'Reporting dashboard — customer growth, popular rewards, and redemption summary over a selectable date range',
      'Bilingual staff interface (English/Myanmar) using easy_localization, plus session-timeout handling for idle staff sessions',
      'Built the BLoC-based state layer from scratch (custom lightweight BaseBloc on ChangeNotifier, distinct from the Provider-based Customer app)',
    ],
    iconAsset: 'assets/images/phoneking_admin_icon.png',
    icon: Icons.admin_panel_settings,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLive,
    companyBadge: 'Root Studio Asia',
    tags: [
      'Flutter',
      'Dart',
      'BLoC (ChangeNotifier-based)',
      'Dio (REST API)',
      'json_serializable',
      'mobile_scanner',
      'qr_flutter',
      'pinput',
      'easy_localization',
      'cached_network_image',
      'permission_handler',
    ],
    impact:
        'Live in production, giving store staff a dedicated operational tool to run the loyalty program day-to-day — decoupled from the customer-facing app so staff actions (points, top-ups, redemptions) stay secured and auditable, while feeding the same backend reporting used by management.',
    challenges: [
      ProductionAppChallenge(
        title: 'Two apps, one loyalty system',
        solution:
            'Customer and Admin needed to interoperate (Admin generates a QR, Customer app claims it) without sharing a codebase — solved with a shared QR payload contract (QrPayloadVO) that both apps encode/decode independently.',
      ),
      ProductionAppChallenge(
        title: 'Securing staff-initiated transactions',
        solution:
            'Top-ups and redemptions involve real money/points, so a PIN-confirmation step was added before any transaction is finalized, reducing risk of accidental or unauthorized submissions.',
      ),
      ProductionAppChallenge(
        title: 'Idle staff sessions on shared store devices',
        solution:
            'Store tablets are often left logged in — implemented a session-timeout dialog that forces re-authentication after inactivity.',
      ),
    ],
    keyFeatures: [
      'Staff login & session management',
      'Generate & display points-award QR codes',
      'Scan-to-confirm reward redemption',
      'PIN-protected top-up processing',
      'Sales & performance reports (customer growth, popular rewards, redemption summary)',
      'Branch/contact directory',
      'Bilingual UI (English/Myanmar)',
      'Push notifications',
    ],
    playUrl:
        'https://play.google.com/store/apps/details?id=asia.rootstudio.phone_king_admin',
    appStoreUrl:
        'https://apps.apple.com/th/app/phoneking-plus-admin/id6757606298',
    gallery: [
      'assets/images/pka.png',
      'assets/images/pka_1.png',
      'assets/images/pka_2.png',
      'assets/images/pka_3.png',
      'assets/images/pka_4.png',
      'assets/images/pka_5.png',
    ],
    releaseStatus: AppReleaseStatus.live,
    industries: [AppIndustry.retailCommerce],
  ),
  ProductionApp(
    slug: 'drzon-medical-service',
    title: 'DrZon Medical Service',
    description:
        'Dual-role (Customer & Admin) medical service application built in Flutter, connecting patients with hospital services — appointment booking, medical record access, and health content delivery. Live in production on both Play Store and App Store.',
    keyContributionPoints: [
      'Built separate home flows for Customer & Admin — patient records, appointment tracking, hospital/branch listing, and referral system',
      'Firebase Cloud Messaging + local notifications integration (foreground/background message handling, custom notification channel)',
      'Bilingual localization (English/Myanmar) with custom Burmese font, using Flutter\'s i18n system',
      'REST API layer built on Dio — modular API classes for auth, appointments, patient records, medical records, content, and notifications',
      'In-app soft update system with 24-hour throttle to avoid repeated update prompts',
      'PDF viewer for medical records, image/file picker, share functionality, and calendar integration for appointment reminders',
    ],
    iconAsset: 'assets/images/dr_zon.png',
    icon: Icons.local_hospital,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLive,
    companyBadge: 'Root Studio Asia',
    tags: [
      'Flutter',
      'Dart',
      'Provider',
      'Dio (REST API)',
      'Firebase Cloud Messaging',
      'Flutter Local Notifications',
      'Syncfusion PDF Viewer',
      'WebView Flutter',
      'YouTube Player',
      'Shared Preferences',
      'Flutter Localizations (i18n)',
      'Material Design',
    ],
    impact:
        'Built and shipped end-to-end — from push notifications to bilingual localization. Live in production and actively used across multiple countries (Myanmar, Thailand, Singapore), with state cleanly managed across 8 providers keeping Customer and Admin flows fully decoupled in a single codebase.',
    challenges: [
      ProductionAppChallenge(
        title: 'Push notification reliability across app states',
        solution:
            'Firebase messages behave differently in foreground/background/terminated states — solved with a dedicated top-level background handler plus local-notifications fallback so alerts are never missed.',
      ),
      ProductionAppChallenge(
        title: 'Update-prompt fatigue',
        solution:
            'Optional update dialogs were showing on every launch — fixed with a SharedPreferences-based throttle limiting it to once per 24 hours.',
      ),
      ProductionAppChallenge(
        title: 'One codebase, two very different roles',
        solution:
            'Customer and Admin needed separate navigation and permissions — handled with role-based routing at auth-check time, keeping both flows isolated while sharing core infrastructure.',
      ),
    ],
    keyFeatures: [
      'Customer & Admin login flows',
      'Patient record management',
      'Appointment booking & tracking',
      'Hospital/branch directory',
      'Referral system',
      'Push notifications with deep-link navigation',
      'Health articles & video content',
      'Bilingual UI (English/Myanmar)',
    ],
    playUrl:
        'https://play.google.com/store/apps/details?id=asia.rootstudio.drzon',
    appStoreUrl:
        'https://apps.apple.com/th/app/drzon-medical-service/id6762826790',
    gallery: [
      'assets/images/drzon.png',
      'assets/images/drzon_1.png',
      'assets/images/drzon_2.png',
      'assets/images/drzon_3.png',
      'assets/images/drzon_4.png',
      'assets/images/drzon_5.png',
      'assets/images/drzon_6.png',
      'assets/images/drzon_7.png',
    ],
    releaseStatus: AppReleaseStatus.live,
    industries: [AppIndustry.healthcare],
  ),
  ProductionApp(
    slug: 'teexpress',
    title: 'TeeXpress',
    description:
        'Merchant-facing delivery management app for TeeXpress — lets business customers create delivery orders (single & multi-order), track shipments, calculate shipping rates, and reconcile receivable/payable payments with exportable reports. Currently in review for Play Store release.',
    keyContributionPoints: [
      'Order creation flow — single & multi-order (batch) creation with township selection, shipping rate calculation, and COD handling',
      'Order tracking — my orders list with detail view and status tracking',
      'Receivable/Payable ledger — paginated, filterable (paid/unpaid, receivable/payable) merchant payment tracking with debounced search',
      'Export system — merchant payment reports exportable to both Excel and PDF, with local file storage handling',
      'Auth flow — email-based signup/login with OTP verification and forgot-password/reset flow',
      'Nearby branch locator, shipping rate calculator, and in-app terms & conditions with PDF download',
      'Push/local notifications for order status updates',
      'Built on a custom BLoC (ChangeNotifier-based) state layer, consistent with the Admin-side architecture pattern used across Root Studio Asia projects',
    ],
    iconAsset: 'assets/images/teexpress_icon.png',
    icon: Icons.local_shipping,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLaunching,
    companyBadge: 'Root Studio Asia',
    tags: [
      'Flutter',
      'Dart',
      'BLoC (ChangeNotifier-based)',
      'Dio (REST API)',
      'json_serializable',
      'excel',
      'pdf',
      'syncfusion_flutter_pdfviewer',
      'mobile_scanner',
      'cached_network_image',
    ],
    impact:
        'Built end-to-end merchant tooling for a delivery business — from order creation through financial reconciliation and exportable reporting — currently in Play Store review ahead of production launch.',
    challenges: [
      ProductionAppChallenge(
        title: 'Paginated ledger with live filtering',
        solution:
            'The receivable/payable list needed to support tab switching (receivable/payable), paid-status filters, and search simultaneously without re-fetching everything — solved with a debounced search timer and page-tracking state (_currentPage, hasMore) to load incrementally.',
      ),
      ProductionAppChallenge(
        title: 'Merchant-friendly financial exports',
        solution:
            'Merchants needed payment data in formats they could actually use for accounting — built dual export paths (Excel via excel package, PDF via pdf/Syncfusion) from the same underlying export data model, so both formats stay in sync.',
      ),
      ProductionAppChallenge(
        title: 'Efficient multi-order creation',
        solution:
            'Business customers often ship to many recipients at once — designed a dedicated multi-order flow so townships, profile info, and shipping rates only need to be fetched once and reused across all sub-orders in a batch.',
      ),
    ],
    keyFeatures: [
      'Email/OTP-based signup, login & password reset',
      'Single & multi-order (batch) delivery order creation',
      'Shipping rate calculator',
      'Order tracking & history',
      'Receivable/Payable payment ledger (filterable, searchable)',
      'Excel & PDF export of payment reports',
      'Nearby branch locator',
      'Push notifications',
      'In-app terms & conditions (with PDF download)',
    ],
    gallery: [
      'assets/images/teexpress.png',
      'assets/images/teexpress_1.png',
      'assets/images/teexpress_2.png',
      'assets/images/teexpress_3.png',
      'assets/images/teexpress_4.png',
      'assets/images/teexpress_5.png',
    ],
    releaseStatus: AppReleaseStatus.inReview,
    industries: [AppIndustry.logisticsSecurity],
  ),
  ProductionApp(
    slug: 'pan-aesthetic',
    title: 'PAN Aesthetic',
    description:
        'All-in-one beauty & aesthetic clinic app — customers browse and book treatments, shop skincare products, manage a digital wallet with QR top-up, and earn/redeem loyalty points. Currently in pre-launch development.',
    keyContributionPoints: [
      'Treatment booking system — browse treatments/experts, book appointments, reschedule with policy rules, and online consultation tracking',
      'E-commerce module — product store with categories, cart, checkout, and order tracking, sharing checkout UI patterns with the treatment-booking checkout flow',
      'Digital wallet & top-up — MMQR (Myanmar QR standard) top-up integration with AYA Bank, plus PIN-protected treatment/reward checkout',
      'Loyalty program — points balance, membership tiers, rewards catalog with redemption and quantity selection',
      'Session security — JWT expiry checking (client-side, with clock-skew tolerance) and new-device-login detection with a grace period to avoid false "session revoked" alerts on legitimate re-logins',
      'Reviews & feedback system across products, treatments, and rewards',
      'Push notifications (FCM foreground + background handlers) and in-app update prompts',
      'Bilingual UI (English/Myanmar) using Flutter\'s native l10n/ARB system',
    ],
    iconAsset: 'assets/images/pan_icon.png',
    icon: Icons.shopping_bag,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLaunching,
    companyBadge: 'Root Studio Asia',
    tags: [
      'Flutter',
      'Dart',
      'Provider',
      'Dio (REST API)',
      'Firebase Cloud Messaging',
      'mobile QR payment (MMQR/AYA Pay)',
      'qr_flutter',
      'pinput',
      'json_serializable',
      'Flutter Localizations (i18n)',
      'Clean/Layered Architecture',
    ],
    impact:
        'Built one of the most feature-complete apps in the portfolio — combining e-commerce, appointment booking, digital wallet, and loyalty into a single cohesive clean-architecture codebase (core/data/presentation layers), ready for launch.',
    challenges: [
      ProductionAppChallenge(
        title: 'False "session expired" alerts on legitimate logins',
        solution:
            'A new login on the same device could trigger a "new device" session-revoked signal from the backend — solved with a short post-login grace period that suppresses displacement alerts right after a legitimate sign-in.',
      ),
      ProductionAppChallenge(
        title: 'Local JWT expiry checking without a network round-trip',
        solution:
            'Needed to know if a session token was stale before firing an API call — implemented a lightweight client-side JWT decoder (with clock-skew tolerance) that reads the exp claim directly, avoiding unnecessary failed requests.',
      ),
      ProductionAppChallenge(
        title: 'Two very different checkout flows, one consistent UX',
        solution:
            'Product checkout and treatment checkout have different data (cart items vs. booking details) but needed to feel identical to the user — solved by sharing common checkout UI components (order summary, points-to-use section, PIN dialog) across both flows.',
      ),
    ],
    keyFeatures: [
      'Treatment/appointment booking with reschedule & online consultation',
      'Product store with cart & checkout',
      'Digital wallet with MMQR top-up (AYA Pay)',
      'Points, membership tiers & rewards redemption',
      'Order & appointment history tracking',
      'Reviews & feedback (products, treatments, rewards)',
      'Bilingual UI (English/Myanmar)',
      'Push notifications & in-app update prompts',
    ],
    gallery: [
      'assets/images/pan.png',
      'assets/images/pan_1.png',
      'assets/images/pan_2.png',
      'assets/images/pan_3.png',
      'assets/images/pan_4.png',
      'assets/images/pan_5.png',
      'assets/images/pan_6.png',
      'assets/images/pan_7.png',
      'assets/images/pan_8.png',
      'assets/images/pan_9.png',
      'assets/images/pan_10.png',
    ],
    releaseStatus: AppReleaseStatus.launchingSoon,
    industries: [AppIndustry.retailCommerce, AppIndustry.healthcare],
  ),
  ProductionApp(
    slug: 'vie-pharma',
    title: 'VIE Pharma',
    description:
        'Multi-app pharmaceutical distribution & sales platform built as a Flutter monorepo — three apps (Admin, Promoter/Medical Rep, and a shared design package) sharing a common architecture for managing distributors, medical representative field reports, commissions, warehouse stock, and a gift/rewards program.',
    keyContributionPoints: [
      'Architected a monorepo with a shared package (shared) providing common theme, typography, responsive scaling, localization, and reusable auth widgets (OTP input, password field, auth layout) consumed by both Admin and Promoter apps',
      'Built both apps on a consistent clean layered architecture: core (network/routing/storage) → data (models & repositories) → presentation (pages & providers) — keeping business logic, data access, and UI cleanly separated',
      'Admin app: multi-role auth (login, group-owner role with OTP verification), dashboards (sales/revenue charts, warehouse stock levels, group performance), commission request/payout workflows, distributor inquiry & contract management, MR (medical rep) field-report review',
      'Promoter app: medical rep field reporting (doctor visits, interest ratings, MR report submission/edit), commission fill/out workflows, gift & rewards store, product catalog with cart/checkout, distributor application flow',
      'Custom ApiClient/ApiEndpoints/ApiException layer and repository pattern replicated consistently across both apps for REST communication',
      'App-wide responsive scaling system (AppScale/VieAppBuilder) so UI scales consistently across device sizes without relying on system font scaling',
    ],
    iconAsset: 'assets/images/vie_icon.png',
    icon: Icons.medical_services,
    role: 'Flutter Developer',
    statusColor: AppColors.statusLaunching,
    companyBadge: 'Root Studio Asia',
    tags: [
      'Flutter',
      'Dart',
      'Provider',
      'Dio (REST API)',
      'Monorepo / shared package architecture',
      'flutter_secure_storage',
      'Clean/Layered Architecture (core-data-presentation)',
      'Repository Pattern',
    ],
    impact:
        'Designed and built the shared foundation (shared package) that both Admin and Promoter apps are built on top of — meaning UI consistency, localization, and auth flows only need to be maintained in one place across the whole platform. Currently in pre-launch development ("Launching Soon").',
    challenges: [
      ProductionAppChallenge(
        title: 'Duplicated UI/logic across two separate apps',
        solution:
            'Rather than copy-pasting theme, auth widgets, and layout code between Admin and Promoter, extracted a local shared package (path: ../../packages/shared) that both apps depend on — a single source of truth for design tokens and common auth UI.',
      ),
      ProductionAppChallenge(
        title: 'Multiple distinct user roles in one system',
        solution:
            'Admin, Group Owner, Promoter, Distributor, and Vendor each needed different auth flows and dashboards — solved with role-based login/routing (role_selection_page, group_owner_login_page) and per-role provider sets, keeping each role\'s logic isolated but sharing the same underlying repositories.',
      ),
      ProductionAppChallenge(
        title: 'Consistent scaling across devices',
        solution:
            'Instead of relying on OS-level font scaling (which breaks custom-designed UI), built a custom AppScale/VieAppBuilder layer that scales the whole theme (icons, inputs, buttons, text) from a reference device size, giving predictable UI on any screen.',
      ),
    ],
    keyFeatures: [
      'Admin — Multi-role authentication (Admin, Group Owner)',
      'Admin — Sales/revenue dashboards & warehouse stock tracking',
      'Admin — Commission request & payout management',
      'Admin — Distributor inquiry & contract workflow',
      'Admin — MR (medical rep) report review',
      'Promoter — Doctor visit / MR field reporting with interest ratings',
      'Promoter — Commission fill/out & payout tracking',
      'Promoter — Gift & rewards store',
      'Promoter — Product catalog with cart & checkout',
      'Promoter — Distributor application flow',
      'Shared — Bilingual localization',
      'Shared — OTP-based authentication',
      'Shared — Consistent theming via shared design package',
    ],
    gallery: [
      'assets/images/vie.png',
      'assets/images/vie_1.png',
      'assets/images/vie_2.png',
      'assets/images/vie_3.png',
      'assets/images/vie_4.png',
      'assets/images/vie_5.png',
      'assets/images/vie_6.png',
      'assets/images/vie_7.png',
      'assets/images/vie_8.png',
    ],
    releaseStatus: AppReleaseStatus.launchingSoon,
    industries: [AppIndustry.retailCommerce],
  ),
  ProductionApp(
    slug: 'secure-plus-cctv',
    title: 'Secure Plus CCTV',
    description:
        'Dual-role (Customer & Owner) CCTV installation service app built solo as a freelance project for a family business — customers request quotes, book installations, and track invoices, while the owner runs the entire operation (service requests, maintenance tickets, project portfolio, customer directory, quotes/vouchers, reviews, and app content) from a dedicated admin dashboard.',
    keyContributionPoints: [
      'Solo-built the entire app end-to-end — architecture, feature design, and implementation — as a freelance project',
      'Feature-based clean architecture (features/<role>/<feature>/data-presentation) with BLoC/Cubit state management throughout',
      'Customer side: service request form with map-based location picker (camera count, indoor/outdoor, remote view, audio needs, preferred schedule, photo upload), maintenance ticket submission, completed-projects showcase, invoices/payment status view, contact/about page',
      'Owner side: dashboard, service request management, maintenance ticket handling, project portfolio management, customer directory (auto-aggregated from requests/tickets), reviews moderation, voucher/quote builder with PDF export, content management (welcome carousel, about-us text/images), and account settings',
      'PIN-based authentication with role selection (Customer vs Owner) at login',
      'Interactive location picker using flutter_map + OpenStreetMap tiles with Nominatim reverse-geocoding (no API key needed) — replaced an earlier Google Maps approach',
      'Branded PDF voucher/invoice generation (itemized line items, discounts, payment status) using the pdf package, styled to the Secure Plus navy/cyan palette',
      'Firebase backend — Firestore for data, Firebase Storage/Cloudinary for images, Firebase Cloud Messaging + local notifications for push alerts (foreground and background)',
      'Bilingual UI (English/Myanmar) using Flutter\'s native l10n system',
      'go_router-based declarative routing with auth-aware redirects between customer and owner flows',
    ],
    iconAsset: 'assets/images/secure_plus.jpg',
    icon: Icons.security,
    role: 'Freelance Developer',
    statusColor: AppColors.statusLaunching,
    companyBadge: 'Freelance',
    tags: [
      'Flutter',
      'Dart',
      'flutter_bloc / Cubit',
      'go_router',
      'Firebase (Firestore, Storage, Auth, FCM)',
      'flutter_local_notifications',
      'Cloudinary',
      'flutter_map + OpenStreetMap (Nominatim geocoding)',
      'pdf / printing',
      'Hive (local storage)',
      'Equatable',
      'Flutter Localizations (i18n)',
      'google_fonts',
      'connectivity_plus',
    ],
    impact:
        'Delivered a complete, production-ready business tool solo for a family member\'s CCTV installation business — covering the full customer journey (quote request → booking → maintenance → invoice) and giving the business owner a real admin suite to manage requests, tickets, customers, quotes/vouchers, reviews, and marketing content without needing separate software.',
    challenges: [
      ProductionAppChallenge(
        title: 'One app, two very different users (customer vs business owner)',
        solution:
            'Solved with a role-selection screen at entry and fully separated customer/ and owner/ feature modules under a shared core, so each role only sees relevant navigation and screens.',
      ),
      ProductionAppChallenge(
        title: 'Building a usable voucher/quote builder for a non-technical business owner',
        solution:
            'Designed a simple line-item model (description, quantity, unit price) with fixed/percentage discounts and auto-calculated totals, plus one-tap branded PDF export so the owner can generate and share professional quotes and invoices without manual math or design work.',
      ),
      ProductionAppChallenge(
        title: 'Replacing Google Maps mid-project without a paid API key',
        solution:
            'Migrated the location picker to flutter_map with OpenStreetMap tiles and free Nominatim reverse-geocoding, keeping tap-to-pick-location and address lookup working with no billing dependency.',
      ),
      ProductionAppChallenge(
        title: 'Giving the owner a customer overview with no dedicated "customers" data',
        solution:
            'Synthesized a CustomerProfile (name, phone, total requests, last activity) on the fly by aggregating each customer\'s existing service_requests and tickets documents, avoiding schema duplication.',
      ),
      ProductionAppChallenge(
        title: 'End-to-end ownership as a solo freelancer',
        solution:
            'With no senior developer to review architecture decisions, adopted a strict feature-first folder structure (data/presentation split per feature) early on to keep the codebase navigable as features grew.',
      ),
    ],
    keyFeatures: [
      'Role-based login (Customer / Owner) with PIN auth',
      'Service request form with map-based location picker and photo upload',
      'Maintenance ticket submission & tracking',
      'Completed-projects showcase',
      'Customer invoices/payment status view',
      'Owner dashboard with request/ticket management',
      'Customer directory (auto-aggregated profiles)',
      'Reviews moderation (approve/reject customer & owner reviews)',
      'Voucher/quote builder with itemized pricing, discounts, and PDF export',
      'Content management (welcome carousel, about-us)',
      'Push notifications (foreground + background)',
      'Bilingual UI (English/Myanmar)',
    ],
    gallery: [
      'assets/images/secure_plus.png',
      'assets/images/secure_plus_1.png',
      'assets/images/secure_plus_2.png',
      'assets/images/secure_plus_3.png',
      'assets/images/secure_plus_4.png',
      'assets/images/secure_plus_5.png',
      'assets/images/secure_plus_6.png',
      'assets/images/secure_plus_7.png',
      'assets/images/secure_plus_8.png',
    ],
    releaseStatus: AppReleaseStatus.launchingSoon,
    fullWidth: true,
    industries: [AppIndustry.logisticsSecurity],
  ),
];
