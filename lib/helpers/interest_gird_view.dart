// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/user_model.dart';

class CustomGridView extends StatefulWidget {
  const CustomGridView({
    super.key,
  });

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  getUserInterestBackend() async {
    List<String> interests = await UserModel().getUserInterest();

    setState(() {
      SelectedInterestList = interests;
    });
  }

  List<Map<String, String>> interestsData = [
    {
      'name': 'Photography',
      'icon': 'assets/interest/photography.png',
    },
    {
      'name': 'Karaoke',
      'icon': 'assets/interest/karaoke.png',
    },
    {
      'name': 'Shopping',
      'icon': 'assets/interest/shopping.png',
    },
    {
      'name': 'Yoga',
      'icon': 'assets/interest/yoga.png',
    },
    {
      'name': 'Cooking',
      'icon': 'assets/interest/cooking.png',
    },
    {
      'name': 'Tennis',
      'icon': 'assets/interest/tennis.png',
    },
    {
      'name': 'Run',
      'icon': 'assets/interest/run.png',
    },
    {
      'name': 'Swimming',
      'icon': 'assets/interest/swimming.png',
    },
    {
      'name': 'Art',
      'icon': 'assets/interest/art.png',
    },
    {
      'name': 'Traveling',
      'icon': 'assets/interest/travelling.png',
    },
    {
      'name': 'Extreme',
      'icon': 'assets/interest/extreme.png',
    },
    {
      'name': 'Music',
      'icon': 'assets/interest/music.png',
    },
    {
      'name': 'Drink',
      'icon': 'assets/interest/drink.png',
    },
  ];

  // ignore: non_constant_identifier_names
  List<String> SelectedInterestList = [];
  @override
  void initState() {
    super.initState();
    getUserInterestBackend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 5 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20),
            itemCount: interestsData.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: () {
                  if (SelectedInterestList.contains(
                      interestsData[index]['name'])) {
                    SelectedInterestList.remove(interestsData[index]['name']);
                  } else {
                    SelectedInterestList.add(interestsData[index]['name']!);
                  }
                  UserModel().userInterest(
                    userInterests: SelectedInterestList,
                    onSuccess: () async {
                      print('Interested updated');
                    },
                    onFail: (error) {
                      print("interest error $error");
                    },
                  );

                  setState(() {});
                },
                child: SelectedInterestList.contains(
                        interestsData[index]['name'])
                    ? Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffDDDDDD),
                              blurRadius: 10.0,
                              spreadRadius: 4.0,
                              offset: Offset(0.0, 0.0),
                            )
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF589DC6),
                              Color(0xFFF4B3B7),
                            ],
                          ),
                          color: const Color(0xFFFFFFFF),
                          border: Border.all(
                            color: const Color(0xFFE8E6EA),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                child:
                                    Image.asset(interestsData[index]['icon']!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                interestsData[index]['name']!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        )),
                      )
                    : Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFFFFFFF),
                            ],
                          ),
                          color: const Color(0xFFFFFFFF),
                          border: Border.all(
                            color: const Color(0xFFE8E6EA),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  APP_PRIMARY_COLOR,
                                  BlendMode.srcIn,
                                ),
                                child:
                                    Image.asset(interestsData[index]['icon']!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                interestsData[index]['name']!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        )),
                      ),
              );
            }),
      ),
    );
  }
}
