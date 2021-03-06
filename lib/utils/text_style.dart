import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Style {
  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');

  static final commonTextStyle = baseTextStyle.copyWith(
    color: const Color(0xffb6b2df),
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  );

  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 9.0,
  );

  static final strongTitleTextStyle = titleTextStyle.copyWith(
    fontSize: 20.0,
  );

  static final titleTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );

  static final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  static final subtitleTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  static final hyperlink = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 15.0,
    decoration: TextDecoration.underline,
  );

  static final numberFormatter = NumberFormat("###,###,###", "en_US");
}
