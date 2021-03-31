import 'package:flutter/material.dart';


class Dimensions {
  static late double _width;
  static late double _height;
  static Orientation? _orientation;

  static callAtBuild({required BuildContext context}){
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _orientation = MediaQuery.of(context).orientation;
  }
  static _getDesirableWidthX(double percent) {
    return _width * (percent / 150);
  }

  static isPortrait() {
    return _orientation == Orientation.portrait;
  }
  static isLandScape() {
    return _orientation != Orientation.portrait;
  }

  static _getDesirableHeightX(double percent) {
    return _height * (percent / 150);
  }

  static getWidth(double percent,{double? web}) {
    return _orientation == Orientation.portrait
        ? _width * (percent / 100)
        : _getDesirableHeightX(web??percent);
  }

  static getHeight(double percent,{double? web}) {
    return _orientation == Orientation.portrait
        ? _height * (percent / 100)
        : _getDesirableWidthX(web??percent);
  }
}
