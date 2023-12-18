import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  /// GeoFirePoint 지도상에서 마크를 찍어주는 라이브러리, geoflutterfire은 설치가 안되고 geoflutterfire2로 사용
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;

  UserModel({
    required this.userKey,
    required this.phoneNumber,
    required this.address,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,});

  UserModel.fromJson(Map<String,dynamic> json, this.userKey, this.reference) {
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    geoFirePoint = GeoFirePoint((json['geoFirePoint']["geopoint"]).latitude, (json['geoFirePoint']["geopoint"]).longitude);
    createdDate = json['createdDate'] == null ? DateTime.now().toUtc() : (json['createdDate'] as Timestamp).toDate();
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> snapshot)
  : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  // UserModel copyWith({  String? userKey,
  //   String? phoneNumber,
  //   String? address,
  //   num? lat,
  //   num? lon,
  //   String? geoFirePoint,
  //   String? createdDate,
  //   String? reference,
  // }) => UserModel(  userKey: userKey ?? this.userKey,
  //   phoneNumber: phoneNumber ?? this.phoneNumber,
  //   address: address ?? this.address,
  //   lat: lat ?? this.lat,
  //   lon: lon ?? this.lon,
  //   geoFirePoint: geoFirePoint ?? this.geoFirePoint,
  //   createdDate: createdDate ?? this.createdDate,
  //   reference: reference ?? this.reference,
  // );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['userKey'] = userKey;  // firebase에서 가져오므로 삭제
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createdDate'] = createdDate;
    // map['reference'] = reference;  // firebase에서 가져오므로 삭제
    return map;
  }
}