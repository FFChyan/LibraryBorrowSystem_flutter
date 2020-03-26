import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libraryBorrowSystem/bookDetails/book_detail_page.dart';
import 'package:libraryBorrowSystem/bookDetails/bookdict.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:plugin_login/flutter_login.dart';
import 'dart:io';

class ResultListView extends StatelessWidget {
  ResultListView({this.bookinfodict, this.userData});

  BookInfoDict bookinfodict;
  LoginData userData;

//  BuildContext context;

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

  Widget build(BuildContext context) {
    String cover_url = bookinfodict.cover_url == null
        ? 'https://cn.bing.com/th?id=OIP.vJ-Co9Di-qxjq_fF1wyaXgHaHa&pid=Api&w=675&h=675&rs=1'
        : bookinfodict.cover_url;

    return GestureDetector(
      onTap: () {
        print("book details");
        Navigator.of(context).push(FadePageRoute(
          builder: (context) => BookDetailedPage(
            bookinfodict: bookinfodict,
            userData: userData,
          ),
        ));
      },
      child: Material(
        elevation: 5.0,
        borderRadius: Platform.isIOS
            ? BorderRadius.circular(10.0)
            : BorderRadius.circular(20.0),
        child: Stack(
          children: <Widget>[
            Container(
//            margin: EdgeInsets.all(15),
              alignment: AlignmentDirectional.bottomStart,
              decoration: BoxDecoration(
                borderRadius: Platform.isIOS
                    ? BorderRadius.circular(10.0)
                    : BorderRadius.circular(20),
                border: Border.all(
                    color: ThemeColorBlackberryWine.lightGray, width: 0),
                image: DecorationImage(
                  image: imgwithretry(cover_url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
