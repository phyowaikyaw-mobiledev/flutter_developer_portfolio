import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF141414);
  static const cardBg = Color(0xFF1E1E1E);
  static const primary = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF1E40AF);
  static const primaryLight = Color(0xFF60A5FA);
  static const purple = Color(0xFF7C3AED);
  static const surface = Color(0xFF1A1A1A);
  static const border = Color(0xFF2A2A2A);
  static const accentTeal = Color(0xFF2DD4BF);
  static const activeGreen = Color(0xFF22C55E);
  static const textMuted = Color(0xFF9CA3AF);

  static const statusLive = Color(0xFF10B981);
  static const statusLaunching = Color(0xFFF59E0B);
  static const statusArchived = Color(0xFF64748B);
}

class AppStrings {
  static const name = 'PHYO WAI KYAW';
  static const role = 'Flutter Developer';
  static const location = 'Chonburi, Thailand';
  static const avatarAsset = 'assets/images/avatar.png';
  static const email    = 'phyowalkyawdeveloper@gmail.com';
  static const phone    = '+66-626-509163';
  static const phoneTel = 'tel:+66626509163';
  static const github   = 'https://github.com/phyowaikyaw-mobiledev';
  static const linkedin = 'https://www.linkedin.com/in/phyowaikyaw-dev';
  static const facebook = 'https://facebook.com/learnersgateway30';
  static const telegramUsername = 'andrew_mobiledev';
  static const telegram = 'https://t.me/andrew_mobiledev';
  static const teamsEmail = 'phyowaikyawdeveloper@gmail.com';
  static const teamsChat =
      'https://teams.microsoft.com/l/chat/0/0?users=phyowaikyawdeveloper@gmail.com';
  static const cvUrl    = 'https://drive.google.com/file/d/1ZeB1Dbe9t7l79XY_vOO1INeplqLwX-LO/view?usp=drive_link';
  static const universityFirstYearDocUrl =
      'https://drive.google.com/file/d/1j2ehBE5y-GhenuZbmv2N7wBQi4e6wolK/view?usp=drive_link';
  static const employmentCertificateUrl =
      'https://drive.google.com/file/d/1yoVfMMUhsb6qJadS-KtTSL1UOaeqNUxN/view?usp=drive_link';
  static const mapEmbedUrl =
      'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d7744!2d100.9240333!3d13.081811!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x30e29c22857c776b%3A0x55d422f353974154!2sPlum%20Condo%20Laem%20Chabang!5e0!3m2!1sen!2sth!4v1720000000000!5m2!1sen!2sth';
  static const mapOpenUrl = 'https://maps.app.goo.gl/YdaXthGmHca6FVfN7';
  static const mapStaticPreviewUrl =
      'https://staticmap.openstreetmap.de/staticmap.php?center=13.081811,100.9240333&zoom=14&size=800x360&maptype=mapnik';

  static const contactEmailTo = 'phyowalkyawdeveloper@gmail.com';
  static const emailJsPublicKey = '6LnQN9vMawASGqMWn';
  static const emailJsServiceId = 'service_fqs28er';
  static const emailJsTemplateId = 'template_4sp428s';

  static bool get isEmailJsConfigured =>
      emailJsPublicKey != 'YOUR_PUBLIC_KEY' &&
      emailJsServiceId != 'YOUR_SERVICE_ID' &&
      emailJsTemplateId != 'YOUR_TEMPLATE_ID';
}

class PortfolioFontSizes {
  static const double body = 16;
  static const double secondary = 15;
  static const double label = 14;
  static const double caption = 12;
}
