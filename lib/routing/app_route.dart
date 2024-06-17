import 'package:flutter/material.dart';

import 'package:pincode_app/pages/splash_screen.dart';

import '../constant/app_constant.dart';
import '../pages/main_ui_search_page/search_page.dart';


class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {


    switch (settings.name) {

      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );

      case AppConstant.search:
        return MaterialPageRoute(
          builder: (context) => SearchScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
