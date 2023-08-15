import 'package:Mingledxb/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

// ignore: must_be_immutable
class EventsTab extends StatefulWidget {
 
  final Map<String, dynamic> latestEventDetailsDisplay;

  const EventsTab({Key? key, required this.latestEventDetailsDisplay}) : super(key: key);

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            eventCard(context: context, eventDetails: widget.latestEventDetailsDisplay),
          ],
        ));
  }
}

Widget eventCard({
  required BuildContext context,
  required Map<String, dynamic> eventDetails,
}) {
  return Stack(
    children: [
      Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.1,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        // height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/app_logo.png",
                            scale: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Mingle DXB",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'DATE',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            // height: 10 / 11,
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          eventDetails["eventDate"] ?? "",
                          // textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            // height: 17 / 14,
                            letterSpacing: 0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: APP_ACCENT_COLOR,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FutureBuilder(
                      future:
                          precacheImage(NetworkImage(eventDetails["eventImage"] ?? ""), context),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Image.network(
                            eventDetails["eventImage"] ?? "",
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              )

              // Container(
              //   height: 150,
              //   width: double.infinity,
              //   margin: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //           image: NetworkImage(eventDetails["eventImage"] ?? ""),
              //           fit: BoxFit.cover),
              //       color: APP_ACCENT_COLOR,
              //       borderRadius: BorderRadius.circular(5)),
              //   // child: const Center(child: Text("Event Image")),
              // ),
              ,
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EVENT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        // height: 10 / 11,
                        letterSpacing: 0,
                      ),
                    ),
                    // event details
                    Text(
                      eventDetails["eventName"] ?? '',
                      // textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        // height: 17 / 14,
                        letterSpacing: 0,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LOCATION',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            // height: 10 / 11,
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          eventDetails['eventLocation'] ?? "",
                          // textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            // height: 17 / 14,
                            letterSpacing: 0,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'START',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            // height: 10 / 11,
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          eventDetails["eventStartTime"] ?? "",
                          // textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            // height: 17 / 14,
                            letterSpacing: 0,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FINISH',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            // height: 10 / 11,
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          eventDetails["eventEndTime"] ?? "",
                          // textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            // height: 17 / 14,
                            letterSpacing: 0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 125 / 375,
              //   height: MediaQuery.of(context).size.height * 125 / 812,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: NetworkImage(eventDetails["eventQrCode"] ?? ""),
              //       fit: BoxFit.cover,
              //     ),
              //     color: APP_ACCENT_COLOR,
              //     borderRadius: BorderRadius.circular(5),
              //   ),
              //   // child: const Center(child: Text("Qr image")),
              // ),
              Container(
                width: MediaQuery.of(context).size.width * 125 / 375,
                height: MediaQuery.of(context).size.height * 125 / 812,
                decoration: BoxDecoration(
                  color: APP_ACCENT_COLOR,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FutureBuilder(
                  future:
                      eventDetails["eventQrCode"] != null && eventDetails["eventQrCode"].isNotEmpty
                          ? precacheImage(NetworkImage(eventDetails["eventQrCode"]!), context)
                          : Future.value(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (eventDetails["eventQrCode"] != null &&
                          eventDetails["eventQrCode"].isNotEmpty) {
                        return Image.network(
                          eventDetails["eventQrCode"]!,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const Center(child: Text('No QR Code URL available'));
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.black, borderRadius: BorderRadius.circular(5)),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          // color: APP_ACCENT_COLOR,
                          borderRadius: BorderRadius.circular(5)),
                      child: const SvgIcon(
                        "assets/icons/wifi.svg",
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )

              // Image.network('qr_code_url'),
            ],
          ),
        ),
      ),
      Positioned(
        left: MediaQuery.of(context).size.width * 0.45,
        top: MediaQuery.of(context).size.height * 0.0001,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
        ),
      )
    ],
  );
}
