import 'package:Mingledxb/widgets/show_scaffold_msg.dart';
import 'package:Mingledxb/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../api/dislikes_api.dart';
import '../api/likes_api.dart';
import '../api/matches_api.dart';
import '../constants/constants.dart';
import '../datas/user.dart';
import '../dialogs/common_dialogs.dart';
import '../dialogs/progress_dialog.dart';
import '../dialogs/show_me_dialog.dart';
import '../dialogs/vip_dialog.dart';
import '../helpers/app_helper.dart';
import '../helpers/app_localizations.dart';
import '../models/app_model.dart';
import '../models/user_model.dart';
import '../widgets/user_gallery.dart';
import 'passport_screen.dart';
import '../widgets/image_source_sheet.dart';

class CustomProfileScreen extends StatefulWidget {
  /// Params
  final User user;
  final bool showButtons;
  final bool hideDislikeButton;
  final bool fromDislikesScreen;
  const CustomProfileScreen(
      {super.key,
      required this.user,
      this.showButtons = true,
      this.hideDislikeButton = false,
      this.fromDislikesScreen = false});

  @override
  State<CustomProfileScreen> createState() => _CustomProfileScreenState();
}

class _CustomProfileScreenState extends State<CustomProfileScreen> {
  ///  variables from view profile screen
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppHelper _appHelper = AppHelper();
  final LikesApi _likesApi = LikesApi();
  final DislikesApi _dislikesApi = DislikesApi();
  final MatchesApi _matchesApi = MatchesApi();
  // late AppLocalizations _i18n;

  // Variables from edit screen
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _schoolController =
      TextEditingController(text: UserModel().user.userSchool);
  final _jobController =
      TextEditingController(text: UserModel().user.userJobTitle);
  final _bioController = TextEditingController(text: UserModel().user.userBio);
  late AppLocalizations _i18n;
  late ProgressDialog _pr;

  // Go to Passport screen
  Future<void> _goToPassportScreen() async {
    // Get picked location result
    LocationResult? result = await Navigator.of(context).push<LocationResult?>(
        MaterialPageRoute(builder: (context) => const PassportScreen()));
    // Handle the retur result
    if (result != null) {
      // Update current your location
      _updateUserLocation(true, locationResult: result);
      // Debug info
      debugPrint(
          '_goToPassportScreen() -> result: ${result.country!.name}, ${result.city!.name}');
    } else {
      debugPrint('_goToPassportScreen() -> result: empty');
    }
  }

  // Update User Location
  Future<void> _updateUserLocation(bool isPassport,
      {LocationResult? locationResult}) async {
    /// Update user location: Country & City an Geo Data

    /// Update user data
    await UserModel().updateUserLocation(
        isPassport: isPassport,
        locationResult: locationResult,
        onSuccess: () {
          // Show success message
          showScaffoldMessage(
              context: context,
              message: _i18n.translate("location_updated_successfully"));
        },
        onFail: () {
          // Show error message
          showScaffoldMessage(
              context: context,
              message:
                  _i18n.translate("we_were_unable_to_update_your_location"));
        });
  }

//setting screeen
// Variables

  late RangeValues _selectedAgeRange;
  late RangeLabels _selectedAgeRangeLabels;
  late double _selectedMaxDistance;
  bool _hideProfile = false;

  /// Initialize user settings
  void initUserSettings() {
    // Get user settings
    final Map<String, dynamic> _userSettings = UserModel().user.userSettings!;
    // Update variables state
    setState(() {
      // Get user max distance
      _selectedMaxDistance = _userSettings[USER_MAX_DISTANCE].toDouble();

      // Get age range
      final double minAge = _userSettings[USER_MIN_AGE].toDouble();
      final double maxAge = _userSettings[USER_MAX_AGE].toDouble();

      // Set range values
      _selectedAgeRange = RangeValues(minAge, maxAge);
      _selectedAgeRangeLabels = RangeLabels('$minAge', '$maxAge');

      // Check profile status
      if (UserModel().user.userStatus == 'hidden') {
        _hideProfile = true;
      }
    });
  }

  String _showMeOption(AppLocalizations i18n) {
    // Variables
    final Map<String, dynamic> settings = UserModel().user.userSettings!;
    final String? showMe = settings[USER_SHOW_ME];
    // Check option
    if (showMe != null) {
      return i18n.translate(showMe);
    }
    return i18n.translate('opposite_gender');
  }

  @override
  void initState() {
    super.initState();
    // TODO: uncomment the line below if you want to display the Ads
    // Note: before make sure to add your Interstial AD ID
    // AppAdHelper().showInterstitialAd();
    initUserSettings();
  }

  @override
  void dispose() {
    // TODO: uncomment the line below to dispose it.
    // AppAdHelper().disposeInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialization
    _i18n = AppLocalizations.of(context);
    //
    // Get User Birthday
    final DateTime userBirthday = DateTime(widget.user.userBirthYear,
        widget.user.userBirthMonth, widget.user.userBirthDay);
    // Get User Current Age
    final int userAge = UserModel().calculateUserAge(userBirthday);

    /// Initialization

    _pr = ProgressDialog(context, isDismissible: false);
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _dateOfBirthController = TextEditingController();
    TextEditingController _currentPlanController = TextEditingController();
    _nameController.text = widget.user.userFullname;
    _phoneController.text = "+911234567890";
    _dateOfBirthController.text =
        "${widget.user.userBirthYear}-${widget.user.userBirthMonth < 9 ? "0${widget.user.userBirthMonth}" : widget.user.userBirthMonth}-${widget.user.userBirthDay < 9 ? "0${widget.user.userBirthDay}" : widget.user.userBirthDay}";
    _currentPlanController.text = "Free";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_i18n.translate("edit_profile")),
        actions: const [],
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, userModel) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Profile photo
                  ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(29, 162, 222, 1.0),
                            Color.fromRGBO(244, 179, 183, 1.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              _i18n.translate("profile"),
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            child: Center(
                              child: Stack(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        64, // Adjust as needed to make the white circle bigger or smaller
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(
                                          userModel.user.userProfilePhoto),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Positioned(
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: const Icon(Icons.edit,
                                          color: Colors.white),
                                    ),
                                    right: 0,
                                    bottom: 0,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              /// Update profile image
                              _selectImage(
                                  imageUrl: userModel.user.userProfilePhoto,
                                  path: 'profile');
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // name age
                          Center(
                            child: Text(
                              '${widget.user.userFullname}, '
                              '${userAge.toString()}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _i18n.translate("account_settings"),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            // Save changes button
                            TextButton(
                              child: Text(_i18n.translate("SAVE"),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                              onPressed: () {
                                /// Validate form
                                if (_formKey.currentState!.validate()) {
                                  _saveChanges();
                                }
                              },
                            )
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Name "),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller: _nameController,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Phone Number
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Phone Number"),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller: _phoneController,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Date of birth
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Date of birth "),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller: _dateOfBirthController,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Email "),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller: _emailController,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// Bio field
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text(_i18n.translate("write_about_you")),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller: _bioController,
                                  textAlign: TextAlign.right,
                                  validator: (bio) {
                                    if (bio == null) {
                                      return _i18n
                                          .translate("please_write_your_bio");
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// School field
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_i18n.translate("school")),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller: _schoolController,
                                  textAlign: TextAlign.right,
                                  validator: (school) {
                                    if (school == null) {
                                      return _i18n.translate(
                                          "please_enter_your_school_name");
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Job title field
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_i18n.translate("job_title")),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller: _jobController,
                                  textAlign: TextAlign.right,
                                  validator: (job) {
                                    if (job == null) {
                                      return _i18n.translate(
                                          "please_enter_your_job_title");
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        //current_plan
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _i18n.translate("plan_settings"),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_i18n.translate("current_plan")),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  controller:
                                      _currentPlanController, //TODO: add current plan
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Plan settings
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _i18n.translate("discovery_settings"),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        /// Passport feature
                        /// Travel to any Country or City and Swipe Women there!
                        Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            elevation: 2.0,
                            shadowColor: Theme.of(context).primaryColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_i18n.translate("passport"),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ListTile(
                                  leading: Icon(Icons.flight,
                                      color: Theme.of(context).primaryColor,
                                      size: 40),
                                  title: Text(_i18n.translate(
                                      "travel_to_any_country_or_city_and_match_with_people_there")),
                                  trailing: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Text(_i18n.translate("travel_now"),
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    onPressed: () async {
                                      // // Check User VIP Account Status
                                      if (UserModel().userIsVip) {
                                        // Go to passport screen
                                        _goToPassportScreen();
                                      } else {
                                        /// Show VIP dialog
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const VipDialog());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 20),

                        /// User current location
                        Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      _i18n.translate("your_current_location"),
                                      style: const TextStyle(fontSize: 18)),
                                ),
                                ListTile(
                                  leading: SvgIcon(
                                      "assets/icons/location_point_icon.svg",
                                      color: Theme.of(context).primaryColor),
                                  title: Text(
                                      '${UserModel().user.userCountry}, ${UserModel().user.userLocality}'),
                                  trailing: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                    ),
                                    child: Text(_i18n.translate("UPDATE"),
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    onPressed: () async {
                                      /// Update user location: Country & City an Geo Data
                                      _updateUserLocation(false);
                                    },
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 15),

                        /// User Max distance
                        Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          '${_i18n.translate("maximum_distance")} ${_selectedMaxDistance.round()} km',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 3),
                                      Text(
                                          _i18n.translate(
                                              "show_people_within_this_radius"),
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                Slider(
                                  activeColor: APP_ACCENT_COLOR,
                                  value: _selectedMaxDistance,
                                  label:
                                      _selectedMaxDistance.round().toString() +
                                          ' km',
                                  divisions: 100,
                                  min: 0,

                                  /// Check User VIP Account to set max distance available
                                  max: UserModel().userIsVip
                                      ? AppModel().appInfo.vipAccountMaxDistance
                                      : AppModel()
                                          .appInfo
                                          .freeAccountMaxDistance,
                                  onChanged: (radius) {
                                    setState(() {
                                      _selectedMaxDistance = radius;
                                    });
                                    // debug
                                    debugPrint('_selectedMaxDistance: '
                                        '${radius.toStringAsFixed(2)}');
                                  },
                                  onChangeEnd: (radius) {
                                    /// Update user max distance
                                    UserModel().updateUserData(
                                        userId: UserModel().user.userId,
                                        data: {
                                          '$USER_SETTINGS.$USER_MAX_DISTANCE':
                                              double.parse(
                                                  radius.toStringAsFixed(2))
                                        }).then((_) {
                                      debugPrint(
                                          'User max distance updated -> ${radius.toStringAsFixed(2)}');
                                    });
                                  },
                                ),
                                // Show message for non VIP user
                                UserModel().userIsVip
                                    ? const SizedBox(width: 0, height: 0)
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${_i18n.translate("need_more_radius_away")} "
                                            "${AppModel().appInfo.vipAccountMaxDistance} km "
                                            "${_i18n.translate('radius_away')}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                              ],
                            )),
                        const SizedBox(height: 15),

                        // User age range
                        Card(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(_i18n.translate("age_range"),
                                  style: const TextStyle(fontSize: 19)),
                              subtitle: Text(_i18n.translate(
                                  "show_people_within_this_age_range")),
                              trailing: Text(
                                  "${_selectedAgeRange.start.toStringAsFixed(0)} - "
                                  "${_selectedAgeRange.end.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            RangeSlider(
                                activeColor: APP_ACCENT_COLOR,
                                values: _selectedAgeRange,
                                labels: _selectedAgeRangeLabels,
                                divisions: 100,
                                min: 18,
                                max: 100,
                                onChanged: (newRange) {
                                  // Update state
                                  setState(() {
                                    _selectedAgeRange = newRange;
                                    _selectedAgeRangeLabels = RangeLabels(
                                        newRange.start.toStringAsFixed(0),
                                        newRange.end.toStringAsFixed(0));
                                  });
                                  debugPrint(
                                      '_selectedAgeRange: $_selectedAgeRange');
                                },
                                onChangeEnd: (endValues) {
                                  /// Update age range
                                  ///
                                  /// Get start value
                                  final int minAge = int.parse(
                                      endValues.start.toStringAsFixed(0));

                                  /// Get end value
                                  final int maxAge = int.parse(
                                      endValues.end.toStringAsFixed(0));

                                  // Update age range
                                  UserModel().updateUserData(
                                      userId: UserModel().user.userId,
                                      data: {
                                        '$USER_SETTINGS.$USER_MIN_AGE': minAge,
                                        '$USER_SETTINGS.$USER_MAX_AGE': maxAge,
                                      }).then((_) {
                                    debugPrint('Age range updated');
                                  });
                                })
                          ],
                        )),

                        const SizedBox(height: 15),
                        // Show me option
                        Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.wc_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            title: Text(_i18n.translate('show_me'),
                                style: const TextStyle(fontSize: 18)),
                            trailing: Text(_showMeOption(_i18n),
                                style: const TextStyle(fontSize: 18)),
                            onTap: () {
                              /// Choose Show me option
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return const ShowMeDialog();
                                  });
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Hide user profile setting
                        Card(
                          child: ListTile(
                            leading: _hideProfile
                                ? Icon(Icons.visibility_off,
                                    color: Theme.of(context).primaryColor,
                                    size: 30)
                                : Icon(Icons.visibility,
                                    color: Theme.of(context).primaryColor,
                                    size: 30),
                            title: Text(_i18n.translate('hide_profile'),
                                style: const TextStyle(fontSize: 18)),
                            subtitle: _hideProfile
                                ? Text(
                                    _i18n.translate(
                                        'your_profile_is_hidden_on_discover_tab'),
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : Text(
                                    _i18n.translate(
                                        'your_profile_is_visible_on_discover_tab'),
                                    style:
                                        const TextStyle(color: Colors.green)),
                            trailing: Switch(
                              activeColor: Theme.of(context).primaryColor,
                              value: _hideProfile,
                              onChanged: (newValue) {
                                // Update UI
                                setState(() {
                                  _hideProfile = newValue;
                                });
                                // User status
                                String userStatus = 'active';
                                // Check status
                                if (newValue) {
                                  userStatus = 'hidden';
                                }

                                // Update profile status
                                UserModel().updateUserData(
                                    userId: UserModel().user.userId,
                                    data: {USER_STATUS: userStatus}).then((_) {
                                  debugPrint('Profile hidden: $newValue');
                                });
                              },
                            ),
                          ),
                        ),

                        /// Profile details
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Show verified badge
                                  widget.user.userIsVerified
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: Image.asset(
                                              'assets/images/verified_badge.png',
                                              width: 30,
                                              height: 30))
                                      : const SizedBox(width: 0, height: 0),

                                  /// Show VIP badge for current user
                                  UserModel().user.userId ==
                                              widget.user.userId &&
                                          UserModel().userIsVip
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: Image.asset(
                                              'assets/images/crow_badge.png',
                                              width: 25,
                                              height: 25))
                                      : const SizedBox(width: 0, height: 0),

                                  // /// Location distance
                                  // CustomBadge(
                                  //     icon: const SvgIcon(
                                  //         "assets/icons/location_point_icon.svg",
                                  //         color: Colors.white,
                                  //         width: 15,
                                  //         height: 15),
                                  //     text:
                                  //         '${_appHelper.getDistanceBetweenUsers(userLat: widget.user.userGeoPoint.latitude, userLong: widget.user.userGeoPoint.longitude)}km')
                                ],
                              ),

                              const SizedBox(height: 5),

                              /// Join date
                              _rowProfileInfo(context,
                                  icon: SvgIcon("assets/icons/info_icon.svg",
                                      color: Theme.of(context).primaryColor,
                                      width: 28,
                                      height: 28),
                                  title:
                                      '${_i18n.translate('join_date')} ${timeago.format(widget.user.userRegDate)}'),

                              const Divider(),
                            ],
                          ),
                        ),

                        // Profile gallery
                        Text(_i18n.translate("gallery"),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                            textAlign: TextAlign.left),
                        const SizedBox(height: 5),

                        // Show gallery
                        const UserGallery(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Get image from camera / gallery
  void _selectImage({required String imageUrl, required String path}) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ImageSourceSheet(
              onImageSelected: (image) async {
                if (image != null) {
                  /// Show progress dialog
                  _pr.show(_i18n.translate("processing"));

                  /// Update profile image
                  await UserModel().updateProfileImage(
                      imageFile: image, oldImageUrl: imageUrl, path: 'profile');
                  // Hide dialog
                  _pr.hide();
                  // close modal
                  Navigator.of(context).pop();
                }
              },
            ));
  }

  /// Update profile changes for TextFormField only
  void _saveChanges() {
    /// Update uer profile
    UserModel().updateProfile(
        userSchool: _schoolController.text.trim(),
        userJobTitle: _jobController.text.trim(),
        userBio: _bioController.text.trim(),
        onSuccess: () {
          /// Show success message
          successDialog(context,
              message: _i18n.translate("profile_updated_successfully"),
              positiveAction: () {
            /// Close dialog
            Navigator.of(context).pop();

            /// Go to profilescreen
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         ProfileScreen(user: UserModel().user, showButtons: false),
            //   ),
            // );
          });
        },
        onFail: (error) {
          // Debug error
          debugPrint(error);
          // Show error message
          errorDialog(context,
              message: _i18n
                  .translate("an_error_occurred_while_updating_your_profile"));
        });
  }
}

/// For curve 
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 20;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


Widget _rowProfileInfo(BuildContext context,
    {required Widget icon, required String title}) {
  return Row(
    children: [
      icon,
      const SizedBox(width: 10),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: const TextStyle(fontSize: 19)),
      ),
    ],
  );
}
