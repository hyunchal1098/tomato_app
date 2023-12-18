import 'package:tomato_app/status/user_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/logger.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// 현재 단말기 사이즈 가져옴
        Size size = MediaQuery.of(context).size;

        /// padding을 horizontal: 16으로 주었기때문에 너비는 도합 32만큼 빼줘야함
        final imgOne = size.width - 32;

        /// 위치표시는 전체이미지 크기의 10분의 1로 지정
        final imgTwo = imgOne * 0.1;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("토마토마켓", style: Theme.of(context).textTheme.headlineSmall),

                /// 지도영역만 크기 조정하므로 Stack 사이즈 조정
                SizedBox(
                  width: imgOne,
                  height: imgOne,
                  child: Stack(
                    children: [
                      ExtendedImage.asset("assets/images/intro_one.png"),
                      Positioned(
                        /// Positioned 위젯은 기본적으로 padding값만으로 위치지정 가능(Center안됨)
                        width: imgTwo,
                        height: imgTwo,
                        top: imgOne * 0.45,
                        left: imgOne * 0.45,
                        child: ExtendedImage.asset("assets/images/intro_two.png"),
                      ),
                    ],
                  ),
                ),
                Text(
                  "우리동네 중고 직거래",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                Text("서큐러스마켓은 동네 직거래 마켓이에요.\n내 동네를 설정하고 시작해보세요.!"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () {
                        /// pageController로 버튼 클릭시 화면전환
                        context.read<PageController>().animateToPage(
                          1,
                          duration: Duration(milliseconds: 500),

                          /// 애니메이션 효과
                          curve: Curves.easeOut,
                        );
                      },
                      child: Text(
                        "내 동네 설정하고 시작하기",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
