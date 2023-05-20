import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/interest_gird_view.dart';
import '../widgets/default_button.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({Key? key}) : super(key: key);

  @override
  _InterestScreenState createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.height * 0.06,
                    margin: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                "Your interests",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select a few of your interests and let everyone know what you’re passionate about.",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Expanded(child: CustomGridView()),

              /// Sign Up button
              SizedBox(
                width: double.maxFinite,
                child: DefaultButton(
                  child: const Text("CREATE_ACCOUNT",
                      style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    final FirebaseFirestore _firestore =
                        FirebaseFirestore.instance;

                    /// Sign up
                    // _createAccount();
                    void getDataFromFirestore() async {
                      QuerySnapshot querySnapshot =
                          await _firestore.collection('AppInfo').get();

                      if (querySnapshot.docs.isNotEmpty) {
                        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
                        Map<String, dynamic> data =
                            docSnapshot.data() as Map<String, dynamic>;
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}