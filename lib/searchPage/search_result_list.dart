import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libraryBorrowSystem/bookDetails/bookdict.dart';
import 'package:libraryBorrowSystem/homePage/homepage.dart';
import 'package:libraryBorrowSystem/homePage/result_listview.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:plugin_login/flutter_login.dart';
import 'search_result_page.dart';
import 'dart:io';

class SearchResultList extends StatefulWidget {
  SearchResultList([this._controller, this.keyword, this.userData]) : super();

  ScrollController _controller;
  String keyword;
  LoginData userData;

  _SearchResultList createState() => _SearchResultList();
}

class _SearchResultList extends State<SearchResultList> {
  List<BookInfoDict> _resultList = []; // 必须初始化=[]
  int book_numbers = 0;

  void getResultList() async {
    try {
      Response response = await Dio().get("http://192.168.0.100:5000/searchResult",
          queryParameters: {'keyword': widget.keyword, 'mode': 'basic'});
      var jsonMap = response.data;
      book_numbers = jsonMap['book_id'].length;
      for (var _i = 0; _i < jsonMap['book_id'].length; _i++) {
        BookInfoDict newone = new BookInfoDict(
          book_id: jsonMap['book_id'][_i].toString(),
          book_name: jsonMap['book_name'][_i].toString(),
          author: jsonMap['author'][_i].toString(),
          translator: jsonMap['translator'][_i].toString(),
          cover_url: jsonMap['cover_url'][_i].toString(),
        );
        _resultList.add(newone);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getResultList();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 50),
                child: new SizedBox(
                  child: Row(
                    children: <Widget>[
                      IconButton(
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
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: widget.keyword == ""
                                  ? "搜索全馆"
                                  : widget.keyword),
                          onSubmitted: (keyword) {
                            print(keyword);
                            Navigator.of(context).pushReplacement(FadePageRoute(
                              builder: (context) => searchResultsPage(
                                keyword: keyword,
                                userData: widget.userData,
                              ),
                            )); // search result home page
                          },
                        ),
                      ),
                      SizedBox(
                        width: Platform.isIOS ? 30.0 : 30.0,
                      ),
                    ],
                  ),
                  height: deviceSize.height * 0.05,
                )),
          ),
          Expanded(
            child: GridView.count(
              controller: widget._controller,
              //      padding: EdgeInsets.all(5.0),
              crossAxisCount: 3,
              //一行多少个
              scrollDirection: Axis.vertical,
              //滚动方向
              crossAxisSpacing: 0.0,
              // 左右间隔
              mainAxisSpacing: Platform.isIOS ? 0.0 : 40.0,
              // 上下间隔
              childAspectRatio: 0.7,
              //宽高比
              children: List.generate(
                //设置itemView
                book_numbers,
                (index) => Center(
                  child: Padding(
                    padding: Platform.isIOS? EdgeInsets.all(15.0) : const EdgeInsets.all(30.0),
                    child: ResultListView(
                      bookinfodict: _resultList[index],
                      userData: widget.userData,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
