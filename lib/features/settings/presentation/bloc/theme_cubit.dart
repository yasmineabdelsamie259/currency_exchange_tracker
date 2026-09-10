import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_theme_preference.dart';
import '../../domain/usecases/load_theme_preference.dart';
import '../../domain/usecases/save_theme_preference.dart';

final class ThemeCubit extends Cubit<AppThemePreference> {
  ThemeCubit({
    required this._loadThemePreference,
    required this._saveThemePreference,
  }) : super(AppThemePreference.system);

  final LoadThemePreference _loadThemePreference;
  final SaveThemePreference _saveThemePreference;

  Future<void> load() async => emit(await _loadThemePreference());

  Future<void> select(AppThemePreference preference) async {
    if (state == preference) return;
    emit(preference);
    await _saveThemePreference(preference);
  }

  ThemeMode get themeMode => switch (state) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
}
