import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pincode_app/routing/app_route.dart';
import 'package:pincode_app/theme/app_theme.dart';

import 'constant/app_constant.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBHJR3n6853lwsNPilYH40AyBYj_pmaIDQ",
          appId: "1:1001584112285:android:9de9a75392f26686569a74",
          messagingSenderId: "1001584112285",
          projectId: "pincode-app-4c662",
          storageBucket: "pincode-app-4c662.appspot.com"));
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: AppConstant.splashView,
        debugShowCheckedModeBanner: false,

        theme: appTheme(context),

        onGenerateRoute: AppRoute.generateRoute
    );
  }
}
