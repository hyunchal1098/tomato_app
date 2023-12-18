import 'package:tomato_app/screens/starts/address_page.dart';
import 'package:tomato_app/screens/starts/auth_page.dart';
import 'package:tomato_app/screens/starts/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  /// 페이지 컨트롤러
  PageController _pageController = PageController();

  StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<PageController>.value(
      value: _pageController,
      child: Scaffold(
        body: PageView(
          /// 화면 못넘김
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            IntroPage(),
            AddressPage(),
            AuthPage(),
          ],
        ),
      ),
    );
  }
}
