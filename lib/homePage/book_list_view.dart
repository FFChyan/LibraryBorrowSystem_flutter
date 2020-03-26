import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:libraryBorrowSystem/bookDetails/book_detail_page.dart';
import 'package:libraryBorrowSystem/bookDetails/bookdict.dart';
import 'package:libraryBorrowSystem/homePage/homepage.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:plugin_login/flutter_login.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:libraryBorrowSystem/bookDetails/bookInfo.dart';

class BookListView extends StatefulWidget {
  BookListView({this.bookinfodict, this.context, this.userData});

  final BookInfoDict bookinfodict;
  BuildContext context;
  LoginData userData;

  @override
  _BookListView createState() => _BookListView();
}

class _BookListView extends State<BookListView> {
  DateTime today = DateTime.now();

  Future<bool> _returnBook(String stu_id, String book_id) async {
    print("还书");
    try {
      Response response = await Dio().post(
          "http://192.168.0.100:5000/returnBook",
          queryParameters: {'stu_id': stu_id, 'book_id': book_id});
//      widget.controller.addListener(() {
//        _onRefresh();
      Navigator.of(context).pushReplacement(FadePageRoute(
        builder: (context) => HomePage(userData: widget.userData),
      ));
//      });
      return (true);
    } catch (e) {
      print(e);
    }
    return (false);
  }

  YYDialog ReturnBookDialog(String booktitle, String book_id) {
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 15.0
      ..text(
        padding: EdgeInsets.fromLTRB(5.0, 20, 5, 20),
        alignment: Alignment.center,
        text: "确认归还\n《" + booktitle + "》？",
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
          int tmp = 90 - today.difference(widget.bookinfodict.bor_date).inDays;
          if (tmp < 0) {
            // 超期
            widget.userData.overdue = widget.userData.overdue - tmp;
            print("overdue=" + widget.userData.overdue.toString());
            Future.delayed(Duration(milliseconds: 200)).then((e) {
              Navigator.of(widget.context).push(FadePageRoute(
                builder: (context) => HomePage(
                  userData: widget.userData,
                  book_id: book_id,
                ),
              ));
            });
          } else {
            _returnBook(widget.userData.stu_id, book_id);
          }
        },
      )
      ..show();
  }

  Future getBookInfo() async {
    try {
      Response response = await Dio()
          .get("http://192.168.0.100:5000/getBookInfo", queryParameters: {
        'book_id': widget.bookinfodict.book_id,
        'mode': 'basic'
      });
      var jsonMap = response.data;
//      debugPrint(jsonMap.toString());
      widget.bookinfodict.author = jsonMap['author'];
      widget.bookinfodict.book_name = jsonMap['book_name'];
      widget.bookinfodict.translator = jsonMap['translator'];
      widget.bookinfodict.cover_url = jsonMap['cover_url'];
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
    return null;
  }

  @override
  void initState() {
    super.initState();
    getBookInfo();
  }

  NetworkImage imgwithretry(cover_url) {
//    String cover_url = bookinfodict.cover_url == null
//        ? 'https://cn.bing.com/th?id=OIP.vJ-Co9Di-qxjq_fF1wyaXgHaHa&pid=Api&w=675&h=675&rs=1'
//        : bookinfodict.cover_url;
//    debugPrint("begin");
    NetworkImage img;
    try {
      img = new NetworkImage(cover_url);
    } catch (w) {
      debugPrint("w");
      print(w);
      try {
        Future.delayed(Duration(milliseconds: 200)).then((e) {
          debugPrint("error once");
          img = new NetworkImage(cover_url);
        });
      } catch (e) {
        debugPrint("e");
        print(e);
        Future.delayed(Duration(milliseconds: 200)).then((e) {
          debugPrint("error twice");
          img = new NetworkImage(cover_url);
        });
      }
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    String cover_url = widget.bookinfodict.cover_url == null
        ? 'https://cn.bing.com/th?id=OIP.vJ-Co9Di-qxjq_fF1wyaXgHaHa&pid=Api&w=675&h=675&rs=1'
        : widget.bookinfodict.cover_url;
//    if (widget.userData.overdue < 0) {
//      print("罚款");
//      FineQRCodeDialog();
//    }

    return GestureDetector(
      onVerticalDragUpdate: (dragDetails) {
        if (dragDetails.delta.dy > 30 || dragDetails.delta.dy < -30) {
          ReturnBookDialog(
              widget.bookinfodict.book_name, widget.bookinfodict.book_id);
//          Navigator.of(widget.context).pushReplacement(FadePageRoute(
//            builder: (context) => HomePage(userData: widget.userData),
//          ));
        }
      },
      onTap: () {
        Navigator.of(context).push(FadePageRoute(
          builder: (context) => BookDetailedPage(
              bookinfodict: widget.bookinfodict, userData: widget.userData),
        ));
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Container(
                alignment: AlignmentDirectional.bottomStart,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  ///圆角
                  border: Border.all(
                      color: ThemeColorBlackberryWine.lightGray, width: 0),

                  ///边框颜色、宽
                  image: DecorationImage(
                    image: imgwithretry(cover_url),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                ),
                child: BookBasicInfo(
                  bookinfodict: widget.bookinfodict,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
