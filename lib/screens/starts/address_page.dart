import 'package:tomato_app/data/address_model.dart';
import 'package:tomato_app/screens/starts/address_service.dart';
import 'package:tomato_app/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/shared_pref_keys.dart';
import '../../data/address_point_model.dart';

class AddressPage extends StatefulWidget {
  AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;

  List<AddressPointModel> _listAddressPointModel = [];

  /// 내 위치 주소 api 요청 여부
  bool _isGettingLocation = false;

  @override
  void dispose() {
    /// 여러 컨트롤러를 사용할때 dispose() 기능을 사용하여 상태변화마다 controller을 삭제해야함(메모리)
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      /// SafeArea 위젯에 패딩적용
      minimum: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          /// 화면 터치시 키보드 아래로 내려가게 처리
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _addressController,

              /// 입력 후 키보드상의 엔터(실행)키를 누르면 작동
              /// 동작순서 : 주소입력 - 엔터 - AddressService를 통해 api데이터 요청 - 데이터를 _addressModel이란 그릇에 담음 - 그 데이터를 부분부분 검증해서 화면에 뿌려줌
              onFieldSubmitted: (text) async {
                /// 모델 초기화
                _addressModel = null;
                _listAddressPointModel.clear();

                _addressModel = await AddressService().searchAddressByStr(text);
                setState(() {});
              },
              decoration: InputDecoration(
                /// 아이콘 좌측 끝 위치
                prefixIconConstraints: BoxConstraints(
                  minWidth: 24,
                  maxHeight: 24,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: "도로명으로 입력하세요.",
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),

            TextButton.icon(
              onPressed: () async {
                /// 모델 초기화
                _addressModel = null;
                _listAddressPointModel.clear();

                setState(() {
                  _isGettingLocation = true;
                });
                Location location = new Location();

                bool _serviceEnabled;
                PermissionStatus _permissionGranted;
                LocationData _locationData;

                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (!_serviceEnabled) {
                    return;
                  }
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) {
                    return;
                  }
                }

                _locationData = await location.getLocation();

                logger.d("_locationData : $_locationData");

                /// 위도 경도로 주소요청
                _listAddressPointModel = await AddressService().findAddressByCoordinate(
                  log: _locationData.longitude!,
                  lat: _locationData.latitude!,
                );

                setState(() {
                  _isGettingLocation = false;
                });
              },
              icon: _isGettingLocation
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      CupertinoIcons.compass,
                      color: Colors.white,
                    ),
              label: Text(
                _isGettingLocation ? "위치 찾는 중" : "현재 위치로 찾기",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),

            /// 가로로 얼마정도까지 보여줄 것인지에 대한 내용이 없기때문에 Expanded로 꽉채워줌.
            Visibility(
              visible: (_addressModel != null),
              child: Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: (_addressModel == null ||
                          _addressModel!.result == null ||
                          _addressModel!.result!.items == null)
                      ? 0
                      : _addressModel!.result!.items!.length,
                  itemBuilder: (context, index) {
                    /// 아이템빌더의 실행함수에서 _addressModel 데이터가 없는 경우 빈 컨테이너 리턴.
                    if (_addressModel == null ||
                        _addressModel!.result == null ||
                        _addressModel!.result!.items == null ||
                        _addressModel!.result!.items![index].address == null) {
                      return Container();
                    }
                    return ListTile(
                      onTap: () {
                        _saveAddressAndGoToNextPage(
                          _addressModel!.result!.items![index].address!.road ?? "",
                          num.parse(_addressModel!.result!.items![index].point!.y ?? "0"),
                          num.parse(_addressModel!.result!.items![index].point!.x ?? "0"),
                        );
                      },

                      /// leading : 타일 제일 앞에서 썸네일이나 아이콘 배치용도
                      /// trailing : 우측끝에 이미지나 아이콘 배치
                      title: Text(_addressModel!.result!.items![index].address!.road ?? ""),
                      subtitle: Text(_addressModel!.result!.items![index].address!.parcel ?? ""),
                    );
                  },
                ),
              ),
            ),

            Visibility(
              visible: (_listAddressPointModel.isNotEmpty),
              child: Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: _listAddressPointModel.length,
                  itemBuilder: (context, index) {
                    /// 아이템빌더의 실행함수에서 _addressModel 데이터가 없는 경우 빈 컨테이너 리턴.
                    if (_listAddressPointModel[index].result == null ||
                        _listAddressPointModel[index].result!.isEmpty) {
                      return Container();
                    }
                    return ListTile(
                      onTap: () {
                        _saveAddressAndGoToNextPage(
                          _listAddressPointModel[index].result![0].text ?? "",
                          num.parse(_listAddressPointModel[index].input!.point!.y ?? "0"),
                          num.parse(_listAddressPointModel[index].input!.point!.x ?? "0"),
                        );
                      },

                      /// leading : 타일 제일 앞에서 썸네일이나 아이콘 배치용도
                      /// trailing : 우측끝에 이미지나 아이콘 배치
                      title: Text(_listAddressPointModel[index].result![0].text ?? ""),
                      subtitle: Text(_listAddressPointModel[index].result![0].zipcode ?? ""),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _saveAddressOnSharedPreference(String address, num lat, num lon) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SHARED_ADDRESS, address);
    await prefs.setDouble(SHARED_LAT, lat.toDouble());
    await prefs.setDouble(SHARED_LON, lon.toDouble());
  }

  _saveAddressAndGoToNextPage(String address, num lat, num lon) async {
    await _saveAddressOnSharedPreference(address, lat, lon);

    /// pageController로 버튼 클릭시 화면전환
    context.read<PageController>().animateToPage(
          2,
          duration: Duration(milliseconds: 500),

          /// 애니메이션 효과
          curve: Curves.easeOut,
        );
  }
}
