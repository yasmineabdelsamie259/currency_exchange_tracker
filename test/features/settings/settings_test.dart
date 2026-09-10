import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poundwise/core/design_system/theme/app_theme.dart';
import 'package:poundwise/core/di/service_locator.dart';
import 'package:poundwise/core/storage/key_value_store.dart';
import 'package:poundwise/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:poundwise/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:poundwise/features/settings/domain/entities/app_theme_preference.dart';
import 'package:poundwise/features/settings/domain/usecases/load_theme_preference.dart';
import 'package:poundwise/features/settings/domain/usecases/save_theme_preference.dart';
import 'package:poundwise/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:poundwise/features/settings/presentation/pages/settings_page.dart';

final class _MemoryStore implements KeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> remove(String key) async => values.remove(key);

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

ThemeCubit _cubit(_MemoryStore store) {
  final repository = SettingsRepositoryImpl(SettingsLocalDataSource(store));
  return ThemeCubit(
    loadThemePreference: LoadThemePreference(repository),
    saveThemePreference: SaveThemePreference(repository),
  );
}

void main() {
  test('persists the selected appearance preference', () async {
    final store = _MemoryStore();
    final first = _cubit(store);
    await first.select(AppThemePreference.dark);
    await first.close();

    final restored = _cubit(store);
    await restored.load();
    expect(restored.state, AppThemePreference.dark);
    expect(restored.themeMode, ThemeMode.dark);
    await restored.close();
  });

  testWidgets('switches to dark mode from settings', (tester) async {
    final cubit = _cubit(_MemoryStore());
    await serviceLocator.reset();
    serviceLocator.registerSingleton<ThemeCubit>(
      cubit,
      dispose: (cubit) => cubit.close(),
    );
    addTearDown(serviceLocator.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const SettingsPage(),
      ),
    );

    expect(find.text('Use device setting'), findsOneWidget);
    await tester.tap(find.text('Dark mode'));
    await tester.pump();
    expect(cubit.state, AppThemePreference.dark);
  });
}
