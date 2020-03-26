import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:libraryBorrowSystem/bookDetails/bookdict.dart';
import 'package:plugin_login/flutter_login.dart';
import 'search_result_list.dart';
//class SearchResultBody extends StatefulWidget{
//
//
//
//  _SearchResultBody  createState() => _SearchResultBody();
//
//}


class SearchResultBody extends StatelessWidget {
  SearchResultBody([this._controller,this._keyword,this.userData]) : super();

  ScrollController _controller;
  String _keyword;
  LoginData userData;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Expanded(flex: 1, child: new InstaStories()),
        Flexible(child: SearchResultList(_controller, _keyword,userData))
      ],
    );
  }
}
