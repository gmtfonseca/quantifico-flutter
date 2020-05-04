import 'package:flutter/material.dart';
import 'package:quantifico/config.dart';

class FullScreenChart extends StatelessWidget {
  final String title;
  final Widget child;

  FullScreenChart({
    Key key,
    this.title,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
