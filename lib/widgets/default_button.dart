import 'package:flutter/material.dart';

import '../constants/constants.dart';

class DefaultButton extends StatelessWidget {
  // Variables
  final Widget child;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const DefaultButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

        // SizedBox(
        //   width: width,
        //   height: height ?? 45,
        //   child: ElevatedButton(

        //     child: child,
        //     style: ButtonStyle(

        //         backgroundColor: MaterialStateProperty.all<Color>(
        //             Theme.of(context).primaryColor),
        //         textStyle: MaterialStateProperty.all<TextStyle>(
        //             const TextStyle(color: Colors.white)),
        //         shape: MaterialStateProperty.all<OutlinedBorder>(
        //             RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(28),
        //         ))),
        //     onPressed: onPressed,
        //   ),
        // );

        Container(
      decoration: BoxDecoration(
        boxShadow: const [
          // BoxShadow(
          //     color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient: const LinearGradient(
          begin: Alignment(-1.0, -1),
          end: Alignment(-1.0, 1),
          // begin: Alignment.centerLeft,
          // end: Alignment.centerRight,
          stops: [0.0, 1.0],
          colors: [
            APP_PRIMARY_COLOR,
            APP_ACCENT_COLOR,
          ],
        ),
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size(width ?? 100, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          // elevation: MaterialStateProperty.all(3),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: child),
      ),
    );
  }
}
