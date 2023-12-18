import 'dart:async';
import 'package:flutter/cupertino.dart';

class AppService with ChangeNotifier {
  static final AppService _singleton = AppService._internal();

  factory AppService() {
    return _singleton;
  }

  AppService._internal();


  ///AppService 바깥에서 onAppStart를 호출
  Future<void> onAppStart() async {
    await initialize();

    notifyListeners();//중요 : 이게 호출되면 redirect 가 됨!
  }

  /// 앱을 시작하기 위해 필요한 데이터와 세팅 로딩(오래 걸리는 것)
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));


  }
}