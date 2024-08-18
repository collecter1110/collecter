import 'package:flutter/widgets.dart';

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double ViewPaddingTopSize(BuildContext context) {
  return MediaQuery.of(context).viewPadding.top;
}

double ViewPaddingBottomSize(BuildContext context) {
  return MediaQuery.of(context).viewPadding.bottom;
}

double bottomNavigationBarHeight(BuildContext context) {
  return 80.0;
}
