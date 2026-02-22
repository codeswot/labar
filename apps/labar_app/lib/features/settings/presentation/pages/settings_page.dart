import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/session/session_cubit.dart';
import 'package:labar_app/core/theme/app_theme_mode.dart';
import 'package:labar_app/core/theme/theme_cubit.dart';
import 'package:labar_app/core/localization/language_cubit.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:ui_library/ui_library.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _ThemeSection(),
            const SizedBox(height: 16),
            _LanguageSection(),
            const SizedBox(height: 16),
            _InfoSection(),
            const SizedBox(height: 32),
            _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class _ThemeSection extends StatefulWidget {
  const _ThemeSection();

  @override
  State<_ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends State<_ThemeSection> {
  bool _showDropdown = false;

  @override
  Widget build(BuildContext context) {
    return MoonDropdown(
      show: _showDropdown,
      constrainWidthToChild: true,
      onTapOutside: () => setState(() => _showDropdown = false),
      content: Column(
        children: [
          MoonMenuItem(
            onTap: () {
              BlocProvider.of<ThemeCubit>(context).setThemeMode(AppThemeMode.system);
              setState(() => _showDropdown = false);
            },
            label: Text(context.l10n.system),
          ),
          MoonMenuItem(
            onTap: () {
              BlocProvider.of<ThemeCubit>(context).setThemeMode(AppThemeMode.light);
              setState(() => _showDropdown = false);
            },
            label: Text(context.l10n.light),
          ),
          MoonMenuItem(
            onTap: () {
              BlocProvider.of<ThemeCubit>(context).setThemeMode(AppThemeMode.dark);
              setState(() => _showDropdown = false);
            },
            label: Text(context.l10n.dark),
          ),
        ],
      ),
      child: MoonMenuItem(
        onTap: () => setState(() => _showDropdown = !_showDropdown),
        label: Text(context.l10n.theme),
        leading: const Icon(Icons.brightness_6),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _LanguageSection extends StatefulWidget {
  const _LanguageSection();

  @override
  State<_LanguageSection> createState() => _LanguageSectionState();
}

class _LanguageSectionState extends State<_LanguageSection> {
  bool _showDropdown = false;

  @override
  Widget build(BuildContext context) {
    return MoonDropdown(
      show: _showDropdown,
      constrainWidthToChild: true,
      onTapOutside: () => setState(() => _showDropdown = false),
      content: Column(
        children: [
          MoonMenuItem(
            onTap: () {
              BlocProvider.of<LanguageCubit>(context).setLocale(const Locale('en'));
              setState(() => _showDropdown = false);
            },
            label: const Text('English'),
          ),
          MoonMenuItem(
            onTap: () {
              BlocProvider.of<LanguageCubit>(context).setLocale(const Locale('ha'));
              setState(() => _showDropdown = false);
            },
            label: const Text('Hausa'),
          ),
        ],
      ),
      child: MoonMenuItem(
        onTap: () => setState(() => _showDropdown = !_showDropdown),
        label: Text(context.l10n.language),
        leading: const Icon(Icons.language),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<LanguageCubit, Locale>(
              builder: (context, state) {
                return Text(
                  state.languageCode == 'en' ? 'English' : 'Hausa',
                  style: context.moonTypography?.body.text14,
                );
              },
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoonMenuItem(
          onTap: () => _launchUrl('https://example.com/terms'),
          label: Text(context.l10n.termsAndConditions),
          leading: const Icon(Icons.description),
        ),
        const SizedBox(height: 8),
        MoonMenuItem(
          onTap: () => _launchUrl('https://example.com/license'),
          label: Text(context.l10n.license),
          leading: const Icon(Icons.assignment),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return AppButton.filled(
      isFullWidth: true,
      backgroundColor: context.moonColors?.chichi10,
      label: Text(
        context.l10n.logout,
        style: context.moonTypography?.body.text16.copyWith(
          color: context.moonColors?.chichi,
        ),
      ),
      onTap: () {
        showMoonModal<void>(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MoonModal(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.logoutConfirmationTitle,
                        style: context.moonTypography?.heading.text24,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.logoutConfirmationMessage,
                        style: context.moonTypography?.body.text14,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.plain(
                              label: Text(context.l10n.cancel),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppButton.filled(
                              backgroundColor: context.moonColors?.chichi10,
                              label: Text(
                                context.l10n.logout,
                                style: context.moonTypography?.body.text16
                                    .copyWith(
                                        color: context.moonColors?.chichi),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                BlocProvider.of<SessionCubit>(context).signOut();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
