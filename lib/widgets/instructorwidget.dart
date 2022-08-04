import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../common/apidata.dart';
import '../model/instructor_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/theme.dart' as T;
import 'Avartar.dart';

class InstructorWidget extends StatefulWidget {
  final Instructor details;

  InstructorWidget(this.details);

  @override
  State<InstructorWidget> createState() => _InstructorWidgetState();
}

class _InstructorWidgetState extends State<InstructorWidget> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Widget showDetails(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                widget.details.user.fname + " " + widget.details.user.lname,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: mode.titleTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/InstructorScreen', arguments: widget.details);
                    },
                    child: Text(
                      translate("View_More"),
                      style: TextStyle(
                        color: mode.titleTextColor.withOpacity(0.6),
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.user,
              size: 16.0,
              color: Color(0xff404455),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(widget.details.enrolledUser.toString() + " ${translate("Students_")}", style: TextStyle(color: Color(0xff8A8C99), fontSize: 16.0))
          ],
        ),
        SizedBox(
          height: 2.0,
        ),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.playCircle,
              size: 16.0,
              color: Color(0xff404455),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(widget.details.courseCount.toString() + " ${translate("Courses_")}", style: TextStyle(color: Color(0xff8A8C99), fontSize: 16.0))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Avatar(url: "${APIData.userImage}${widget.details.user.userImg}"),
          ),
          SizedBox(
            width: 7.0,
          ),
          Expanded(flex: 5, child: showDetails(context)),
        ],
      ),
    );
  }
}
