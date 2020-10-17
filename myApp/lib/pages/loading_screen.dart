import 'package:flutter/material.dart';

Widget loadingScreen() {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/loading.gif'),
          fit: BoxFit.contain,
        )),
  );
}

Widget loadingScreen2() {
  return Container(
      child: Center(
    child: const CircularProgressIndicator(),
  ));
}
