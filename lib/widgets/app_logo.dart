import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  // Variable
  final double? width;
  final double? height;

  const AppLogo({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Container(
        child: Image.asset("assets/icons/logo_name_png.png"),
      ),
    );
    // return const CircleAvatar(
    //   backgroundImage: AssetImage('assets/icons/logo_name_png.png'),
    //   radius: 120,
    // );
    // return CircleAvatar(
    //   child: Image.asset("assets/images/app_logo.png",
    //       width: width ?? 120, height: height ?? 120),
    // );
  }
}
