import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    debugPrint('onEvent $event');
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    debugPrint('onTransition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    debugPrint('onError $error');
    super.onError(cubit, error, stackTrace);
  }
}
