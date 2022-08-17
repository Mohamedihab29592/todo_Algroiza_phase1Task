
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);





class Constants {
  static final inputFormat = DateFormat('dd MMM, yyyy');
}

int createUniqueId() {
  int id = 0;
  id = id + 1;
  return id;
}





