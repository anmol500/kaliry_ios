import 'package:eclass/Widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class EmptyVideosPage extends StatelessWidget {
  Widget showImage() {
    return Center(
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(),
        child: Image.asset("assets/images/emptycourses.png"),
      ),
    );
  }

  Widget showDetails() {
    return Container(
      height: 75,
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translate("No_videos_to_show"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Container(
            width: 200,
            child: Text(
              translate("Looks_like_your_admin_havent_add_videos_in_here"),
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(mode.bgcolor, context, scaffoldKey),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 40),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showImage(),
              showDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
