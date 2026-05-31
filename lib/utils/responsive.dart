import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1200;
  
  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;
  
  static double getContentWidth(BuildContext context) {
    final w = width(context);
    if (w >= 1200) return 500;
    if (w >= 600) return 500;
    return w - 48;
  }
  
  static double getFontSize(BuildContext context, double mobile, {double? tablet, double? desktop}) {
    final w = width(context);
    if (w >= 1200) return desktop ?? tablet ?? mobile;
    if (w >= 600) return tablet ?? mobile;
    return mobile;
  }
}
