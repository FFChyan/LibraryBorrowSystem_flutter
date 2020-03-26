import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:libraryBorrowSystem/checkOthersBorrowList/check_others_list_page.dart';
import 'package:libraryBorrowSystem/loginPage/login_screen.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:libraryBorrowSystem/themeColor/textstyle.dart';
import 'package:plugin_login/flutter_login.dart';
import 'discover_btn.dart';
import 'book_list_view.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:libraryBorrowSystem/bookDetails/bookdict.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  HomePage({this.userData, this.book_id});

  LoginData userData;
  String book_id = '';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<BookInfoDict> _borrowList = []; // 必须初始化=[]
  int book_numbers = 0;

  void getBorrowList() async {
    try {
      Response response = await Dio().get(
          "http://192.168.0.100:5000/borrowlist",
          queryParameters: {'stu_id': widget.userData.stu_id});
      var jsonMap = response.data;
//      print(response);
      book_numbers = jsonMap['book_id'].length;
      print("book_number=" + book_numbers.toString());
      for (var _i = 0; _i < jsonMap['book_id'].length; _i++) {
        BookInfoDict newone = new BookInfoDict(
            book_id: jsonMap['book_id'][_i].toString(),
            bor_date: DateTime.parse(jsonMap['bor_date'][_i]));
        _borrowList.add(newone);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _returnBook(String stu_id, String book_id) async {
    print("还书");
    try {
      Response response = await Dio().post("http://192.168.0.100:5000/returnBook",
          queryParameters: {'stu_id': stu_id, 'book_id': book_id});
      print(response);
      widget.userData.overdue = 0;
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => HomePage(userData: widget.userData),
        ));
      });
      return (true);
    } catch (e) {
      print(e);
    }
    return (false);
  }

  @override
  void initState() {
    super.initState();
    getBorrowList();
  }

  // 罚款页面
  Widget _finePage() {
    print(widget.userData.overdue);
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            '请先交纳超期罚金, 共计 ' + (widget.userData.overdue * 0.5).toString() + " 元",
            style: BookInfoTextStyle.subtitle,
          ),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          SizedBox(
            width: 200,
            height: 300,
            child: Image(
              image: AssetImage('assets/images/alipay_fine.jpg'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("我已支付"),
                onPressed: () {
                  _returnBook(widget.userData.stu_id, widget.book_id);
                },
              ),
              FlatButton(
                child: Text("放弃还书"),
                onPressed: () {
                  widget.userData.overdue = 0;
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _bottomText() {
    return Positioned(
        bottom: 0,
        child: Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(10),
          child: Text('上滑还书'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    PageController controller;
    try {
      controller = Platform.isIOS
          ? PageController(initialPage: 0, viewportFraction: 0.8)
          : PageController(initialPage: 1, viewportFraction: 0.28);
    } catch (e) {
      controller = PageController(initialPage: 1, viewportFraction: 0.28);
    }
    controller.addListener(() {});
    print('homepage - overdue= ' + widget.userData.overdue.toString());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            tooltip: "退出登录",
            iconSize: 20,
            icon: Icon(Icons.arrow_back_ios),
            color: ThemeColorBlackberryWine.darkPurpleBlue,
            onPressed: () {
              Navigator.of(context).pushReplacement(FadePageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          ),
          actions: <Widget>[
            Material(
              shadowColor: ThemeColorBlackberryWine.darkPurpleBlue,
              shape: new CircleBorder(),
              color: ThemeColorBlackberryWine.darkPurpleBlue,
              elevation: 4,
              child: IconButton(
                color: ThemeColorBlackberryWine.orange,
                icon: Icon(
                  Icons.assignment,
                  size: 30,
                ),
                tooltip: "查询他人借阅情况",
                onPressed: () {
                  Navigator.of(context).push(FadePageRoute(
                      builder: (context) => CheckOthersBorrowPage(
                            otherId: '',
                            userData: widget.userData,
                          )));
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ThemeColorBlackberryWine.lightGray[50],
      body:
//      Column(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
//        children: <Widget>[
//          Column(
//            children: <Widget>[
////              ConstrainedBox(constraints: BoxConstraints(minHeight: 60),),
//              Row(
//                children: <Widget>[
//                  ConstrainedBox(constraints: BoxConstraints(minWidth: 20),),
//                  Text("最近需还的书",
//                    style: BookInfoTextStyle.normal.copyWith(fontSize: 12),),
//                ],
//              ),
//              ConstrainedBox(constraints: BoxConstraints(minHeight: 10),),
//              Row(
//                children: <Widget>[
//                  ConstrainedBox(constraints: BoxConstraints(minWidth: 20),),
//                  Text("剩余",
//                      style: BookInfoTextStyle.normal.copyWith(fontSize: 12)),
//                ],
//              ),
//            ],
//          ),
          Center(
        child: SizedBox.fromSize(
          size:
              Platform.isIOS ? Size.fromHeight(500.0) : Size.fromHeight(500.0),
//              Size.fromHeight(500.0),
          child: (book_numbers == 0 && widget.userData.overdue == 0)
              ? (Center(
                  child: Text(
                  widget.userData.stu_id == '0'
                      ? '您当前处于游客模式，无法查看个人借阅\n您可以查询他人借阅情况 ↗\n或点击搜索按钮寻找爱书~ ↘'
                      : "您目前没有正在借阅中的书籍\n您可以查询他人借阅情况 ↗\n或点击搜索按钮寻找爱书~ ↘",
                  style: BookInfoTextStyle.normal.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                )))
              : ((widget.userData.overdue > 0)
                  ? _finePage()
                  : PageView.builder(
                      controller: controller,
                      itemCount: book_numbers,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: Platform.isIOS
                              ? EdgeInsets.fromLTRB(20, 0, 20, 50)
                              : EdgeInsets.fromLTRB(35, 0, 45, 50),
//                          padding: EdgeInsets.fromLTRB(35, 0, 45, 50),
                          child: BookListView(
                            bookinfodict:
                                _borrowList[index], // 传入的已经是bookinfodict类了
                            context: context,
                            userData: widget.userData,
                          ),
                        );
                      },
                    )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: DiscoverButton(
        userData: widget.userData,
      ),
    );
  }
}
