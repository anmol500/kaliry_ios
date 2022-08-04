import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Avatar extends StatefulWidget {
  const Avatar({Key key, this.url}) : super(key: key);
  final url;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> with TickerProviderStateMixin {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      margin: EdgeInsets.only(top: 2.0),
      alignment: Alignment.topLeft,
      child: CachedNetworkImage(
        imageUrl: widget.url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Lottie.asset(
          'assets/avatarLottie.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..repeat();
          },
        ),
        errorWidget: (context, url, error) => Lottie.asset(
          'assets/avatarLottie.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..repeat();
          },
        ),
      ),
    );
  }
}
