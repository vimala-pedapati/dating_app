import 'package:Mingledxb/screens/phone_number_screen.dart';
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
      backgroundColor: Colors.black,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                /// App logo
                const SizedBox(height: 250, width: 200, child: AppLogo()),

                const Text("Sign up to continue ",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black)),

                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).pushReplacement(
                //         MaterialPageRoute(builder: (context) => const SignUpScreenCostom()));
                //   },
                //   child: Container(
                //       //width: 100.0,
                //       height: 50.0,
                //       width: 200,
                //       decoration: BoxDecoration(
                //         color: Colors.white60,
                //         border: Border.all(color: Colors.white, width: 2.0),
                //         borderRadius: BorderRadius.circular(10.0),
                //       ),
                //       child: const Center(
                //         child: Text(
                //           'Sign In',
                //           style: TextStyle(fontSize: 18.0, color: Colors.white),
                //         ),
                //       )),
                // ),

//                 InkWell(
//                   onTap: () {
//                     Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) => const SignUpScreenCostom()));
//                   },
//                   child: Container(
//                     //width: 100.0,
//                     height: 70.0,
//                     width: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.white60,
//                       border: Border.all(color: Colors.white, width: 2.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Sign In',
//                         style: TextStyle(fontSize: 18.0, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),

                // Sign in with Phone Number
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: DefaultButton(
                      child: Text(_i18n.translate("Continue_with_email"),
                          style: const TextStyle(fontSize: 18)),
                      onPressed: () {
                        debugPrint("Continue with email tapped ");
                        customDialog(context, "Continue with email");

                        /// Go to phone number screen
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const PhoneNumberScreen()));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: DefaultButton(
                      child: Text(_i18n.translate("sign_in_with_phone_number"),
                          style: const TextStyle(fontSize: 18)),
                      onPressed: () {
                        debugPrint("Continue with email tapped ");
                        customDialog(context, "Continue with email");

                        // Go to phone number screen
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const PhoneNumberScreen()));
                      },
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     debugPrint("Use phone number tapped");
                //     Navigator.of(context)
                //         .push(MaterialPageRoute(builder: (context) => const PhoneNumberScreen()));
                //   },
                //   child: Container(
                //     //width: 100.0,
                //     height: 50.0,
                //     width: MediaQuery.of(context).size.width * 0.8,
                //     decoration: BoxDecoration(
                //       color: Colors.white60,
                //       border: Border.all(color: Colors.grey, width: 2.0),
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //     child: Center(
                //       child: Text(
                //         _i18n.translate("sign_in_with_phone_number"),
                //         style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(
                  height: 80,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 40.0, right: 40),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         height: 1,
                //         width: 100,
                //         color: Colors.grey,
                //       ),
                //       const Text(
                //         "or sign up \nwith",
                //         textAlign: TextAlign.center,
                //       ),
                //       Container(
                //         height: 1,
                //         width: 100,
                //         color: Colors.grey,
                //       )
                //     ],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     InkWell(
                //       onTap: (){
                //         customDialog(context, "Facebook");
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.white60,
                //           border: Border.all(color: Colors.grey, width: 2.0),
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         child: Padding(
                //             padding: const EdgeInsets.all(10),
                //             child: SvgPicture.asset(
                //               "assets/icons/facebook_icon.svg",
                //             )),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: () {
                //           customDialog(context, "Google");
                //         // google signin button
                //         // Authentication.signInWithGoogle(context: context);
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.white60,
                //           border: Border.all(color: Colors.grey, width: 2.0),
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         child: Padding(
                //             padding: const EdgeInsets.all(10),
                //             child: SvgPicture.asset(
                //               "assets/icons/google.svg",
                //             )),
                //       ),
                //     ),
                //     InkWell(
                //       onTap: (){
                //         customDialog(context, "Apple");
                //       },
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.white60,
                //           border: Border.all(color: Colors.grey, width: 2.0),
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         child: Padding(
                //             padding: const EdgeInsets.all(10),
                //             child: SvgPicture.asset(
                //               "assets/icons/apple.svg",
                //             )),
                //       ),
                //     )
                //   ],
                // ),

                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Terms of Service section
                    Text(
                      _i18n.translate("Terms_of_use"),
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 30,
                    ),

                    Text(
                      _i18n.translate("Privacy_Policy"),
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TermsOfServiceRow(),
// =======
                // Padding(
                //             padding: const EdgeInsets.all(10),
                //             child: SvgPicture.asset(
                //               "assets/icons/facebook_icon.svg",
                //              )),

                // InkWell(
                //   onTap: () {
                //     // google signin button
                //     Authentication.b(context: context);
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white60,
                //       border: Border.all(color: Colors.grey, width: 2.0),
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //     child: Padding(
                //         padding: const EdgeInsets.all(10),
                //         child: SvgPicture.asset(
                //           "assets/icons/google_icon_bw.svg",
                //         )),
                //   ),
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white60,
                //     border: Border.all(color: Colors.grey, width: 2.0),
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                //   child: Padding(
                //       padding: const EdgeInsets.all(10),
                //       child: SvgPicture.asset(
                //         "assets/icons/apple_icon_bw.svg",
                //       )),
                // ),

                const SizedBox(
                  height: 80,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     //Terms of Service section
                //     Text(
                //       _i18n.translate("Terms_of_use"),
                //       style: const TextStyle(
                //           color: Colors.grey, fontWeight: FontWeight.bold),
                //       textAlign: TextAlign.center,
                //     ),
                //     const SizedBox(
                //       width: 30,
                //     ),
                //     Text(
                //       _i18n.translate("Privacy_Policy"),
                //       style: const TextStyle(
                //           color: Colors.grey, fontWeight: FontWeight.bold),
                //       textAlign: TextAlign.center,
                //     ),
                //     const SizedBox(
                //       height: 7,
                //     ),
                //   ],
                // ),
                // TermsOfServiceRow(),
// >>>>>>> f424c9835909786e5ce4dfcea63485c12817acd1

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

customDialog(BuildContext context, String text) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: const Text("This feature will be enable soon"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        );
      });
}
