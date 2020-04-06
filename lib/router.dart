import 'package:flutter/material.dart';
import 'pages/home/home.dart';

final Map<String, WidgetBuilder> _routes = {
  "/": (context)=> HomePage(),
};
Route<dynamic> _generateRoute(RouteSettings settings){
  final String name = settings.name;
  final Function pageBuilder = _routes[name];
  if (pageBuilder != null) {
    if (settings.arguments != null) {
      // 如果透传了参数
      return MaterialPageRoute(
          builder: (context) =>
              pageBuilder(context, arguments: settings.arguments));
    } else {
      // 没有透传参数
      return MaterialPageRoute(builder: (context) => pageBuilder(context));
    }
  }
  return MaterialPageRoute(builder: (context) => HomePage());
}

const RouteFactory generateRoute  = _generateRoute;