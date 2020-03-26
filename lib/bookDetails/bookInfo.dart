//import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:libraryBorrowSystem/themeColor/textstyle.dart';

import 'bookdict.dart';

class BookBasicInfo extends StatefulWidget {
  BookBasicInfo({
    this.bookinfodict,
  });

  final BookInfoDict bookinfodict;

  @override
  _BookBasicInfo createState() => _BookBasicInfo();
}

class _BookBasicInfo extends State<BookBasicInfo> {
  String defaultbookTitle = ' ';
  String defaultauthor = " ";
  DateTime defaultborrowDate = DateTime(2020, 3, 6);

  String bookTitle = ' ';
  String author = " ";
  DateTime borrowDate = DateTime(2020, 3, 6);
  DateTime today = DateTime.now();

  Future getBookInfo() async {
    Future.delayed(Duration(milliseconds: 1000)).then((e) async {
      bookTitle = widget.bookinfodict.book_name;
      author = widget.bookinfodict.author;
      borrowDate = widget.bookinfodict.bor_date;
      setState(() {});
    });
    print(widget.bookinfodict.book_name);
  }

  @override
  void initState() {
    super.initState();
    getBookInfo();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: ThemeColorBlackberryWine.lightGray[100],
        border: Border.all(color: ThemeColorBlackberryWine.lightGray, width: 0),
      ),
      height: 100,
//      color: ThemeColorBlackberryWine.lightGray[100],
//      child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              ConstrainedBox(constraints: BoxConstraints(minWidth: 10)),
              SizedBox(
                width: Size.fromWidth(180).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // 放置位置
                  crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                  children: <Widget>[
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: 10.0, minHeight: 10.0),
                    ),
                    Text(
                      bookTitle == null ? defaultbookTitle : bookTitle,
                      style: BookInfoTextStyle.bookTitleTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Text(
                      author == null ? defaultauthor : author,
                      style: BookInfoTextStyle.bookAuthorTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("剩余 ", style: BookInfoTextStyle.normal),
              Text((90 - today.difference(borrowDate).inDays).toString()),
              Text(
                " 天",
                style: BookInfoTextStyle.normal,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10),
              ),
            ],
          )
//          Icon(Icons.ac_unit),
        ],
      ),
    );
  }
}
