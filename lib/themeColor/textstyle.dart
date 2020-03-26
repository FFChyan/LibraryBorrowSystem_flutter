

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libraryBorrowSystem/themeColor/blackberrywine_themecolor.dart';

class BookInfoTextStyle{

  static TextStyle bookTitleTextStyle = TextStyle(
//      color: Colors.black54,
      color: ThemeColorBlackberryWine.darkPurpleBlue,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      fontSize: 25.0,
  );

  static TextStyle bookAuthorTextStyle = TextStyle(
//      color: Colors.black54,
    color: ThemeColorBlackberryWine.redWine[700],
    fontFamily: "Quicksand",
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    fontSize: 15.0,
  );

  static TextStyle normal = TextStyle(
      color: Colors.black87,
//    color: ThemeColorBlackberryWine.redWine[700],
    fontFamily: "Quicksand",
    fontWeight: FontWeight.w300,
//    fontStyle: FontStyle.italic,
    fontSize: 10.0,
  );

  static TextStyle subtitle = TextStyle(
    color: ThemeColorBlackberryWine.darkPurpleBlue[800],
//    color: ThemeColorBlackberryWine.redWine[700],
    fontFamily: "Quicksand",
    fontWeight: FontWeight.w500,
//    fontStyle: FontStyle.italic,
    fontSize: 20.0,
  );

  static TextStyle button = TextStyle(
    color: ThemeColorBlackberryWine.redWine[900],
    fontFamily: "Quicksand",
    fontWeight: FontWeight.w300,
//    fontStyle: FontStyle.italic,
    fontSize: 13.0,
//    decoration: TextDecoration.underline,
  );





}