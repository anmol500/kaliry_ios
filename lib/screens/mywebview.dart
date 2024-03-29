import 'package:eclass/Widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class MyWebView extends StatefulWidget {
  MyWebView({this.title, this.url});

  final String url;
  final String title;

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate(widget.title)),
      body: Container(),
    );
  }
}
