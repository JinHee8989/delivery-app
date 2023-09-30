import "dart:convert";
import "dart:io";

import "package:delivery/common/component/custom_text_form_field.dart";
import "package:delivery/common/const/colors.dart";
import "package:delivery/common/const/data.dart";
import "package:delivery/common/layout/default_layout.dart";
import "package:delivery/common/view/root_tab.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // localhost
    final emulatorIp = '10.0.2.2';
    final simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: PRIMARY_COLOR,
                    ),
                    onPressed: () async {
                      // ID:비밀번호
                      final rawString = '$username:$password';

                      // 일반 string을 base64로 변환할때 쓰는 코드
                      Codec<String, String> stringToBase64 = utf8.fuse(base64);

                      String token = stringToBase64.encode(rawString);

                      final resp = await dio.post('http://$ip/auth/login',
                          options: Options(
                            headers: {
                              'authorization': 'Basic $token',
                            },
                          ));

                      final refreshToken = resp.data['refreshToken'];
                      final accessToken = resp.data['accessToken'];

                      await storage.write(
                          key: REFRESH_TOKEN_KEY, value: refreshToken);
                      await storage.write(
                          key: ACCESS_TOKEN_KEY, value: accessToken);

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => RootTab()));
                    },
                    child: const Text(
                      '로그인',
                    )),
                TextButton(
                    onPressed: () async {
                      final refreshToken =
                          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY5NjA3NjY3OSwiZXhwIjoxNjk2MTYzMDc5fQ.-7WOH1_AyUuv1eC0gydcTkWYz0ncmsdBQqAEFz4uyF8';

                      final resp = await dio.post(
                        'http://$ip/auth/token',
                        options: Options(
                          headers: {
                            'authorization': 'Bearer $refreshToken',
                          },
                        ),
                      );
                    },
                    style: TextButton.styleFrom(primary: Colors.black),
                    child: const Text('회원가입'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다.',
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('이메일과 비밀번호를 입력해서 로그인 해주세요! \n오늘도 성공적인 주문이 되길 :)',
        style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR));
  }
}