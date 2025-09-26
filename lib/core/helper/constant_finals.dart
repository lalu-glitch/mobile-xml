import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

String baseURL = '${dotenv.env['BASE_URL']}';

class Styles {
  static final TextStyle kNunitoBold = GoogleFonts.nunito(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle kNunitoSemiBold = GoogleFonts.nunito(
    fontWeight: FontWeight.w600,
  );
  static final TextStyle kNunitoMedium = GoogleFonts.nunito(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle kNunitoRegular = GoogleFonts.nunito(
    fontWeight: FontWeight.w400,
  );
}

class Screen {
  static final FlutterView view =
      WidgetsBinding.instance.platformDispatcher.views.first;
  static final Size size = view.physicalSize / view.devicePixelRatio;

  static final double width = size.width;
  static final double height = size.height;

  static final double blockSizeHorizontal = width / 100;
  static final double blockSizeVertical = height / 100;

  static final double kSize2 = blockSizeHorizontal * 0.5;
  static final double kSize4 = blockSizeHorizontal * 1;
  static final double kSize8 = blockSizeHorizontal * 1.87;
  static final double kSize10 = blockSizeHorizontal * 2.35;
  static final double kSize11 = blockSizeHorizontal * 2.5;
  static final double kSize12 = blockSizeHorizontal * 2.85;
  static final double kSize14 = blockSizeHorizontal * 3.25;
  static final double kSize16 = blockSizeHorizontal * 3.75;
  static final double kSize18 = blockSizeHorizontal * 4.25;
  static final double kSize20 = blockSizeHorizontal * 4.675;
  static final double kSize24 = blockSizeHorizontal * 5.5;
  static final double kSize28 = blockSizeHorizontal * 6.55;
  static final double kSize32 = blockSizeHorizontal * 7.5;
  static final double kSize40 = blockSizeHorizontal * 9.35;

  //new size
  static final double kSize44 = blockSizeHorizontal * 10.3;
  static final double kSize48 = blockSizeHorizontal * 11.2;
  static final double kSize50 = blockSizeHorizontal * 11.6;
  static final double kSize56 = blockSizeHorizontal * 13.0;
  static final double kSize60 = blockSizeHorizontal * 14.0;
  static final double kSize64 = blockSizeHorizontal * 15.0;
  static final double kSize72 = blockSizeHorizontal * 17.0;
  static final double kSize80 = blockSizeHorizontal * 19.0;
  static final double kSize100 = blockSizeHorizontal * 23.5;
}

//Colors
const Color kBackground = Color(0xFFf9fbfc);
const Color kGrey = Color(0xFF7A8089);
const Color kLightGrey = Color(0XFFF0F1F2);

const Color kWhite = Color(0xFFFFFFFF);
const Color kBlack = Color(0xFF202124);
const Color kNiggaBlack = Color(0xFF0D0D0D);

const Color kNeutral10 = Color(0xFFFFFFFF);
const Color kNeutral20 = Color(0xFFF6F7F7);
const Color kNeutral30 = Color(0xFFF0F1F2);
const Color kNeutral40 = Color(0xFFE5E6E8);
const Color kNeutral50 = Color(0xFFCCCED1);
const Color kNeutral60 = Color(0xFFAEB1B7);
const Color kNeutral70 = Color(0xFF8391A1);
const Color kNeutral80 = Color(0xFF7A8089);
const Color kNeutral90 = Color(0xFF5F6570);
const Color kNeutral100 = Color(0xFF293241);

const Color kOrange = Color(0xFFF06821);
const Color kOrangeAccent500 = Color(0xFFF17737);
const Color kOrangeAccent400 = Color(0xFFF3864D);
const Color kOrangeAccent300 = Color(0xFFF49563);
const Color kYellow = Color(0xFFFFAC30);
const Color kGreen = Color(0xFF4AAF57);
const Color kGreenComplete = Color(0xFF18C07A);
const Color kRed = Color(0xFFE53935);
