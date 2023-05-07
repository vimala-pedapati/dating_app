import 'dart:io';

import 'package:Mingledxb/screens/blocked_account_screen.dart';
import 'package:Mingledxb/screens/update_location_sceen.dart';
import 'package:Mingledxb/screens/welcome_to_mingle_screen.dart';
import 'package:flutter/material.dart';
import 'package:Mingledxb/constants/constants.dart';
import 'package:Mingledxb/helpers/app_localizations.dart';
import 'package:Mingledxb/helpers/app_helper.dart';
import 'package:Mingledxb/screens/update_app_screen.dart';
import 'package:Mingledxb/models/user_model.dart';
import 'package:Mingledxb/screens/home_screen.dart';
import 'package:Mingledxb/screens/sign_up_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variables
  final AppHelper _appHelper = AppHelper();
  late AppLocalizations _i18n;
  final List<Color> _colors = [
    APP_ACCENT_COLOR,
    APP_PRIMARY_COLOR,
  ];
  final List<double> _stops = [0.0, 0.7];

  /// Navigate to next page
  void _nextScreen(screen) {
    // Go to next page route
    Future(() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => screen), (route) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    _appHelper.getAppStoreVersion().then((storeVersion) async {
      debugPrint('storeVersion: $storeVersion');

      // Get hard coded App current version
      int appCurrentVersion = 1;
      // Check Platform
      if (Platform.isAndroid) {
        // Get Android version number
        appCurrentVersion = ANDROID_APP_VERSION_NUMBER;
      } else if (Platform.isIOS) {
        // Get iOS version number
        appCurrentVersion = IOS_APP_VERSION_NUMBER;
      }

      /// Compare both versions
      if (storeVersion > appCurrentVersion) {
        /// Go to update app screen
        _nextScreen(const UpdateAppScreen());
        debugPrint("Go to update screen");
      } else {
        /// Authenticate User Account
        UserModel().authUserAccount(
            updateLocationScreen: () =>
                _nextScreen(const UpdateLocationScreen()),
            signInScreen: () => _nextScreen(const WelcomeScreenMingle()),
            signUpScreen: () => _nextScreen(const SignUpScreen()),
            homeScreen: () => _nextScreen(const HomeScreen()),
            blockedScreen: () => _nextScreen(const BlockedAccountScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _i18n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: _colors,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const [0.4, 0.7],
                    tileMode: TileMode.repeated,
                  )),
                  child: Image.asset("assets/icons/logo_name_png.png")),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     const AppLogo(),
              //     const SizedBox(height: 10),
              //     const Text(APP_NAME,
              //         style:
              //             TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              //     const SizedBox(height: 5),
              //     Text(_i18n.translate("app_short_description"),
              //         textAlign: TextAlign.center,
              //         style: const TextStyle(fontSize: 18, color: Colors.grey)),
              //     const SizedBox(height: 20),
              //     const MyCircularProgress()
              //   ],
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
