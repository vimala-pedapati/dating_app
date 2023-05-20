import 'package:Mingledxb/constants/constants.dart';
import 'package:Mingledxb/screens/sign_up_custome_design_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/app_logo.dart';

class WelcomeScreenMingle extends StatefulWidget {
  const WelcomeScreenMingle({Key? key}) : super(key: key);

  @override
  _WelcomeScreenMingleState createState() => _WelcomeScreenMingleState();
}

class _WelcomeScreenMingleState extends State<WelcomeScreenMingle> {
  // Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Color> _colors = [
    APP_ACCENT_COLOR,
    APP_PRIMARY_COLOR,
  ];

  @override
  Widget build(BuildContext context) {
    /// Initialization

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: _colors,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const [0.4, 0.7],
          tileMode: TileMode.repeated,
        )
            // image: DecorationImage(
            //     image: AssetImage("assets/images/background_image.jpg"),
            //     fit: BoxFit.cover,
            //     repeat: ImageRepeat.noRepeat),
            ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: _colors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const [0.4, 0.7],
            tileMode: TileMode.repeated,
          )
              // image: DecorationImage(
              //     image: AssetImage("assets/images/background_image.jpg"),
              //     fit: BoxFit.cover,
              //     repeat: ImageRepeat.noRepeat),
              ),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              /// App logo
              const SizedBox(height: 250, width: 200, child: AppLogo()),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              /// App name
              // const Text(APP_NAME,
              //     style: TextStyle(
              //         fontSize: 22,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white)),

              const Text("Get ready to Mingle! ",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              // Text(_i18n.translate("welcome_back"),
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 18, color: Colors.white)),

              // const SizedBox(height: 10),

              // Text(_i18n.translate("app_short_description"),
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 18, color: Colors.white)),

              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const SignUpScreenCostom()));
                },
                child: Container(
                  //width: 100.0,
                  height: 50.0,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),

              /// Sign in with Phone Number
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   child: SizedBox(
              //     width: double.maxFinite,
              //     child: DefaultButton(
              //       child: Text(_i18n.translate("sign_in_with_phone_number"),
              //           style: const TextStyle(fontSize: 18)),
              //       onPressed: () {
              //         /// Go to phone number screen
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (context) => const PhoneNumberScreen()));
              //       },
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),

              // Terms of Service section
              // Text(
              //   _i18n.translate("by_tapping_log_in_you_agree_with_our"),
              //   style: const TextStyle(
              //       color: Colors.white, fontWeight: FontWeight.bold),
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(
              //   height: 7,
              // ),
              // TermsOfServiceRow(),

              // const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
