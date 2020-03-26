import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:libraryBorrowSystem/loginPage/login_screen.dart';

//import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:libraryBorrowSystem/themeColor/textstyle.dart';
import 'package:plugin_login/flutter_login.dart';

import 'bookdict.dart';

class BookDetailedPage extends StatefulWidget {
  BookDetailedPage({
    this.bookinfodict,
    this.userData,
  });

  final BookInfoDict bookinfodict;
  LoginData userData;

  _BookDetailedPage createState() => _BookDetailedPage();
}

class _BookDetailedPage extends State<BookDetailedPage> {
  bool hasBorrowed = false;
  String borrowDate = ' ';

  Future getBookInfo() async {
    try {
//      debugPrint(widget.bookinfodict.book_id);
      Response response = await Dio().get("http://127.0.0.1:5000/getBookInfo",
          queryParameters: {
            'book_id': widget.bookinfodict.book_id,
            'mode': 'detailed'
          });
      var jsonMap = response.data;
//      debugPrint(jsonMap.toString());
      widget.bookinfodict.author = jsonMap['author'];
      widget.bookinfodict.book_name = jsonMap['book_name'];
      widget.bookinfodict.translator = jsonMap['translator'];
      widget.bookinfodict.cover_url = jsonMap['cover_url'];
      widget.bookinfodict.basic_info = jsonMap['basic_info'];
      widget.bookinfodict.main_content = jsonMap['main_content'];
      widget.bookinfodict.author_info = jsonMap['author_info'];
      widget.bookinfodict.stock = jsonMap['stock'];
      debugPrint(widget.bookinfodict.book_id +
          ", " +
          widget.bookinfodict.book_name +
          ", " +
          widget.bookinfodict.author);
      setState(() {});
      return (widget.bookinfodict.cover_url);
    } catch (e) {
      print(e);
    }
//    return null;
  }

  Future ifBorrow() async {
    try {
      Response response =
          await Dio().get("http://127.0.0.1:5000/ifBorrow", queryParameters: {
        'book_id': widget.bookinfodict.book_id,
        'stu_id': widget.userData.stu_id,
      });
      if (response.toString() == 'False') {
        setState(() {
          hasBorrowed = false;
        });
      } else {
        setState(() {
          hasBorrowed = true;
          borrowDate = response.toString();
        });
      }
    } catch (e) {
      print(e);
    }
//    return null;
  }

  Future<bool> _borrowBook(String stu_id, String book_id) async {
    DateTime now = DateTime.now();
    String _month = '0';
    String _day = '0';
    if (now.month <= 9) {
      _month = _month + now.month.toString();
    } else {
      _month = now.month.toString();
    }
    if (now.day <= 9) {
      _day = _day + now.day.toString();
    } else {
      _day = now.day.toString();
    }
    try {
      Response response = await Dio()
          .post("http://127.0.0.1:5000/borrowBook", queryParameters: {
        'stu_id': stu_id,
        'book_id': book_id,
        'bor_date': now.year.toString() + "-" + _month + "-" + _day
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => BookDetailedPage(
            bookinfodict: widget.bookinfodict,
            userData: widget.userData,
          ),
        ));
      });
      print("response" + response.toString());
      if (response.toString() == 'True') {
        return (true);
      } else {
        return (false);
      }
    } catch (e) {
      print(e);
    }
    return (false);
  }

  @override
  void initState() {
    super.initState();
    getBookInfo();
    ifBorrow();
  }

  YYDialog YYAlertDialogWithDivider(String stu_id) {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 15.0
      ..text(
        padding: EdgeInsets.fromLTRB(5.0, 20, 5, 20),
        alignment: Alignment.center,
        text: "确认借阅\n《" + widget.bookinfodict.book_name + "》？",
        color: ThemeColorBlackberryWine.darkPurpleBlue,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.center,
      )
      ..doubleButton(
        gravity: Gravity.center,
        withDivider: false,
        text1: "取消",
        color1: ThemeColorBlackberryWine.lightGray[900],
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {
          print("取消");
        },
        text2: "确定",
        color2: ThemeColorBlackberryWine.redWine,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () {
          print("确定");
          _borrowBook(stu_id, widget.bookinfodict.book_id).then((value) => {
                if (value)
                  {print(value.toString() + '借阅成功')}
                else
                  {print(value.toString() + '借阅失败')}
              });
        },
      )
      ..show();
  }

  Widget _borrowNowBtn() {
    if (hasBorrowed && borrowDate != null) {
      return Text(
        "您已于 " + borrowDate + " 借阅此书",
        style: BookInfoTextStyle.button,
      );
    } else if (widget.userData.stu_id == '0') {
      return FlatButton(
        child: Row(
          children: <Widget>[
            Text(
              "借阅前请先登录",
              style: BookInfoTextStyle.button,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            ),
            Icon(
              FontAwesomeIcons.solidUserCircle,
              color: ThemeColorBlackberryWine.darkPurpleBlue[50],
              size: 20,
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(
              FadePageRoute(builder: (context) => LoginScreen()));
        },
      );
    }
    return FlatButton(
      child: Row(
        children: <Widget>[
          Text(
            "立即借阅",
            style: BookInfoTextStyle.button,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          ),
          Icon(
            Icons.archive,
            color: ThemeColorBlackberryWine.darkPurpleBlue[50],
            size: 20,
          ),
        ],
      ),
      onPressed: () {
        YYAlertDialogWithDivider(widget.userData.stu_id);
      },
    );
  }

  Widget _checkInventory() {
    return Row(
      children: <Widget>[
        Text(
          "馆内库存 :",
          style: BookInfoTextStyle.button,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        ),
        Text(
          widget.bookinfodict.stock == null
              ? "0"
              : widget.bookinfodict.stock.toString(),
          style: BookInfoTextStyle.button,
        ),
//          Icon(
//            Icons.search,
//            color: ThemeColorBlackberryWine.darkPurpleBlue[50],
//            size: 20,
//          ),
      ],
    );
  }

  Widget build(BuildContext context) {
    String cover_url = widget.bookinfodict.cover_url == null
        ? 'https://cn.bing.com/th?id=OIP.vJ-Co9Di-qxjq_fF1wyaXgHaHa&pid=Api&w=675&h=675&rs=1'
        : widget.bookinfodict.cover_url;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              tooltip: "返回",
              iconSize: 20,
              icon: Icon(Icons.arrow_back_ios),
              color: ThemeColorBlackberryWine.darkPurpleBlue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        backgroundColor: ThemeColorBlackberryWine.lightGray[50],
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(80),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      elevation: 8.0,
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 300,
                        height: 430,
                        decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: NetworkImage(cover_url),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      crossAxisAlignment: CrossAxisAlignment.,
                      children: <Widget>[
                        _borrowNowBtn(),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        _checkInventory(),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.bookinfodict.book_name == null
                            ? " "
                            : widget.bookinfodict.book_name,
                        style: BookInfoTextStyle.bookTitleTextStyle
                            .copyWith(fontStyle: FontStyle.normal),
//                        maxLines: 1,
//                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            widget.bookinfodict.author == null
                                ? ""
                                : widget.bookinfodict.author + "[著],  ",
                            style: BookInfoTextStyle.bookAuthorTextStyle
                                .copyWith(fontStyle: FontStyle.normal),
//                      maxLines: 1,
                            overflow: TextOverflow.ellipsis,
//                      softWrap: true,
                          ),
                          Text(
                            widget.bookinfodict.translator == null
                                ? ""
                                : widget.bookinfodict.translator + "[译]",
                            style: BookInfoTextStyle.bookAuthorTextStyle
                                .copyWith(
                                    fontSize: 12, fontStyle: FontStyle.normal),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(30),
                      ),
                      Text(
                        "主要内容",
                        style: BookInfoTextStyle.subtitle,
                      ),
                      Text(
                        widget.bookinfodict.main_content == null
                            ? " "
                            : widget.bookinfodict.main_content,
                        style: BookInfoTextStyle.normal,
                        softWrap: true,
//                      overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Text(
                        "作者简介",
                        style: BookInfoTextStyle.subtitle,
                      ),
                      Text(
                        widget.bookinfodict.author_info == null
                            ? " "
                            : widget.bookinfodict.author_info,
                        style: BookInfoTextStyle.normal,
                        softWrap: true,
                        maxLines: 1000,
//                      overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Text(
                        "书籍信息",
                        style: BookInfoTextStyle.subtitle,
                      ),
                      Text(
                        widget.bookinfodict.basic_info == null
                            ? " "
                            : widget.bookinfodict.basic_info,
                        style: BookInfoTextStyle.normal,
                        softWrap: true,
//                      overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        )

//      body: Column(
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.all(30),
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.all(50),
//              ),
//              ClipRRect(
//                  borderRadius: BorderRadius.circular(8),
//                  child: Image(
//                    image: NetworkImage(widget.bookinfodict.cover_url),
////                fit: BoxFit.fill,
//                  ),
//              ),
//              Material(
//                elevation: 5.0,
//                borderRadius: BorderRadius.circular(20.0),
//                child: Stack(
//                  children: <Widget>[
//                    Container(
////            margin: EdgeInsets.all(15),
//                        alignment: AlignmentDirectional.bottomStart,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(20),
//                          border: Border.all(
//                              color: ThemeColorBlackberryWine.lightGray,
//                              width: 0),
////                        image: DecorationImage(
////                          image:
////                              new NetworkImage(widget.bookinfodict.cover_url),
////                          fit: BoxFit.fill,
////                        ),
//                        ),
//                        child: ConstrainedBox(
//                            constraints: BoxConstraints(minWidth: 100),
//                            child: Image(
//                              image:NetworkImage(widget.bookinfodict.cover_url),
//                              fit: BoxFit.fill,
//                            ))),
//                  ],
//                ),
//              )
        );
  }
}
