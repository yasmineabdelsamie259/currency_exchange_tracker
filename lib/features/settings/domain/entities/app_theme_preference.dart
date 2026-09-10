enum AppThemePreference {
  system,
  light,
  dark;

  String get storageValue => name;

  static AppThemePreference fromStorage(String? value) =>
      AppThemePreference.values
          .where((item) => item.name == value)
          .firstOrNull ??
      AppThemePreference.system;
}
