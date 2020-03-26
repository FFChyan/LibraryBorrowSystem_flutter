import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libraryBorrowSystem/bookDetails/bookdict.dart';
import 'package:libraryBorrowSystem/homePage/homepage.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:libraryBorrowSystem/themeColor/textstyle.dart';
import 'package:plugin_login/flutter_login.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'check_others_list_single_item.dart';
import 'dart:io';

class DartHelper {
  static bool isNullOrEmpty(String value) => value == '' || value == null;
}

class CheckOthersBorrowPage extends StatefulWidget {
  CheckOthersBorrowPage({this.otherId, this.userData});

  String otherId = '';
  LoginData userData;

  _CheckOthersBorrowPage createState() => _CheckOthersBorrowPage();
}

class _CheckOthersBorrowPage extends State<CheckOthersBorrowPage> {
  final _othersIdFocusNode = FocusNode();
  TextEditingController _othersIdEditingController;

  int book_numbers = 0;
  List<BookInfoDict> _borrowList = [];

  void getBorrowList() async {
    try {
      Response response = await Dio().get(
          "http://192.168.0.100:5000/borrowlist",
          queryParameters: {'stu_id': widget.otherId});
      var jsonMap = response.data;
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

  Widget _itemBuilder() {
    List<TimelineModel> items = [];
    for (BookInfoDict item in _borrowList) {
      items.add(TimelineModel(
          CheckOtherSingleItem(
            bookInfoDict: item,
            userData: widget.userData,
          ),
          position: TimelineItemPosition.random,
          iconBackground: Colors.transparent,
          icon: Icon(
            FontAwesomeIcons.bookOpen,
            color: ThemeColorBlackberryWine.darkPurpleBlue[200],
          )));
    }
    return Timeline(
      children: items,
      position: TimelinePosition.Left,
      lineColor: ThemeColorBlackberryWine.redWine[700],
      lineWidth: 2,
    );
  }

  @override
  void initState() {
    super.initState();
    if (!DartHelper.isNullOrEmpty(widget.otherId)) getBorrowList();
  }

  Widget webPage() {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  width: 300,
                  height: Platform.isIOS ? 10 : 50,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ThemeColorBlackberryWine.lightGray[100],
                      hintText: DartHelper.isNullOrEmpty(widget.otherId)
                          ? "您想查询的学号"
                          : widget.otherId,
//                        labelText: "学号",
                      labelStyle: BookInfoTextStyle.normal
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w300),
                      prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColorBlackberryWine.darkPurpleBlue,
                            width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColorBlackberryWine.redWine,
                            width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    ),
                    controller: _othersIdEditingController,
                    focusNode: _othersIdFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onSubmitted: (value) {
                      Navigator.of(context).pushReplacement(FadePageRoute(
                        builder: (context) => CheckOthersBorrowPage(
                          otherId: value,
                          userData: widget.userData,
                        ),
                      ));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
//          Divider(
////            color: ThemeColorBlackberryWine.lightGray[700],
//            color: Colors.black87,
//            thickness: 20,
//            height: 200,
//          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: Platform.isIOS
                  ? EdgeInsets.fromLTRB(0, 30, 0, 0)
                  : EdgeInsets.fromLTRB(300, 60, 0, 0),
            ),
//              SizedBox(
//                child: Text(
//                  "该学生借阅中的书籍有",
//                  style: BookInfoTextStyle.subtitle
//                      .copyWith(fontWeight: FontWeight.w400),
//                ),
//              ),
            SizedBox(
              height: 500,
              width: 1000,
              child: _itemBuilder(),
//                ListView.builder(
//                    itemCount: book_numbers,
//                    itemBuilder: (BuildContext context, int index) =>
//                        _itemBuilder(_borrowList[index])),
            ),
          ],
        ),
      ],
    );
  }

  Widget iOSPage() {
    return GestureDetector(
      onHorizontalDragDown: (s) {
        if (s.globalPosition.dx < 100) {
          print("s.globalPosition.dx=" + s.globalPosition.dx.toString());
          Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => HomePage(userData: widget.userData),
          ));
        }
      },
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(20)),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ThemeColorBlackberryWine.lightGray[100],
                        hintText: DartHelper.isNullOrEmpty(widget.otherId)
                            ? "您想查询的学号"
                            : widget.otherId,
//                        labelText: "学号",
                        labelStyle: BookInfoTextStyle.normal.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w300),
                        prefixIcon: Icon(FontAwesomeIcons.solidUserCircle),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeColorBlackberryWine.darkPurpleBlue,
                              width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeColorBlackberryWine.redWine,
                              width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      ),
                      controller: _othersIdEditingController,
                      focusNode: _othersIdFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      onSubmitted: (value) {
                        Navigator.of(context).pushReplacement(FadePageRoute(
                          builder: (context) => CheckOthersBorrowPage(
                            otherId: value,
                            userData: widget.userData,
                          ),
                        ));
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
//          Divider(
////            color: ThemeColorBlackberryWine.lightGray[700],
//            color: Colors.black87,
//            thickness: 20,
//            height: 200,
//          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(300, 30, 0, 0),
              ),
//              SizedBox(
//                child: Text(
//                  "该学生借阅中的书籍有",
//                  style: BookInfoTextStyle.subtitle
//                      .copyWith(fontWeight: FontWeight.w400),
//                ),
//              ),
              SizedBox(
                height: 700,
                width: 1000,
                child: _itemBuilder(),
//                ListView.builder(
//                    itemCount: book_numbers,
//                    itemBuilder: (BuildContext context, int index) =>
//                        _itemBuilder(_borrowList[index])),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).pushReplacement(FadePageRoute(
                  builder: (context) => HomePage(
                        userData: widget.userData,
                      )));
            },
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Platform.isIOS ? iOSPage() : webPage(),
    );
  }
}
