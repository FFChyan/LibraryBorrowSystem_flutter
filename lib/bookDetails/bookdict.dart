import 'package:flutter/cupertino.dart';

class BookInfoDict {
  BookInfoDict({
    this.book_id,
    this.book_name,
    this.bor_date,
    this.author,
    this.translator,
    this.cover_url,
    this.basic_info,
    this.main_content,
    this.author_info,
    this.stock,
  });

  String book_id;
  String book_name;
  DateTime bor_date;
  String author;
  String translator;
  String cover_url;
  String basic_info;
  String main_content;
  String author_info;
  int stock;

}
