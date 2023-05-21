// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/app_logo.dart';
import 'home_screen.dart';

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
  late ValueNotifier valueNotifier;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int daysDiff = 0;
  int hoursDiff = 0;
  int minutesDiff = 0;
  int secondsDiff = 0;
  void getDataFromFirestore() async {
    QuerySnapshot querySnapshot = await _firestore.collection('AppInfo').get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      String dateString = data['date'];
      String timeString = data['time'];
      convertToDaysHoursMinutesSeconds(dateString, timeString);
    }
  }

  convertToDaysHoursMinutesSeconds(String dateString, String timeString) {
    List<String> dateParts = dateString.split('/');
    List<String> timeParts = timeString.split(':');
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    if (timeString.contains('AM') || timeString.contains('am')) {
      hours = int.parse(timeParts[0]);
    } else {
      hours = int.parse(timeParts[0]) + 12;
    }
    minutes = int.parse(timeParts[1].split(' ')[0]);
    seconds = 0;
    DateTime dateTime = DateTime(year, month, day, hours, minutes, seconds);
    DateTime now = DateTime.now();
    print(now);
    Duration difference = dateTime.difference(now);
    daysDiff = difference.isNegative ? 0 : difference.inDays;
    hoursDiff = difference.isNegative ? 0 : difference.inHours % 24;
    minutesDiff = difference.isNegative ? 0 : difference.inMinutes % 60;
    secondsDiff = difference.isNegative ? 0 : difference.inSeconds % 60;
    difference.isNegative
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomeScreen(),
            ),
          )
        : {};
    setState(() {});

    countdownDuration = Duration(
        days: daysDiff,
        hours: hoursDiff,
        minutes: minutesDiff,
        seconds: secondsDiff);
    startTimer();
    reset();
  }

  @override
  void initState() {
    getDataFromFirestore();

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
                      top: MediaQuery.of(context).size.height * 0.13,
                      left: MediaQuery.of(context).size.height * 0.03,
                      bottom: 0,
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: buildTime())),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: CircularProgressIndicator(
                    value: calculateProgress().clamp(0,
                        1), // Change this value to set the progress percentage
                    strokeWidth: 25,

                    valueColor: const AlwaysStoppedAnimation(
                      APP_PRIMARY_COLOR,
                    ),
                    backgroundColor: Colors.grey.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: CircularProgressIndicator(
                    value: calculateProgress().clamp(0,
                        1), // Change this value to set the progress percentage

                    strokeWidth: 5,

                    valueColor: const AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                ),
              ]),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),

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
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
                child: Image.asset("assets/images/lock.png"),
              )
            ]),
      ),
    );
  }

  double calculateProgress() {
    if (countdownDuration.inSeconds == 0) {
      return 0;
    }
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
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds - addSeconds;
        if (seconds <= 0) {
          timer?.cancel();
          duration = const Duration();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomeScreen(),
            ),
          );
          timer?.cancel(); // Cancel the timer when countdown reaches zero
        } else {
          duration = Duration(seconds: seconds);
          print(seconds);
        }
      });
    }
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: days, header: "Days"),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.01,
      ),
      buildTimeCard(time: hours, header: 'Hours'),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.01,
      ),
      buildTimeCard(time: minutes, header: 'Minutes'),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.01,
      ),
      buildTimeCard(time: seconds, header: 'Seconds'),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.01,
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
                color: Color.fromRGBO(104, 104, 104, 1), fontSize: 32),
          ),
          Text(header, style: const TextStyle(color: Colors.black45)),
        ],
      );
}
