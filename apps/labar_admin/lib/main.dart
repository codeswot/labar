import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ui_library/ui_library.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme_mode.dart';
import 'core/theme/theme_cubit.dart';
import 'core/utils/app_logger.dart';
import 'core/session/session_cubit.dart';
import 'core/session/session_state.dart';
import 'core/router/app_router.gr.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

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
        AppLogger.info('🚀 Initializing Labar Admin...');

        HydratedBloc.storage = await HydratedStorage.build(
          storageDirectory: kIsWeb
              ? HydratedStorage.webStorageDirectory
              : await getApplicationDocumentsDirectory(),
        );
        AppLogger.info('✅ HydratedBloc storage initialized');

        await Supabase.initialize(
          url: AppConfig.supabaseUrl,
          anonKey: AppConfig.supabaseAnonKey,
        );
        AppLogger.info('✅ Supabase initialized');
      } catch (e, stackTrace) {
        AppLogger.error(
            '⚠️ Non-critical initialization warning', e, stackTrace);
      }

      try {
        await configureDependencies();
        AppLogger.info('✅ Dependencies configured');
        AppLogger.info('✅ Initialization complete');
      } catch (e, stackTrace) {
        AppLogger.error('❌ Critical initialization failed', e, stackTrace);
      }

      runApp(const LabarAdminApp());
    },
    (error, stack) {
      AppLogger.fatal('💥 Uncaught error in zone', error, stack);
    },
  );
}

class LabarAdminApp extends StatelessWidget {
  const LabarAdminApp({super.key});
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
      ],
      child: BlocListener<SessionCubit, SessionState>(
        listener: (context, state) {
          AppLogger.info('Session Status Changed: ${state.status}');
          if (state.status == SessionStatus.unauthenticated) {
            _appRouter.replaceAll([const SignInRoute()]);
          } else if (state.status == SessionStatus.authenticated) {
            AppLogger.info('Navigating to Dashboard...');
            _appRouter.replaceAll([const DashboardRoute()]);
          }
        },
        child: BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'Labar Admin',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: context.read<ThemeCubit>().flutterThemeMode,
              routerConfig: _appRouter.config(),
              localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en', ''), Locale('ha', '')],
              builder: (context, child) {
                return BlocBuilder<SessionCubit, SessionState>(
                  builder: (context, state) {
                    if (state.status == SessionStatus.unknown) {
                      return Scaffold(
                        body: Center(
                          child: MoonCircularLoader(
                            circularLoaderSize: MoonCircularLoaderSize.lg,
                            color: context.moonColors?.piccolo,
                          ),
                        ),
                      );
                    }
                    return child!;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
