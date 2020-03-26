
import 'package:flutter/material.dart';

class ThemeColorBlackberryWine{

  static const int _darkPurpleBlue = 0xFF333366;
  static const int _redWine = 0xFF990033;
  static const int _lightGray = 0xFFCCCCCC;
  static const int _orange = 0xFFFFCC33;

  static const MaterialColor darkPurpleBlue = const MaterialColor(
    _darkPurpleBlue,
    const <int, Color>{
      50: const Color(0xFF484881),
      100: const Color(0xFF454578),
      200: const Color(0xFF424275),
      300: const Color(0xFF393972),
      400: const Color(0xFF363669),
      500: const Color(_darkPurpleBlue),
      600: const Color(0xFF303060),
      700: const Color(0xFF2c2c5c),
      800: const Color(0xFF292959),
      900: const Color(0xFF262656),
    },
  );

  static const MaterialColor redWine = const MaterialColor(
      _redWine,
      const <int, Color>{
        50: const Color(0xFFff6570),
        100: const Color(0xFFd32457),
        200: const Color(0xFFcc1851),
        300: const Color(0xFFc61245),
        400: const Color(0xFF9f0639),
        500: const Color(_redWine),
        600: const Color(0xFF960030),
        700: const Color(0xFF90002a),
        800: const Color(0xFF8a0024),
        900: const Color(0xFF740018),
      },
  );

  static const MaterialColor lightGray = const MaterialColor(
      _lightGray,
      const <int, Color>{
        50: const Color(0xFFf0f0f0),
        100: const Color(0xdde0e0e0),
        200: const Color(0xFFd0d0d0),
        300: const Color(_lightGray),
        400: const Color(0xFFc0c0c0),
        500: const Color(0xFFa0a0a0),
        600: const Color(0xFF909090),
        700: const Color(0xFF808080),
        800: const Color(0xFF707070),
        900: const Color(0xFF606060),
      },
  );

  static const MaterialColor orange = const MaterialColor(
    _orange,
    const <int, Color>{
      50: const Color(0xFFffe63c),
      100: const Color(0xFFffe339),
      200: const Color(0xffffd036),
      300: const Color(_orange), // FFCC33
      400: const Color(0xFFffc930),
      500: const Color(0xFFffc62c),
      600: const Color(0xFFffc329),
      700: const Color(0xFFffc026),
      800: const Color(0xFFffbc23),
      900: const Color(0xFFffb820),
    },
  );





}