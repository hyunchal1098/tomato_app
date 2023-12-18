import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/data_keys.dart';
import '../data/user_model.dart';
import '../utils/logger.dart';

class UserService {
  /// 싱글톤 패턴(단일 인스턴스로 전역에서 활용)
  static final UserService _userService = UserService._internal();

  factory UserService() => _userService;

  UserService._internal();

  ///json 데이터와 유저키를 가져와 신규유저 저장
  createNewUser(Map<String, dynamic> json, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);

    /// 기존 가입자 식별을 위한 DB 참조
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    /// DB에 존재하지 않는경우 저윶
    if(!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  /// firestore 유저 정보 조회 (캐싱처리)
  Future<UserModel> getUserModel(String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);

    /// 기존 가입자 식별을 위한 DB 참조
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentReference.get();

    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    return userModel;
  }
}
