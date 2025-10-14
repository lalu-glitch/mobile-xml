import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String baseURL = '${dotenv.env['BASE_URL']}';

final FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
final Size size = view.physicalSize / view.devicePixelRatio;

final double width = size.width;
final double height = size.height;

final double blockSizeHorizontal = width / 100;
final double blockSizeVertical = height / 100;

final double kSize2 = blockSizeHorizontal * 0.5;
final double kSize4 = blockSizeHorizontal * 1;
final double kSize8 = blockSizeHorizontal * 1.87;
final double kSize10 = blockSizeHorizontal * 2.35;
final double kSize11 = blockSizeHorizontal * 2.5;
final double kSize12 = blockSizeHorizontal * 2.85;
final double kSize14 = blockSizeHorizontal * 3.25;
final double kSize16 = blockSizeHorizontal * 3.75;
final double kSize18 = blockSizeHorizontal * 4.25;
final double kSize20 = blockSizeHorizontal * 4.675;
final double kSize24 = blockSizeHorizontal * 5.5;
final double kSize28 = blockSizeHorizontal * 6.55;
final double kSize32 = blockSizeHorizontal * 7.5;
final double kSize40 = blockSizeHorizontal * 9.35;

//new size
final double kSize44 = blockSizeHorizontal * 10.3;
final double kSize48 = blockSizeHorizontal * 11.2;
final double kSize50 = blockSizeHorizontal * 11.6;
final double kSize56 = blockSizeHorizontal * 13.0;
final double kSize60 = blockSizeHorizontal * 14.0;
final double kSize64 = blockSizeHorizontal * 15.0;
final double kSize72 = blockSizeHorizontal * 17.0;
final double kSize80 = blockSizeHorizontal * 19.0;
final double kSize100 = blockSizeHorizontal * 23.5;

//Colors

const Color kBackground = Color(0xFFF6F7F7);
const Color kGrey = Color(0xFF7A8089);
const Color kLightGrey = Color(0XFFF0F1F2);

const Color kWhite = Color(0xFFFFFFFF);
const Color kBlack = Color(0xFF202124);
const Color kSupaBlack = Color(0xFF0D0D0D);

const Color kNeutral30 = Color(0xFFF0F1F2);
const Color kNeutral40 = Color(0xFFE5E6E8);
const Color kNeutral50 = Color(0xFFCCCED1);
const Color kNeutral60 = Color(0xFFAEB1B7);
const Color kNeutral70 = Color(0xFF8391A1);
const Color kNeutral80 = Color(0xFF7A8089);
const Color kNeutral90 = Color(0xFF5F6570);
const Color kNeutral100 = Color(0xFF293241);

const Color kOrange = Color(0xFFFE7F04);
const Color kOrangeAccent500 = Color(0xFFF17737);
const Color kOrangeAccent400 = Color(0xFFF3864D);
const Color kOrangeAccent300 = Color(0xFFF49563);
const Color kYellow = Color(0xFFFFAC30);
const Color kGreen = Color(0xFF4AAF57);
const Color kGreenComplete = Color(0xFF18C07A);
const Color kRed = Color(0xFFE53935);
const Color kBlue = Color(0xFF1055C9);
