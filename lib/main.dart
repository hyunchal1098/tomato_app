import 'package:tomato_app/router/app_router.dart';
import 'package:tomato_app/screens/splash_screen.dart';
import 'package:tomato_app/status/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

final UserProvider _userProvider = UserProvider();

void main() async{
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          /// 페이드아웃 효과
          duration: Duration(milliseconds: 300),

          /// 페이드아웃 후 나올 스냅샷
          child: _splashLoadingWidget(snapshot),
        );
      },
    );
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      /// 이부분은 에러발생, 텍스트 방향을 고려하여 Directionality 위젯으로 감싸줘야함.
      /// 추후 에러페이지 만들기
      print(snapshot.error.toString());
      return Text("error");
    } else if (snapshot.connectionState == ConnectionState.done) {
      return CitRusApp();
    } else {
      return const SplashScreen();
    }
  }
}

class CitRusApp extends StatelessWidget {
  const CitRusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// ChangeNotifierProvider를 통해 UserProvider()를 구독
        /// UserProvider은 user_provider.dart에 생성된 것이다.
        /// ⭐️child 하위에 모든 것들은 UserProvider에 접근할 수 있고⭐️
        /// Provider 선언한 위치에서 그 상위 Widget은 Provider에 접근할 수 없다
        ChangeNotifierProvider<UserProvider>.value(value: _userProvider),
      ],
      child: Builder(builder: (context) {
        final appRouter = AppRouter();
        return MaterialApp.router(
          /// 테마
          theme: ThemeData(
            /// 전체적용
            fontFamily: "DoHyeon",

            ///hint color
            hintColor: Colors.grey,

            /// 과거 primarySwatch
            primaryColor: Colors.green,
            //primarySwatch: Colors.green,

            /// 앱바테마
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              elevation: 2,
              actionsIconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),

            ///바텀바
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              /// 선택시 색상
              selectedItemColor: Colors.black87,

              /// 미선택시 색상
              unselectedItemColor: Colors.black38,
            ),

            /// 텍스트 테마
            textTheme: TextTheme(
              /// 과거 headline3
              displaySmall: TextStyle(fontFamily: "DoHyeon"),

              /// 과거 button
              labelLarge: TextStyle(
                color: Colors.white,
              ),

              titleMedium: TextStyle(
                color: Colors.black87,
              ),
              titleSmall: TextStyle(
                color: Colors.black38,
              ),
            ),

            /// 텍스트 버튼 테마
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(48, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
          ),

          debugShowCheckedModeBanner: false,

          /// route 정보 전달(⭐️현재 로그인상태가 false 이므로 authPage로 화면이동⭐️)
          routeInformationProvider: appRouter.router.routeInformationProvider,

          /// URI String을 상태 및 Go Router에서 사용할 수 있는 형태로 변환해주는 함수
          routeInformationParser: appRouter.router.routeInformationParser,

          /// 위에서 변경된 값으로 실제로 어떤 라우트를 보여줄지 정하는 함수
          routerDelegate: appRouter.router.routerDelegate,
        );
      }),
    );
  }
}
