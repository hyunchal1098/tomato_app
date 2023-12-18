//app_router.dart
import 'package:tomato_app/screens/start_screen.dart';
import 'package:tomato_app/screens/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../status/user_provider.dart';
import 'app_service.dart';

class AppRouter {
  /// go router 호출 get 함수
  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(

    /// 가장 먼저 보여줄 라우트(페이지)
    initialLocation: '/',

    /// redirect 시 사용되는 리스너(상태변화를 감지)
    refreshListenable: AppService(),

    /// router 정보 콘솔에 출력
    debugLogDiagnostics: true,

    /// route할 때, error가 발생 -> ErrorPage로 route한다.
    /// 커스텀 가능
    /// state.error.toString()으로 에러메세지 출력가능
    // errorBuilder: (BuildContext context, GoRouterState state) => const ErrorPage(),

    /// 라우트 설정
    routes: <GoRoute>[
      GoRoute(
        name: "home", path: "/", builder: (context, state) => HomeScreen(),),
      GoRoute(
        name: "auth",
        path: "/auth",
        builder: (context, state) => StartScreen(),),
    ],
    redirect: (context, state) {
      /// 로그인 여부(UserProvider의 user가 null이면 로그아웃 상태)
      final loggedIn = context.watch<UserProvider>().user != null;
      if (!loggedIn) {
        return "/auth";
      }
      if (loggedIn) {
        return "/";
      }
    },
  );
}
