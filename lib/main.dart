import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: AnimatedBackground(),
            ),
            onBottom(AnimatedWave(
              height: 280,
              speed: 1.0,
            )),
            onBottom(AnimatedWave(
              height: 220,
              speed: 0.9,
              offset: pi,
            )),
            onBottom(AnimatedWave(
              height: 220,
              speed: 1.2,
              offset: pi / 2,
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('images/me.jpg')),
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    'Dhanush Krishnan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'BalooThambi2'),
                  ),
                  width: 250,
                  height: 40,
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(
                    'Flutter Developer',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontStyle: FontStyle.italic),
                  ),
                  width: 250,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.message),
                    title: Text(
                      'http://t.me/Ded_Boi',
                      style: TextStyle(fontFamily: 'OpenSans'),
                    ),
                    onTap: () => launch('http://t.me/Ded_Boi'),
                  ),
                ),
                Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(Icons.email),
                      title: Text('dhanush911gtr@gmail.com',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                          )),
                      onTap: () => launch('mailto:dhanush911gtr@gmail.com'),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedWave extends StatelessWidget {
  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  final double height;
  final double offset;
  final double speed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  CurvePainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}
