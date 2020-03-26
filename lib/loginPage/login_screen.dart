import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:libraryBorrowSystem/searchPage/search_result_page.dart';
import 'package:plugin_login/flutter_login.dart';
import 'constants.dart';
import 'custom_route.dart';
import 'dashboard_screen.dart';
import 'users.dart';
import 'package:ant_icons/ant_icons.dart';
import 'package:libraryBorrowSystem/homePage/homepage.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  var _data = 'logout';

  Future<String> _SignUpUser(LoginData data) async {
    print("11) 后端注册");
    try {
      Response response = await Dio().post("http://192.168.0.100:5000/signup",
          queryParameters: {
            'stu_id': data.stu_id,
            'stu_pwd': data.password,
            'stu_name': data.stuName
          });
      _data = response.data.toString();
      print("data="+_data);
    } catch (e) {
      print(e);
    }
    return _data;
  }

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.stu_id)) {
//        return 'Username not exists';
        return '用户名不存在';
      }
      if (mockUsers[data.stu_id] != data.password) {
        return '密码错误';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return '用户名不存在';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    debugPrint("1) Login main page");

    return FlutterLogin(
      title: Constants.appName,
//      logo: Icon(AntIcons.account_book),
      logo: 'assets/images/ecorp.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      messages: LoginMessages(
          usernameHint: '姓名',
          userIdHint: '学号',
          passwordHint: '密码',
          confirmPasswordHint: '确认密码',
          loginButton: '登录',
          signupButton: '注册',
          forgotPasswordButton: '忘记密码',
          recoverPasswordButton: '立即发送',
          goBackButton: '返回',
          confirmPasswordError: '两次密码不一致',
          recoverPasswordIntro: '这种事情经常发生，不是你就是我',
          recoverPasswordDescription: '我们会发一封邮件到你的学校邮箱\n请确认查收',
          recoverPasswordSuccess: '邮件已成功发送',
          touristMode: "游客模式"),
      // theme: LoginTheme(
      //   primaryColor: Colors.teal,
      //   accentColor: Colors.yellow,
      //   errorColor: Colors.deepOrange,
      //   pageColorLight: Colors.indigo.shade300,
      //   pageColorDark: Colors.indigo.shade500,
      //   titleStyle: TextStyle(
      //     color: Colors.greenAccent,
      //     fontFamily: 'Quicksand',
      //     letterSpacing: 4,
      //   ),
      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.orange,
      //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
      //   buttonStyle: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Colors.yellow,
      //   ),
      //   cardTheme: CardTheme(
      //     color: Colors.yellow.shade100,
      //     elevation: 5,
      //     margin: EdgeInsets.only(top: 15),
      //     shape: ContinuousRectangleBorder(
      //         borderRadius: BorderRadius.circular(100.0)),
      //   ),
//         inputTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.purple.withOpacity(.1),
//           contentPadding: EdgeInsets.zero,
//           errorStyle: TextStyle(
//             backgroundColor: Colors.orange,
//             color: Colors.white,
//           ),
      //     labelStyle: TextStyle(fontSize: 12),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      // ),
      emailValidator: (value) {
//        if (!value.contains('@') || !value.endsWith('.com')) {
        if (value
                .replaceAll('0', '')
                .replaceAll('1', '')
                .replaceAll('2', '')
                .replaceAll('3', '')
                .replaceAll('4', '')
                .replaceAll('5', '')
                .replaceAll('6', '')
                .replaceAll('7', '')
                .replaceAll('8', '')
                .replaceAll('9', '') !=
            '') {
          // 这个有待修改
          return "学号只包含数字";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return '密码不能为空'; // password is empty
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.stu_id}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.stu_id}');
        print('Password: ${loginData.password}');
        return _SignUpUser(loginData);
      },
      // 登录之后的界面
      onSubmitAnimationCompleted: (loginData) {
        Navigator.of(context).push(FadePageRoute(
          builder: (context) => HomePage(
            userData: loginData,
          ),
        ));
      },
      touristModeAccess: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => HomePage(
            userData: LoginData(stu_id: '0', password: '0', overdue: 0),
          ),
//              searchResultsPage(
//            userData: LoginData(stu_id: '0', password: '0',overdue: 0),
//            keyword: "",
//          ),
        ));
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }
}
