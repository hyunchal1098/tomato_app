import 'package:tomato_app/screens/home/items_page.dart';
import 'package:tomato_app/status/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_app/widget/expandablefab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 바텀네비게이션 인덱스
  int _bottomSelectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "삼평동",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // context.read<UserProvider>().setUserAuth(false);
              /// user 로그아웃 함수
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              // context.read<UserProvider>().setUserAuth(false);
            },
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              // context.read<UserProvider>().setUserAuth(false);
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectIndex,

        /// 선택안해도 이름 라벨이 보이도록
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomSelectIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectIndex == 0
                  ? "assets/icons/icon_home_select.png"
                  : "assets/icons/icon_home_normal.png"),
            ),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectIndex == 1
                  ? "assets/icons/icon_location_select.png"
                  : "assets/icons/icon_location_normal.png"),
            ),
            label: "내근처",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectIndex == 2
                  ? "assets/icons/icon_chat_select.png"
                  : "assets/icons/icon_chat_normal.png"),
            ),
            label: "채팅",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectIndex == 3
                  ? "assets/icons/icon_info_select.png"
                  : "assets/icons/icon_info_normal.png"),
            ),
            label: "내정보",
          ),
        ],
      ),

      /// bottomBar에서는 보통 state로 관리함
      /// Navigation.push로 페이지를 이동하게 된다면 라우트 스택에 이동한 페이지가 전부 쌓이게 됨
      /// IndexedStack : 페이지 전환용
      body: IndexedStack(
        index: _bottomSelectIndex,
        children: [
          ItemsPage(),
          Container(
            color: Colors.accents[4],
          ),
          Container(
            color: Colors.accents[10],
          ),
          Container(
            color: Colors.accents[15],
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 90,
        children: [
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
