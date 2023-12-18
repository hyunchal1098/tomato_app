import 'package:tomato_app/constants/keys.dart';
import 'package:tomato_app/data/address_point_model.dart';
import 'package:tomato_app/utils/logger.dart';
import 'package:dio/dio.dart';

import '../../data/address_model.dart';

class AddressService {
  /// string 타입 검색주소 api 데이터받기
  Future<AddressModel> searchAddressByStr(String text) async {
    final formData = {
      "request": "search",
      "key": VWORLD_KEY,
      "query": text,
      "type": "ADDRESS",
      "category": "ROAD",
      "size": 30,
    };

    /// 외부 API get 통신
    final response = await Dio()
        .get(
      "https://api.vworld.kr/req/search",
      queryParameters: formData,
    )
        .catchError(
      (e) {
        logger.e(e.message);
      },
    );

    logger.d(response);

    /// json으로 받아온 정보 addressModel에 대입하여 리턴
    AddressModel addressModel = AddressModel.fromJson(response.data["response"]);
    return addressModel;
  }

  // 내 위치 위도 경도로 api 요청
  Future<List<AddressPointModel>> findAddressByCoordinate({required double log, required double lat}) async {
    final List<Map<String, dynamic>> formDatas = <Map<String, dynamic>>[];

    formDatas.add({
      "request": "GetAddress",
      "key": VWORLD_KEY,
      "service": "address",
      "type": "PARCEL",
      "point": "$log, $lat",
    });
    formDatas.add({
      "request": "GetAddress",
      "key": VWORLD_KEY,
      "service": "address",
      "type": "PARCEL",
      "point": "${log - 0.01}, $lat",
    });
    formDatas.add({
      "request": "GetAddress",
      "key": VWORLD_KEY,
      "service": "address",
      "type": "PARCEL",
      "point": "${log + 0.01}, $lat",
    });
    formDatas.add({
      "request": "GetAddress",
      "key": VWORLD_KEY,
      "service": "address",
      "type": "PARCEL",
      "point": "$log, ${lat - 0.01}",
    });
    formDatas.add({
      "request": "GetAddress",
      "key": VWORLD_KEY,
      "service": "address",
      "type": "PARCEL",
      "point": "$log, ${lat + 0.01}",
    });

    List<AddressPointModel> listAddressPointModel = [];

    /// 외부 API get 통신
    for (Map<String, dynamic> formData in formDatas) {
      final response = await Dio()
          .get("https://api.vworld.kr/req/address",
                queryParameters: formData,)
          .catchError((e) {
          logger.e(e.message);
        },
      );

      AddressPointModel addressPointModel = AddressPointModel.fromJson(response.data["response"]);
      if(response.data["response"]["status"] == "OK") {
        listAddressPointModel.add(addressPointModel);
      }
    }

    return listAddressPointModel;
    // return addressModel;
  }
}
