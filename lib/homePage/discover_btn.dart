import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';
import 'package:libraryBorrowSystem/searchPage/search_result_page.dart';
import 'package:plugin_login/flutter_login.dart';

class DiscoverButton extends StatefulWidget {
  DiscoverButton({this.theme, this.userData});

  final ThemeData theme;
  LoginData userData;

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<DiscoverButton>
    with TickerProviderStateMixin {
  AnimationController controller;
  String keyword = '';

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        shadowColor: Colors.black,
        shape: StadiumBorder(),
        color: ThemeColorBlackberryWine.darkPurpleBlue[800],
        elevation: 8,
        child: Container(
          alignment: AlignmentDirectional.centerEnd,
          child: _child(),
          color: Colors.transparent,
          width: 60 + (290 - 60) * controller.value,
          height: 60,
        ));
  }

  Widget _child() {
    if (controller.value < 0.5) {
      return Opacity(
          opacity: (0.5 - controller.value) * 2.0,
          child: Container(
              color: Colors.transparent,
              width: 60,
              height: 60,
              child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    keyword = '';
                    controller.forward();
                  },
                  child: Icon(
                    Icons.search,
                    color: ThemeColorBlackberryWine.orange[100],
                  ))));
    } else {
      return Opacity(
          opacity: (controller.value - 0.5) * 2.0,
          child: Row(
            children: <Widget>[
              Flexible(
                  child: Container(
                padding: EdgeInsets.only(left: 25),
                child: TextField(
                  style: TextStyle(
                      color: ThemeColorBlackberryWine.orange,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.library_books,
                        color: ThemeColorBlackberryWine.orange,
                      ),
                      labelText: "搜索馆藏",
                      labelStyle: TextStyle(
                        color: ThemeColorBlackberryWine.orange,
                        fontWeight: FontWeight.bold,
                      )),
                  onSubmitted: (s) {
                    if (keyword != s) {
                      keyword = s;
                      Navigator.of(context).push(FadePageRoute(
                        builder: (context) => searchResultsPage(
                          keyword: s,
                          userData: widget.userData,
                        ), // search result home page
                      ));
                    } else {
                      keyword = s;
                    }
                  },
                ),
              )),
              Container(
                  color: Colors.transparent,
                  width: 60,
                  height: 60,
                  child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        controller.reverse();
                        if (keyword != null) {
                          print(keyword);
//                    Provider.of<WordChangeNotifier>(context)
//                            .insertWord(keyword, widget.at);
                          Navigator.of(context).push(FadePageRoute(
                            builder: (context) => searchResultsPage(
                              keyword: keyword,
                              userData: widget.userData,
                            ), // search result home page
                          ));
                        }
                      },
                      child: Icon(
                        Icons.check,
                        color: ThemeColorBlackberryWine.orange,
                      )))
            ],
          ));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
