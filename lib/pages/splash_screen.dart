import 'dart:async';

import 'package:flutter/material.dart';

import '../constant/app_constant.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 1), () {

        Navigator.pushReplacementNamed(context, AppConstant.search);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.colourteal,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(

          child: Text('Splash Screen'),

        ),
      ),
    );
  }
}
