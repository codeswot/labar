import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/app_logger.dart';

/// Custom BLoC observer that logs all BLoC events, state changes, and errors
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.debug('🟢 BLoC Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug('📥 Event: ${bloc.runtimeType} | $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.debug(
      '🔄 State Change: ${bloc.runtimeType}\n'
      '   Current: ${change.currentState}\n'
      '   Next: ${change.nextState}',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    AppLogger.debug(
      '🔀 Transition: ${bloc.runtimeType}\n'
      '   Event: ${transition.event}\n'
      '   Current: ${transition.currentState}\n'
      '   Next: ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      '❌ BLoC Error: ${bloc.runtimeType}',
      error,
      stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.debug('🔴 BLoC Closed: ${bloc.runtimeType}');
  }
}
