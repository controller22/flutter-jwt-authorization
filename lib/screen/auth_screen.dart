import 'package:calendar_scheduler/component/login_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {

    final provider=context.watch<ScheduleProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/img/logo.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              LoginTextField(
                  validator: (String? val) {
                    if (val?.isEmpty ?? true) {
                      return '이메일을 입력해주세요.';
                    }
                    // 정규 표현 식을 이용 해서 이메일 형식 인지 확인
                    RegExp reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                    if (!reg.hasMatch(val!)) {
                      return '이메일의 형식이 올바르지않습니다.';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    email = val!;
                  },
                  hintText: '이메일',
                  obscureText: false),
              const SizedBox(
                height: 8.0,
              ),
              LoginTextField(
                  validator: (String? val) {
                    if (val?.isEmpty ?? true) {
                      return '비밀번호를 입력해주세요.';
                    }
                    if (val!.length < 4 || val.length > 8) {
                      return '비밀번호는 4자리에서 8자리로 해주세요!';
                    }
                    return null;
                  },
                  onSaved: (String? val) {
                    password = val!;
                  },
                  hintText: '비밀번호',
                  obscureText: true),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: SECONDARY_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                onPressed: () {
                  onRegisterPress(provider);
                },
                child: Text('회원가입'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: SECONDARY_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                onPressed: () {
                    onLoginPress(provider);
                },
                child: Text('로그인 '),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool saveAndValidateForm() {
    if (!formKey.currentState!.validate()) {
    return false;
    }

    formKey.currentState!.save();
    return true;
  }

  onRegisterPress(ScheduleProvider provider) async {

    // 미리 만들어 둔 함수로 form 검증
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;

    try {
      //회원가입 로직실행
      await provider.register(email: email, password: password);
    } on DioError catch (e) {
      // 에러가 있는 경우 message 변수에 저장, 에러 x 기본값 입력
      message = e.response?.data['message'] ?? '알 수 없는 오류가 발생 하였습니다.';
    } catch (e) {
      message = '알 수 없는 오류가 발생 하였습니다.';
    } finally {
      // 에러 메세지가 null이 아닌 경우, 스낵바에 값을 담아서 사용자에게 보여줌
      if (message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } else {
        // 에러가 없는 경우 홈 스크린으로 이동
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    }
  }

  onLoginPress(ScheduleProvider provider) async {
    // 미리 만들어 둔 함수로 form 검증
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;

    try {
      //로그인 로직실행
      await provider.login(email: email, password: password);
    } on DioError catch (e) {
      // 에러가 있는 경우 message 변수에 저장, 에러 x 기본값 입력
      message = e.response?.data['message'] ?? '알 수 없는 오류가 발생 하였습니다.';
    } catch (e) {
      message = '알 수 없는 오류가 발생 하였습니다.';
    } finally {
      // 에러 메세지가 null이 아닌 경우, 스낵바에 값을 담아서 사용자에게 보여줌
      if (message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } else {
        // 에러가 없는 경우 홈 스크린으로 이동
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    }
  }
}
