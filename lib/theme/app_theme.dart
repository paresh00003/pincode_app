
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//return ThemeData to manage Theme in app

ThemeData appTheme (BuildContext context){


  return ThemeData(

    appBarTheme: AppBarTheme(

      color: Colors.red.shade400,

      iconTheme: IconThemeData(
        color: Colors.white
      ),

      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24
      )

    )


  );

}