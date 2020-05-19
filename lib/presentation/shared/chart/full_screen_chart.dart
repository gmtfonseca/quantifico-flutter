import 'package:flutter/material.dart';
import 'package:quantifico/config.dart';

class FullScreenChart extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final Widget child;

  const FullScreenChart({
    Key key,
    this.title,
    this.appBarColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: SizeConfig.safeBlockVertical * 100,
            child: child,
          ),
        ),
      ),
    );
  }
}
