import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libraryBorrowSystem/bookDetails/book_detail_page.dart';
import 'package:libraryBorrowSystem/bookDetails/bookdict.dart';
import 'package:libraryBorrowSystem/checkOthersBorrowList/check_others_list_page.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:libraryBorrowSystem/themeColor/textstyle.dart';
import 'package:plugin_login/flutter_login.dart';
import 'dart:io';

class CheckOtherSingleItem extends StatefulWidget {
  CheckOtherSingleItem({this.bookInfoDict, this.userData});

  BookInfoDict bookInfoDict;
  LoginData userData;

  _CheckOthersSingleItem createState() => _CheckOthersSingleItem();
}

class _CheckOthersSingleItem extends State<CheckOtherSingleItem> {
  String borrowDate = '';

  Future getBookInfo() async {
    try {
      Response response = await Dio().get("http://192.168.0.100:5000/getBookInfo",
          queryParameters: {
            'book_id': widget.bookInfoDict.book_id,
            'mode': 'detailed'
          });
      var jsonMap = response.data;
//      debugPrint(jsonMap.toString());
      widget.bookInfoDict.author = jsonMap['author'];
      widget.bookInfoDict.book_name = jsonMap['book_name'];
      widget.bookInfoDict.translator = jsonMap['translator'];
      widget.bookInfoDict.cover_url = jsonMap['cover_url'];
      widget.bookInfoDict.basic_info = jsonMap['basic_info'];
      widget.bookInfoDict.main_content = jsonMap['main_content'];
      widget.bookInfoDict.author_info = jsonMap['author_info'];
      widget.bookInfoDict.stock = jsonMap['stock'];
      debugPrint(widget.bookInfoDict.book_id +
          ", " +
          widget.bookInfoDict.book_name +
          ", " +
          widget.bookInfoDict.author);
      setState(() {});
      return (widget.bookInfoDict.cover_url);
    } catch (e) {
      print(e);
    }
//    return null;
  }

  @override
  void initState() {
    super.initState();
    getBookInfo();
  }

  @override
  Widget build(BuildContext context) {
    String cover_url = widget.bookInfoDict.cover_url == null
        ? 'https://cn.bing.com/th?id=OIP.vJ-Co9Di-qxjq_fF1wyaXgHaHa&pid=Api&w=675&h=675&rs=1'
        : widget.bookInfoDict.cover_url;

    String author = widget.bookInfoDict.author == null
        ? ''
        : widget.bookInfoDict.author + "[著]";
    String translator = DartHelper.isNullOrEmpty(widget.bookInfoDict.translator)
        ? ''
        : ", " + widget.bookInfoDict.translator + "[译]";

    String borrowDate = widget.bookInfoDict.bor_date.year.toString() +
        "-" +
        widget.bookInfoDict.bor_date.month.toString() +
        "-" +
        widget.bookInfoDict.bor_date.day.toString();

    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(FadePageRoute(
                  builder: (context) => BookDetailedPage(
                      bookinfodict: widget.bookInfoDict,
                      userData: widget.userData),
                ));
              },
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  width: 140,
                  height: 200,
                  decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: new NetworkImage(cover_url),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            ConstrainedBox(
                constraints: Platform.isIOS
                    ? BoxConstraints(maxWidth: 170)
                    : BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.bookInfoDict.book_name == null
                          ? " "
                          : widget.bookInfoDict.book_name,
                      style: BookInfoTextStyle.bookTitleTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal),
                    ),
                    Text(
                      author + translator,
                      style: BookInfoTextStyle.bookAuthorTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal),
                    ),
                    Text(
                      "借阅日期: " + borrowDate,
                      style: BookInfoTextStyle.normal
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                    ),
                    Text(
                      widget.bookInfoDict.basic_info == null
                          ? ""
                          : "书籍信息: " + widget.bookInfoDict.basic_info,
                      style: BookInfoTextStyle.normal,
                      softWrap: true,
                    ),
                    Text(
                      widget.bookInfoDict.main_content == null
                          ? ""
                          : "主要内容: " + widget.bookInfoDict.main_content,
                      style: BookInfoTextStyle.normal,
                      softWrap: true,
                      maxLines: 5,
//                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ))
          ],
//      ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
