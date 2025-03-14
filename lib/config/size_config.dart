import 'package:flutter/material.dart';

class SizeConfig {
  static const double DESIGN_WIDTH = 375.0;
  static const double DESIGN_HEIGHT = 812.0;

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double pixelRatio;
  static late Orientation orientation;
  static late bool isTablet = false;
  static late bool isDarkMode = false;

  static final Map<int, double> _widthPercentages = {};
  static final Map<int, double> _heightPercentages = {};

  static void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    pixelRatio = _mediaQueryData.devicePixelRatio;
    isDarkMode = _mediaQueryData.platformBrightness == Brightness.dark;

    print("screenWidth : $screenWidth");
    print("screenHeight : $screenHeight");
    print("orientation : $orientation");
    print("pixelRatio : $pixelRatio");
    print("isDarkMode : $isDarkMode");
  }

  // Calcul une largeur proportionelle. Converti une largeur du design de reference en une largeur adapt2 a l'ecran actuel en concervant les proportion
  static double getProportinateScreenWidth(double inputWidth) {
    return (inputWidth / DESIGN_WIDTH) * screenWidth;
  }

  // Calcul une largeur proportionelle. Converti une largeur du design de reference en une largeur adapt2 a l'ecran actuel en concervant les proportion
  static double getProportinateScreenheight(double inputHeight) {
    return (inputHeight / DESIGN_WIDTH) * screenHeight;
  }
}