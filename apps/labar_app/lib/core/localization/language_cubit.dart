import 'dart:ui';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LanguageCubit extends HydratedCubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void setLocale(Locale locale) {
    if (locale == state) return;
    emit(locale);
  }

  void toggleLanguage() {
    if (state.languageCode == 'en') {
      emit(const Locale('ha'));
    } else {
      emit(const Locale('en'));
    }
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    try {
      final languageCode = json['language_code'] as String?;
      if (languageCode == null) return null;
      return Locale(languageCode);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {'language_code': state.languageCode};
  }
}
