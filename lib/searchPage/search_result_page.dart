import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:libraryBorrowSystem/homePage/homepage.dart';
import 'package:libraryBorrowSystem/loginPage/custom_route.dart';
import 'package:plugin_login/flutter_login.dart';
import 'search_result_body.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';

class searchResultsPage extends StatelessWidget {
  searchResultsPage({this.keyword, this.userData}) : super();

  final String keyword;
  LoginData userData;

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GestureDetector(
        child: new SearchResultBody(_controller, keyword, userData),
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 30) {
            print(details.delta.dx);
            Navigator.of(context).pushReplacement(FadePageRoute(
                builder: (context) => HomePage(
                      userData: userData,
                    )));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Material(
        shadowColor: ThemeColorBlackberryWine.darkPurpleBlue,
        shape: new CircleBorder(),
        color: ThemeColorBlackberryWine.darkPurpleBlue,
        elevation: 4,
        child: IconButton(
          color: ThemeColorBlackberryWine.orange,
          icon: Icon(
            Icons.vertical_align_top,
            size: 30,
          ),
          onPressed: () {
            _controller.animateTo(.0,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
      ),
    );
  }
}
