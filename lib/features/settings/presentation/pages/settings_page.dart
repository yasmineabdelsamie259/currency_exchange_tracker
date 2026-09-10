import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/design_system/app_assets.dart';
import '../../../../core/design_system/theme/exchange_colors.dart';
import '../../domain/entities/app_theme_preference.dart';
import '../bloc/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.exchangeColors;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 36),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.heroBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.exchange,
                            width: 22,
                            colorFilter: ColorFilter.mode(
                              colors.heroAccent,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Settings', style: theme.textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Make Poundwise yours.',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose how the app looks on this device.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text('Appearance', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    BlocBuilder<ThemeCubit, AppThemePreference>(
                      builder: (context, preference) => Column(
                        children: [
                          _ThemeOption(
                            preference: AppThemePreference.system,
                            selected: preference,
                            icon: Icons.brightness_auto_outlined,
                            title: 'Use device setting',
                            description: 'Match your system appearance.',
                          ),
                          const SizedBox(height: 10),
                          _ThemeOption(
                            preference: AppThemePreference.light,
                            selected: preference,
                            icon: Icons.light_mode_outlined,
                            title: 'Light mode',
                            description: 'Use a bright, clear interface.',
                          ),
                          const SizedBox(height: 10),
                          _ThemeOption(
                            preference: AppThemePreference.dark,
                            selected: preference,
                            icon: Icons.dark_mode_outlined,
                            title: 'Dark mode',
                            description: 'Use a calm, low-light interface.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text('About', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.currency_exchange_outlined,
                              color: scheme.primary,
                            ),
                            title: const Text('Exchange rates'),
                            subtitle: const Text('Shown relative to EGP.'),
                          ),
                          Divider(height: 1, color: scheme.outlineVariant),
                          const ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text('Poundwise'),
                            subtitle: Text('Version 0.1.0'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.preference,
    required this.selected,
    required this.icon,
    required this.title,
    required this.description,
  });

  final AppThemePreference preference;
  final AppThemePreference selected;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final selectedOption = preference == selected;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.read<ThemeCubit>().select(preference),
        leading: Icon(
          icon,
          color: selectedOption ? scheme.primary : scheme.onSurfaceVariant,
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(
          selectedOption ? Icons.check_circle : Icons.circle_outlined,
          color: selectedOption ? scheme.primary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
