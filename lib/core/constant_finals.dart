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

  //new
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
