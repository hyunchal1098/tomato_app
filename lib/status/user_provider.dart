import 'dart:ffi';

import 'package:tomato_app/data/user_model.dart';
import 'package:tomato_app/repo/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref_keys.dart';
import '../utils/logger.dart';

class UserProvider extends ChangeNotifier {
  /// 생성자
  UserProvider() {
    /// Provider 상태관리가 ChangeNotifier와 연결됨
    initUser();
  }

  /// _user 로그인 상태 변수
  /// _user가 null이면 로그아웃 상태
  User? _user;
  UserModel? _userModel;

  /// 최초 유저 관리를 위함
  void initUser() {
    /// authStateChanges : 로그인과 로그아웃을 처리하는 함수
    /// Stream<User?>로 Stream을 사용하여 상태관리를 위해 항상 파이프처럼 지속적인 데이터변화 감지
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _setNewUser(user);
      logger.d("현재 유저 상태 $user");

      /// 함수 전체에 유저 상태변화 전송
      notifyListeners();
    });
  }

  /// 새로운 유저 정보 저장
  Future<void> _setNewUser(User? user) async {
    _user = user;
    if (user != null && user.phoneNumber != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userKey = user.uid;
      String phoneNumber = user.phoneNumber!;
      String address = prefs.getString(SHARED_ADDRESS) ?? "";
      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;

      /// 모델 데이터 입력
      UserModel userModel = UserModel(
        userKey: "",
        phoneNumber: phoneNumber,
        address: address,
        geoFirePoint: GeoFirePoint(lat, lon),
        createdDate: DateTime.now().toUtc(),
      );
      /// UserService 호출하여 유저정보 생성
      await UserService().createNewUser(userModel.toJson(), userKey);

      /// 유저모델 캐시저장
      _userModel = await UserService().getUserModel(userKey);
      logger.d("_userModel : ${_userModel!.toJson().toString()}");
    }
  }

  /// User getter
  User? get user => _user;

// bool _userLoggedIn = false;
//
// void setUserAuth(bool authState) {
//   _userLoggedIn = authState;
//   notifyListeners();
// }
//
// bool get userState => _userLoggedIn;
}
