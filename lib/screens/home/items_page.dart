import 'package:tomato_app/constants/common_size.dart';
import 'package:tomato_app/repo/user_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// ListView 말고 ListView.builder를 쓰는 이유는 아이템 갯수가 얼만지 알수 없기에 동적으로 처리해주기 위함
    /// ListView.separated : ListView 내부에 아이템간 간격을 띄어주고 라인선을 만들기 위함
    return LayoutBuilder(builder: (context, constraints) {
      Size size = MediaQuery.of(context).size;
      final imgSize = size.width / 4;
      return FutureBuilder(
        future: Future.delayed(
          Duration(seconds: 2),
        ),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: (snapshot.connectionState != ConnectionState.done)
                ? _shimmerListView(imgSize)
                : _listView(imgSize),
          );
        },
      );
      // return _listView(imgSize);
    });
  }

  ListView _listView(double imgSize) {
    return ListView.separated(
      padding: EdgeInsets.all(common_bg_padding),
      itemCount: 10,
      itemBuilder: (context, index) {
        /// 컨테이너와 같이 별도의 제스쳐 기능을 제공하지 않는 위젯에 제스쳐 기능을 추가하고자 할 때 InkWell 위젯을 이용
        return InkWell(
          onTap: () {
            // UserService().fireStoreReadTest();
          },
          child: SizedBox(
            height: imgSize,
            child: Row(
              children: [
                SizedBox(
                  width: imgSize,
                  height: imgSize,
                  child: ExtendedImage.network(
                    "https://picsum.photos/200",
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: common_sm_padding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "어린이용 자전거",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "1시간전",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text("15,000 원"),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 15,
          
                            /// 아이콘의 경우 SizedBox 위젯으로 크기를 고정할 수 없음, Text만 줄어듬
                            /// FittedBox로 강제로 아이콘 크기를 줄여야함.
                            child: FittedBox(
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.chat_bubble_2),
                                  Text("31"),
                                  Icon(CupertinoIcons.heart),
                                  Text("31"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: common_sm_padding * 3,

          /// 라인선 두께
          thickness: 1,
          color: Colors.grey[200],

          /// 좌측 구분선 패딩
          indent: common_sm_padding,

          /// 우측구분선 패당
          endIndent: common_sm_padding,
        );
      },
    );
  }

  Widget _shimmerListView(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.all(common_bg_padding),
        itemCount: 10,
        itemBuilder: (context, index) {
          return SizedBox(
            height: imgSize,
            child: Row(
              children: [
                Container(
                  height: imgSize,
                  width: imgSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(
                  width: common_sm_padding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 25,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 18,
                        width: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 16,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: common_sm_padding * 3,

            /// 라인선 두께
            thickness: 1,
            color: Colors.grey[200],

            /// 좌측 구분선 패딩
            indent: common_sm_padding,

            /// 우측구분선 패당
            endIndent: common_sm_padding,
          );
        },
      ),
    );
  }
}
