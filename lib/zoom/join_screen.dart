import 'dart:async';
import 'dart:io';

import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../common/apidata.dart';
import '../common/theme.dart' as T;

class JoinWidget extends StatefulWidget {
  JoinWidget({this.meetingId, this.url});
  String meetingId;
  String url;
  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    meetingIdController.text = widget.meetingId;
    return Scaffold(
      appBar: customAppBar(context, translate("Join_Meeting")),
      backgroundColor: mode.backgroundColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  readOnly: true,
                  obscureText: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: meetingIdController,
                  decoration: InputDecoration(
                    labelText: translate("Meeting_ID"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: meetingPasswordController,
                  decoration: InputDecoration(
                    labelText: translate("Meeting_Password"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mode.easternBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        onPressed: () async {
                          if (meetingPasswordController.text.isNotEmpty) {
                            joinMeeting(context);
                          } else {
                            await Fluttertoast.showToast(
                              msg: translate("Please_enter_Meeting_Password"),
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                        },
                        child: Text(
                          translate("Join_Meeting"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Timer timer;

  joinMeeting(BuildContext context) {
    var user = Provider.of<UserProfile>(context, listen: false);
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }

      return result;
    }

    if (meetingIdController.text.isNotEmpty && meetingPasswordController.text.isNotEmpty) {
      ZoomOptions zoomOptions = ZoomOptions(
        domain: "zoom.us",
        appKey: APIData.zoomAppKey, //API KEY FROM ZOOM
        appSecret: APIData.zoomSecretKey, //API SECRET FROM ZOOM
      );
      var meetingOptions = ZoomMeetingOptions(
          userId: "${user.profileInstance.fname} ${user.profileInstance.lname}",

          /// pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: meetingIdController.text,

          /// pass meeting id for join meeting only
          meetingPassword: meetingPasswordController.text,

          /// pass meeting password for join meeting only
          disableDialIn: "true",
          disableDrive: "true",
          disableInvite: "true",
          disableShare: "true",
          disableTitlebar: "false",
          viewOptions: "true",
          noAudio: "false",
          noDisconnectAudio: "false");

      var zoom = ZoomView();

      zoom.initZoom(zoomOptions).then((results) {
        print(results);
        if (results[0] == 0) {
          zoom.onMeetingStatus().listen((status) {
            if (kDebugMode) {
              print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            }
            if (_isMeetingEnded(status[0])) {
              if (kDebugMode) {
                print("[Meeting Status] :- Ended");
              }
              timer.cancel();
            }
          });
          if (kDebugMode) {
            print("listen on event channel");
          }
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            print(joinMeetingResult);
            timer = Timer.periodic(const Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId).then((status) {
                if (kDebugMode) {
                  print("[Meeting Status Polling] : " + status[0] + " - " + status[1]);
                }
              });
            });
          });
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("[Error Generated] : " + error);
        }
      });
    } else {
      if (meetingIdController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      } else if (meetingPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }
  }
}
