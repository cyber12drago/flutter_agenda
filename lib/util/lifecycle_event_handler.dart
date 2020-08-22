import 'dart:async';
import 'package:flutter/cupertino.dart';


typedef FutureVoidCallBack= FutureOr<void> Function(AppLifecycleState state);

class LifecycleEventHandler extends WidgetsBindingObserver {
  final FutureVoidCallBack onResume;
  final FutureVoidCallBack onSuspend;


  LifecycleEventHandler({this.onResume, this.onSuspend});

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async{
    switch(state){
      case AppLifecycleState.resumed:
        if(onResume !=null){
          await onResume(state);
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if(onSuspend != null) {
          await onSuspend(state);
        }
        break;
    }
      print('state change: $state');

  }

}

