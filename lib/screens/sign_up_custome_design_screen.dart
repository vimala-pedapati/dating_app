import 'package:dating_app/screens/phone_number_screen.dart';
import 'package:flutter/material.dart';

import '../helpers/app_localizations.dart';
import '../widgets/app_logo.dart';
import '../widgets/default_button.dart';
import '../widgets/terms_of_service_row.dart';

class SignUpScreenCostom extends StatefulWidget {
  const SignUpScreenCostom({Key? key}) : super(key: key);

  @override
  State<SignUpScreenCostom> createState() => _SignUpScreenCostomState();
}

class _SignUpScreenCostomState extends State<SignUpScreenCostom> {
  late AppLocalizations _i18n;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    /// Initialization
    _i18n = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("assets/images/background_image.jpg"),
            //     fit: BoxFit.cover,
            //     repeat: ImageRepeat.noRepeat),
            ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              /// App logo
              const SizedBox(height: 250, width: 200, child: AppLogo()),
              const SizedBox(height: 10),

              /// App name
              // const Text(APP_NAME,
              //     style: TextStyle(
              //         fontSize: 22,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white)),

              const Text("Sign up to continue ",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.black)),
              const SizedBox(height: 10),

              // Text(_i18n.translate("welcome_back"),
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 18, color: Colors.white)),

              // const SizedBox(height: 10),

              // Text(_i18n.translate("app_short_description"),
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 18, color: Colors.white)),

              // const SizedBox(height: 50),
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
                    color: Colors.white60,
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
                    color: Colors.white60,
                    border: Border.all(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
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
                    color: Colors.white60,
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
              // Sign in with Phone Number
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.maxFinite,
                  child: DefaultButton(
                    child: Text(_i18n.translate("sign_in_with_phone_number"),
                        style: const TextStyle(fontSize: 18)),
                    onPressed: () {
                      /// Go to phone number screen
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PhoneNumberScreen()));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              //Terms of Service section
              Text(
                _i18n.translate("by_tapping_log_in_you_agree_with_our"),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 7,
              ),
              TermsOfServiceRow(),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
