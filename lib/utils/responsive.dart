import 'package:flutter/material.dart';

import 'dimensions.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    Key? key,
    @required this.mobile,
    @required this.tablet,
    @required this.desktop,
  }) : super(key: key);

  // This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop help us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isTablet() => Dimensions.width() < 1100 && Dimensions.width() >= 650;

  static bool isDesktop() => Dimensions.width() >= 1100;

  static width(BuildContext context,double percent) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }
  static height(BuildContext context,double percent) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than 1100 then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop!;
        }
        // If width it less then 1100 and more then 650 we consider it as tablet
        else if (constraints.maxWidth >= 650) {
          return tablet!;
        }
        // Or less then that we called it mobile
        else {
          return mobile!;
        }
      },
    );
  }
}