import 'package:flutter/widgets.dart';
import 'package:labar_app/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
