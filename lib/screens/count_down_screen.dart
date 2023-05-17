import 'dart:async';

import 'package:Mingledxb/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/app_logo.dart';

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({super.key});

  @override
  _CountDownScreenState createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  static var countdownDuration = const Duration();
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true;

  @override
  void initState() {
    int days = int.parse("00");
    int hours = int.parse("00");
    int mints = int.parse("01");
    int secs = int.parse("00");
    countdownDuration =
        Duration(days: days, hours: hours, minutes: mints, seconds: secs);
    startTimer();
    reset();
    super.initState();
  }

  var color = [
    Colors.red,
    Colors.blue,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),

              /// App logo
              const SizedBox(height: 250, width: 200, child: AppLogo()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              Stack(children: [
                Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      bottom: 0,
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: buildTime())),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: CircularProgressIndicator(
                    value:
                        double(), // Change this value to set the progress percentage
                    strokeWidth: 25,

                    valueColor: const AlwaysStoppedAnimation(
                      APP_PRIMARY_COLOR,
                    ),
                    backgroundColor: Colors.grey.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: CircularProgressIndicator(
                    value:
                        double(), // Change this value to set the progress percentage
                    strokeWidth: 5,

                    valueColor: const AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                ),
              ]),
              // Text(duration.inDays == 0 ? "Time is up" : "Time left"),
              // Text(duration.inHours == 0 ? "Time is up" : "Time left"),
              // Text(duration.inMinutes == 0 ? "Time is up" : "Time left"),
              // Text(duration.inSeconds == 0 ? "Time is up" : "Time left"),
              // Text(duration.toString()),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              // // Example 1
              // const SimpleCircularProgressBar(
              //   valueNotifier : double(),
              //   progressColors: [Colors.cyan],
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Text(
                  '''Counting down the days until we can Mingle! See you Wednesday ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                child: Image.asset("assets/images/lock.png"),
              )
            ]),
      ),
    );
  }

  double() {
    return duration.inSeconds / countdownDuration.inSeconds;
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime1());
  }

  void addTime1() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds - addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
        seconds == 0 ?     Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const SplashScreen(),
    ),
  ) : print(seconds);
      }
    });
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: days, header: "Days"),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      const SizedBox(
        width: 8,
      ),
      // buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
                color: Color.fromRGBO(104, 104, 104, 1), fontSize: 36),
          ),
          Text(header, style: const TextStyle(color: Colors.black45)),
        ],
      );
}
