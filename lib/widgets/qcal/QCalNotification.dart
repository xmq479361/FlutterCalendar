import 'package:flutter/material.dart';
import 'QCalHolder.dart';

class QCalNotification extends Notification {
  QCalHolder model;


  QCalNotification(this.model);


  static void dispatchTo(BuildContext context, QCalHolder model) {
    // QCalNotification(model).dispatch(context);
    dispatchFuture(context,model);
  }
  static Future dispatchFuture(BuildContext context, QCalHolder model) async {
    // Future.delayed(Duration(milliseconds: 20), (){
      QCalNotification(model).dispatch(context);
    // });
  }
}

