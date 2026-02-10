import 'dart:developer';
import 'package:flutter/material.dart';

class AppLifeCycleStateListener extends StatefulWidget {
  final Widget child;
  const AppLifeCycleStateListener({super.key, required this.child});

  @override
  State<AppLifeCycleStateListener> createState() =>
      _AppLifeCycleStateListenerState();
}

class _AppLifeCycleStateListenerState extends State<AppLifeCycleStateListener> {
  late final AppLifecycleListener lifeCycleListener;

  @override
  void initState() {
    super.initState();
    lifeCycleListener = AppLifecycleListener(
      onStateChange: _onLifeCycleChanged,
      onDetach: _onDetach,
      onPause: _onPause,
    );
  }

  @override
  void dispose() {
    lifeCycleListener.dispose();
    super.dispose();
  }

  void _onLifeCycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        log('Detached');
        break;
      case AppLifecycleState.resumed:
        log('Resumed');
        break;
      case AppLifecycleState.inactive:
        log('Inactive');
        break;
      case AppLifecycleState.hidden:
        log('Hidden');
        break;
      case AppLifecycleState.paused:
        log('Paused');

        

        break;
    }
  }

  void _onDetach() => debugPrint('on Detach');
  void _onPause() => debugPrint('on Pause');

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
