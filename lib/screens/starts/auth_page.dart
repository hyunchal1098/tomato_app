import 'package:tomato_app/constants/common_size.dart';
import 'package:tomato_app/status/user_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/shared_pref_keys.dart';
import '../../utils/logger.dart';

class AuthPage extends StatefulWidget {
  AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final inptuBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));

  TextEditingController _phoneNumController = TextEditingController(text: "010");

  TextEditingController _codeController = TextEditingController();

  /// 입력필드 가진 폼 위젯 식별자(폼 위젯 내에 키(key)로 작용)
  /// Form의 유효성검사를 위함
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  VerifiCationStatus _verifiCationStatus = VerifiCationStatus.none;

  String? _verificationId;

  /// 인증번호 받지 못한 경우 재전송 토큰
  int? _forceResendingToken;

  @override
  void dispose() {
    /// 여러 컨트롤러를 사용할때 dispose() 기능을 사용하여 상태변화마다 controller을 삭제해야함(메모리)
    _phoneNumController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// 설명글이 화면 넘어감으로 오버플로 발생
        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verifiCationStatus == VerifiCationStatus.verifying,
          child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "로그인 하기",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                elevation: AppBarTheme.of(context).elevation,
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(common_bg_padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            ExtendedImage.asset(
                              "assets/images/security.png",
                              width: size.width * 0.25,
                              height: size.height * 0.25,
                            ),

                            /// 가로 간격
                            SizedBox(width: common_sm_padding),
                            Text(
                              "서큐러스 마켓은 전화번호로 가입합니다.\n여러분의 개인정보는 안전하게 보관되며,\n외부에 노출되지 않습니다.",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),

                        /// 세로간격
                        SizedBox(height: common_bg_padding),

                        ///전화번호 입력란
                        TextFormField(
                          validator: (phoneNum) {
                            if (phoneNum != null && phoneNum.length == 13) {
                              return null;
                            } else {
                              return "올바른 전화번호를 입력하세요.";
                            }
                          },
                          controller: _phoneNumController,

                          /// 키보드입력방식
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            MaskedInputFormatter("000 0000 0000"),
                          ],
                          decoration: InputDecoration(
                            border: inptuBorder,
                            focusedBorder: inptuBorder,
                          ),
                        ),
                        SizedBox(
                          height: common_sm_padding,
                        ),
                        TextButton(
                          onPressed: () async {
                            /// codeSending 중에는 버튼 비활성화
                            if (_verifiCationStatus == VerifiCationStatus.codeSending) {
                              return;
                            }
                            _getAddress();

                            if (_formKey.currentState != null) {
                              /// validation결과가 성공이면 true 리턴
                              bool passed = _formKey.currentState!.validate();

                              /// 검증성공시 코드전송상태로 변경
                              if (passed) {
                                /// _phoneNumController(폰번호) 가공하여 추출(폰번호만)
                                String phoneNum = _phoneNumController.text;
                                phoneNum.replaceAll(" ", "");
                                phoneNum.replaceFirst("0", "");

                                FirebaseAuth auth = FirebaseAuth.instance;

                                /// 코드 발송중으로 상태변경
                                setState(() {
                                  _verifiCationStatus = VerifiCationStatus.codeSending;
                                });

                                await auth.verifyPhoneNumber(
                                  phoneNumber: '+82$phoneNum',
                                  forceResendingToken: _forceResendingToken,
                                  verificationCompleted: (PhoneAuthCredential credential) async {
                                    // ANDROID ONLY!

                                    // Sign the user in (or link) with the auto-generated credential
                                    await auth.signInWithCredential(credential);
                                  },

                                  /// 인증실패시 실행
                                  verificationFailed: (FirebaseAuthException error) {
                                    logger.e(error.message);

                                    /// 인증실패시 인증단계 초기화
                                    setState(() {
                                      _verifiCationStatus = VerifiCationStatus.none;
                                    });
                                  },

                                  /// 인증번호 전송하면 실행
                                  codeSent:
                                      (String verificationId, int? forceResendingToken) async {
                                    setState(() {
                                      _verifiCationStatus = VerifiCationStatus.codeSent;
                                    });

                                    _verificationId = verificationId;
                                    _forceResendingToken = forceResendingToken;
                                  },

                                  /// 인증코드 유효시간 통제
                                  codeAutoRetrievalTimeout: (String verificationId) {},
                                );
                              }
                            }
                          },

                          /// 인증문자 발송 중에는 인디케이터로 표현
                          child: (_verifiCationStatus == VerifiCationStatus.codeSending)
                              ? SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text("인증문자 발송"),
                        ),
                        SizedBox(
                          height: common_bg_padding,
                        ),

                        /// 인증번호 입력란
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: _verifiCationStatus == VerifiCationStatus.none ? 0 : 1,

                          /// AnimatedContainer : 인증문자 발송 후에 천천히 인증번호 입력란이 보여지게 하기위해서 사용
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOut,
                            height: getVerifiCationHeight(_verifiCationStatus),
                            child: TextFormField(
                              controller: _codeController,

                              /// 키보드입력방식
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                MaskedInputFormatter("000000"),
                              ],
                              decoration: InputDecoration(
                                border: inptuBorder,
                                focusedBorder: inptuBorder,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          height: getVerifiCationBtnHeight(_verifiCationStatus),
                          child: TextButton(
                            onPressed: () {
                              attemptVerify();
                            },
                            child: (_verifiCationStatus == VerifiCationStatus.verifying)
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text("인증하기"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 인증번호 입력란 높이 조절
  double getVerifiCationHeight(VerifiCationStatus verifiCationStatus) {
    switch (verifiCationStatus) {
      case VerifiCationStatus.none:
        return 0;
      case VerifiCationStatus.codeSending:
      case VerifiCationStatus.codeSent:
      case VerifiCationStatus.verifying:
      case VerifiCationStatus.verifiCationDone:
        return 65 + common_sm_padding;
    }
  }

  /// 인증하기 버튼 높이 조절
  double getVerifiCationBtnHeight(VerifiCationStatus verifiCationStatus) {
    switch (verifiCationStatus) {
      case VerifiCationStatus.none:
        return 0;
      case VerifiCationStatus.codeSending:
      case VerifiCationStatus.codeSent:
      case VerifiCationStatus.verifying:
      case VerifiCationStatus.verifiCationDone:
        return 48;
    }
  }

  /// 인증하기 버튼 클릭시 인증중 처리함수
  Future<void> attemptVerify() async {
    setState(() {
      _verifiCationStatus = VerifiCationStatus.verifying;
    });

    // Update the UI - wait for the user to enter the SMS code
    try {
      String smsCode = "777777";

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text,
      );

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      logger.e("인증실패!");
      SnackBar snackBar = SnackBar(content: Text("잘못된 인증코드입니다."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    /// 인증완료 상태처리
    setState(() {
      _verifiCationStatus = VerifiCationStatus.verifiCationDone;
    });
  }

  _getAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? address = prefs.getString(SHARED_ADDRESS);
    logger.d("Address from SharedPref- : $address");
  }
}

/// 검증상태 값
enum VerifiCationStatus {
  none,
  codeSending,
  codeSent,
  verifying,
  verifiCationDone,
}
