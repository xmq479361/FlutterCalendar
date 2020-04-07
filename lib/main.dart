import 'package:flutter/material.dart';
import 'router.dart';


int main(){
  runApp(MaterialApp(
    onGenerateRoute: generateRoute,
    initialRoute: "/",
    theme: ThemeData(

    ),
    title: "Scroll Demo",
  ));
}

