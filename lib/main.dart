import 'package:buscador_de_gifs/ui/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: const HomePage(),
    theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)),
  ));
}
