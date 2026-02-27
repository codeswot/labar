import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/l10n/app_localizations.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/router/app_router.gr.dart';
import 'core/session/session_cubit.dart';
import 'core/session/session_state.dart';
import 'core/theme/app_theme_mode.dart';
import 'core/theme/theme_cubit.dart';
import 'core/localization/language_cubit.dart';
import 'core/localization/fallback_localization_delegate.dart';
import 'core/utils/app_logger.dart';
import 'package:labar_app/features/home/presentation/cubit/home_cubit.dart';

void main() async {
  runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      Bloc.observer = AppBlocObserver();

      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.error(
          'Flutter Error: ${details.exceptionAsString()}',
          details.exception,
          details.stack,
        );
        FlutterError.presentError(details);
      };

      try {
        AppLogger.info('🚀 Initializing Labar Grains...');

        HydratedBloc.storage = await HydratedStorage.build(
          storageDirectory: await getApplicationDocumentsDirectory(),
        );
        // await HydratedBloc.storage
        //     .clear(); // Clear storage for testing flow from scratch
        // AppLogger.info('✅ HydratedBloc storage initialized and cleared');

        await Supabase.initialize(
          url: AppConfig.supabaseUrl,
          anonKey: AppConfig.supabaseAnonKey,
        );
        AppLogger.info('✅ Supabase initialized');

        await configureDependencies();
        AppLogger.info('✅ Dependencies configured');

        FlutterNativeSplash.remove();
        AppLogger.info('✅ Initialization complete');
      } catch (e, stackTrace) {
        AppLogger.error('❌ Initialization failed', e, stackTrace);
        FlutterNativeSplash.remove();
      }

      runApp(const LabarApp());
    },
    (error, stack) {
      AppLogger.fatal('💥 Uncaught error in zone', error, stack);
    },
  );
}

class LabarApp extends StatelessWidget {
  const LabarApp({super.key});
  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => getIt<ThemeCubit>(),
        ),
        BlocProvider<SessionCubit>(
          create: (_) => getIt<SessionCubit>(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => getIt<LanguageCubit>(),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => getIt<HomeCubit>(),
        ),
      ],
      child: BlocListener<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state.status == SessionStatus.unauthenticated) {
            _appRouter.replaceAll([const SignInRoute()]);
          } else if (state.status == SessionStatus.authenticated) {
            context.read<HomeCubit>().reset();
          }
        },
        child: BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                return MaterialApp.router(
                  title: 'Labar Grains',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme(),
                  darkTheme: AppTheme.darkTheme(),
                  themeMode:
                      BlocProvider.of<ThemeCubit>(context).flutterThemeMode,
                  locale: locale,
                  routerConfig: _appRouter.config(),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    FallbackLocalizationDelegate(),
                    FallbackCupertinoLocalizationDelegate(),
                  ],
                  supportedLocales: const [
                    Locale('en'),
                    Locale('ha'),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
