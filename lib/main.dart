import 'package:flutter/material.dart';
import 'package:flutter_scroll/router.dart';


int main(){
  runApp(MaterialApp(
    onGenerateRoute: generateRoute,
    initialRoute: "/",
    theme: ThemeData(

    ),
    title: "Scroll Demo",
  ));
}

