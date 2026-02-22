import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'app_theme_mode.dart';

@lazySingleton
class ThemeCubit extends HydratedCubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.system);

  void setThemeMode(AppThemeMode mode) => emit(mode);

  void cycleThemeMode() {
    final nextMode = switch (state) {
      AppThemeMode.system => AppThemeMode.light,
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.system,
    };
    emit(nextMode);
  }

  ThemeMode get flutterThemeMode {
    return switch (state) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  @override
  AppThemeMode? fromJson(Map<String, dynamic> json) {
    try {
      return AppThemeMode.fromJson(json['mode'] as String);
    } catch (_) {
      return AppThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppThemeMode state) {
    return {'mode': state.toJson()};
  }
}
