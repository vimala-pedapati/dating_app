import 'dart:io';

import 'package:Mingledxb/dialogs/common_dialogs.dart';
import 'package:Mingledxb/helpers/app_localizations.dart';
import 'package:Mingledxb/models/user_model.dart';
import 'package:Mingledxb/screens/sign_in_screen.dart';
import 'package:Mingledxb/widgets/image_source_sheet.dart';
import 'package:Mingledxb/widgets/processing.dart';
import 'package:Mingledxb/widgets/show_scaffold_msg.dart';
import 'package:Mingledxb/widgets/svg_icon.dart';
import 'package:Mingledxb/widgets/terms_of_service_row.dart';
import 'package:flutter/material.dart';
import 'package:Mingledxb/widgets/default_button.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import 'interest_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Variables
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _jobController = TextEditingController();
  final _bioController = TextEditingController();

  /// User Birthday info
  int _userBirthDay = 0;
  int _userBirthMonth = 0;
  int _userBirthYear = DateTime.now().year;
  // End
  DateTime _initialDateTime = DateTime.now();
  String? _birthday;
  File? _imageFile;
  bool _agreeTerms = false;
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female'];
  late AppLocalizations _i18n;

  /// Set terms
  void _setAgreeTerms(bool value) {
    setState(() {
      _agreeTerms = value;
    });
  }

  /// Get image from camera / gallery
  void _getImage(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ImageSourceSheet(
              onImageSelected: (image) {
                if (image != null) {
                  setState(() {
                    _imageFile = image;
                  });
                  // close modal
                  Navigator.of(context).pop();
                }
              },
            ));
  }

  void _updateUserBithdayInfo(DateTime date) {
    setState(() {
      // Update the inicial date
      _initialDateTime = date;
      // Set for label
      _birthday = date.toString().split(' ')[0];
      // User birthday info
      _userBirthDay = date.day;
      _userBirthMonth = date.month;
      _userBirthYear = date.year;
    });
  }

  // Get Date time picker app locale
  DateTimePickerLocale _getDatePickerLocale() {
    // Inicial value
    DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
    // Get the name of the current locale.
    switch (_i18n.translate('lang')) {
      // Handle your Supported Languages below:
      case 'en': // English
        _locale = DateTimePickerLocale.en_us;
        break;
    }
    return _locale;
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.black,
        itemTextStyle: const TextStyle(color: Colors.white),
        confirm: Text(
          _i18n.translate('DONE'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        cancel: Text(
          _i18n.translate('CANCEL'), // You may want to add 'CANCEL' translation
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        // Customize other properties of DateTimePickerTheme as needed
        // For example, you can change the color of the selected date, etc.
      ),
      minDateTime: DateTime(1920, 1, 1),
      maxDateTime: DateTime.now(),
      initialDateTime: _initialDateTime,
      dateFormat: 'yyyy-MMMM-dd', // Date format
      locale: _getDatePickerLocale(), // Set your App Locale here
      onClose: () => debugPrint("----- onClose -----"),
      onCancel: () => debugPrint('onCancel'),
      onChange: (dateTime, List<int> index) {
        // Get birthday info
        _updateUserBithdayInfo(dateTime);
      },
      onConfirm: (dateTime, List<int> index) {
        // Get birthday info
        _updateUserBithdayInfo(dateTime);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Initialization
    _i18n = AppLocalizations.of(context);
    _birthday = _i18n.translate("select_your_birthday");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_i18n.translate("sign_up")),
        actions: [
          // LOGOUT BUTTON
          TextButton(
            child: Text(_i18n.translate('sign_out'),
                // style: TextStyle(color: Theme.of(context).primaryColor)),
                style: const TextStyle(color: Colors.white)),
            onPressed: () {
              // Log out button
              UserModel().signOut().then((_) {
                /// Go to login screen
                Future(() {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignInScreen()));
                });
              });
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, userModel) {
        /// Check loading status
        if (userModel.isLoading) return const Processing();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Text(_i18n.translate("create_account"),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),

              /// Profile photo
              GestureDetector(
                child: Center(
                    child: _imageFile == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const SvgIcon("assets/icons/camera_icon.svg",
                                width: 40, height: 40, color: Colors.white),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(_imageFile!),
                          )),
                onTap: () {
                  /// Get profile image
                  _getImage(context);
                },
              ),
              const SizedBox(height: 10),
              Text(_i18n.translate("profile_photo"), textAlign: TextAlign.center),

              const SizedBox(height: 22),

              /// Form
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: _i18n.translate("fullname"),
                        hintText: _i18n.translate("enter_your_fullname"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgIcon("assets/icons/user_icon.svg"),
                        ),
                        // Add black color to border
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        // Add white color to text, hint, and label
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                      ),
                      // Add white color to the validator error message
                      // You can further customize the errorStyle as needed
                      // For example, changing the color, fontSize, etc.
                      validator: (name) {
                        // Basic validation
                        if (name?.isEmpty ?? false) {
                          return _i18n.translate(
                            "please_enter_your_fullname",
                          );
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    /// User gender
                    /// User gender
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(30), // Adjust the radius value as needed
                        border: Border.all(color: Colors.white), // Add white color to the border
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.black,
                        items: _genders.map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: _i18n.translate("lang") != 'en'
                                ? Text(
                                    '${gender.toString()} - ${_i18n.translate(gender.toString().toLowerCase())} ',
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    gender.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          );
                        }).toList(),
                        hint: Text(
                          _i18n.translate("select_gender"),
                          style:
                              const TextStyle(color: Colors.white), // Add white color to hint text
                        ),
                        onChanged: (gender) {
                          setState(() {
                            _selectedGender = gender;
                          });
                        },
                        validator: (String? value) {
                          if (value == null) {
                            return _i18n.translate("please_select_your_gender");
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Birthday card
                    Card(
                        color: Colors.black,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                            side: BorderSide(color: Colors.grey[350] as Color)),
                        child: ListTile(
                          leading: const SvgIcon("assets/icons/calendar_icon.svg"),
                          title: Text(_birthday!, style: const TextStyle(color: Colors.white)),
                          trailing: const Icon(Icons.arrow_drop_down),
                          onTap: () {
                            /// Select birthday
                            _showDatePicker();
                          },
                        )),
                    const SizedBox(height: 20),

                    /// School field
                    TextFormField(
                      controller: _schoolController,
                      decoration: InputDecoration(
                        // Add black color
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // Border color
                          borderRadius: BorderRadius.circular(28),
                        ),
                        hintStyle: const TextStyle(color: Colors.white), // Hint text color
                        labelStyle: const TextStyle(color: Colors.white), // Label text color
                        labelText: _i18n.translate("school"),
                        hintText: _i18n.translate("enter_your_school_name"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(9.0),
                          child: SvgIcon("assets/icons/university_icon.svg"),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white), // Text input color
                    ),

                    const SizedBox(height: 20),
// job title
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _jobController,
                      decoration: InputDecoration(
                        labelText: _i18n.translate("job_title"),
                        hintText: _i18n.translate("enter_your_job_title"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgIcon("assets/icons/job_bag_icon.svg"),
                        ),
                        // Add black color to border
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        // Add white color to text, hint, and label
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),
// bio
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: _i18n.translate("bio"),
                        hintText: _i18n.translate("please_write_your_bio"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgIcon("assets/icons/info_icon.svg"),
                        ),
                        // Add black color to border
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        // Add white color to text, hint, and label
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                      ),
                      // Add white color to the validator error message
                      // You can further customize the errorStyle as needed
                      // For example, changing the color, fontSize, etc.
                      validator: (bio) {
                        if (bio?.isEmpty ?? false) {
                          return _i18n.translate(
                            "please_write_your_bio",
                          );
                        }
                        return null;
                      },
                    ),

                    /// Agree terms
                    const SizedBox(height: 5),
                    _agreePrivacy(),
                    const SizedBox(height: 20),

                    /// Sign Up button
                    SizedBox(
                      width: double.maxFinite,
                      child: DefaultButton(
                        child: const Text('Next', style: TextStyle(fontSize: 18)),
                        onPressed: () {
                          /// Sign up
                          _createAccount();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Handle Create account
  void _createAccount() async {
    /// check image file
    if (_imageFile == null) {
      // Show error message
      showScaffoldMessage(
          context: context,
          message: _i18n.translate("please_select_your_profile_photo"),
          bgcolor: Colors.red);
      // validate terms
    } else if (!_agreeTerms) {
      // Show error message
      showScaffoldMessage(
          context: context,
          message: _i18n.translate("you_must_agree_to_our_privacy_policy"),
          bgcolor: Colors.red);

      /// Validate form
    } else if (UserModel().calculateUserAge(_initialDateTime) < 18) {
      // Show error message
      showScaffoldMessage(
          context: context,
          duration: const Duration(seconds: 7),
          message: _i18n.translate("only_18_years_old_and_above_are_allowed_to_create_an_account"),
          bgcolor: Colors.red);
    } else if (!_formKey.currentState!.validate()) {
    } else {
      /// Call all input onSaved method
      _formKey.currentState!.save();

      /// Call sign up method
      UserModel().signUp(
        userPhotoFile: _imageFile!,
        userFullName: _nameController.text.trim(),
        userGender: _selectedGender!,
        userBirthDay: _userBirthDay,
        userBirthMonth: _userBirthMonth,
        userBirthYear: _userBirthYear,
        userSchool: _schoolController.text.trim(),
        userJobTitle: _jobController.text.trim(),
        userBio: _bioController.text.trim(),
        userInterests: [],
        onSuccess: () async {
          // Show success message
          successDialog(context,
              message: _i18n.translate("your_account_has_been_created_successfully"),
              positiveAction: () {
            // Execute action
            // Go to get the user device's current location
            Future(() {
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              //         builder: (context) => const UpdateLocationScreen()),
              //     (route) => false);

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const InterestScreen()),
                  (route) => false);
            });
            // End
          });
        },
        onFail: (error) {
          // Debug error
          debugPrint(error);
          // Show error message
          errorDialog(context,
              message: _i18n.translate("an_error_occurred_while_creating_your_account"));
        },
      );
    }
  }

  /// Handle Agree privacy policy
  Widget _agreePrivacy() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Checkbox(
            activeColor: Colors.black, // Color of the checkbox when checked
            checkColor: Colors.black, // Color of the checkmark when checked
            fillColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                // When the checkbox is selected (checked)
                return Colors.white; // Change this to the desired color for the checkbox border
              } else {
                // When the checkbox is not selected (unchecked)
                return Colors.white; // Change this to the desired color for the checkbox border
              }
            }),
            visualDensity: VisualDensity.compact, // Add this property to make the checkbox visible
            value: _agreeTerms,
            onChanged: (value) {
              _setAgreeTerms(value!);
            },
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => _setAgreeTerms(!_agreeTerms),
                child: Text(
                  _i18n.translate("i_agree_with"),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              // Terms of Service and Privacy Policy
              TermsOfServiceRow(color: Colors.white), // Set the color to white
            ],
          ),
        ],
      ),
    );
  }
}
