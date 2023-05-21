import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../api/dislikes_api.dart';
import '../api/likes_api.dart';
import '../api/matches_api.dart';
import '../constants/constants.dart';
import '../datas/user.dart';
import '../dialogs/its_match_dialog.dart';
import '../dialogs/report_dialog.dart';
import '../helpers/app_helper.dart';
import '../helpers/app_localizations.dart';
import '../models/user_model.dart';
import '../plugins/carousel_pro/carousel_pro.dart';
import '../widgets/cicle_button.dart';
import '../widgets/custom_badge.dart';
import '../widgets/default_button.dart';
import '../widgets/show_scaffold_msg.dart';
import '../widgets/svg_icon.dart';
import '../widgets/user_gallery.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  /// Params
  final User user;
  final bool showButtons;
  final bool hideDislikeButton;
  final bool fromDislikesScreen;

  // Constructor
  const ProfileScreen(
      {Key? key,
      required this.user,
      this.showButtons = true,
      this.hideDislikeButton = false,
      this.fromDislikesScreen = false})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Local variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppHelper _appHelper = AppHelper();
  final LikesApi _likesApi = LikesApi();
  final DislikesApi _dislikesApi = DislikesApi();
  final MatchesApi _matchesApi = MatchesApi();
  late AppLocalizations _i18n;

  @override
  void initState() {
    super.initState();
    // Note: before make sure to add your Interstial AD ID
    // AppAdHelper().showInterstitialAd();
  }

  @override
  void dispose() {
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

    return Scaffold(
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
            builder: (context, child, userModel) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    /// Carousel Profile images
                    Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 2,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.8,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Carousel(
                                autoplay: false,
                                dotBgColor: Colors.transparent,
                                dotIncreasedColor:
                                    Theme.of(context).primaryColor,
                                images: UserModel()
                                    .getUserProfileImages(widget.user)
                                    .map((url) => NetworkImage(url))
                                    .toList()),
                          ),
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height / 2,
                            bottom: 0,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50))),
                            )),
                        Positioned(
                            top: MediaQuery.of(context).size.height / 2.3,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                spreadRadius: .01,
                                                blurRadius: 10,
                                                offset: const Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: const CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.close,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 50,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFFF4B3B7),
                                                  Color(0xFFF4B3B7),
                                                  Color(0xFF589DC6),
                                                ],
                                                stops: [0.0, 0.333, 1.0],
                                              ),
                                            ),
                                            child: Image.asset(
                                              'assets/icons/heartIcon.png',
                                              height: 50,
                                              width: 50,
                                            ),

                                            // child: const Icon(
                                            //   Icons.favorite_border,
                                            //   size: 50,
                                            //   color: Colors.white,
                                            //   fill: 0.1,
                                            // ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                spreadRadius: .01,
                                                blurRadius: 10,
                                                offset: const Offset(0,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: const CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.star,
                                              color: APP_ACCENT_COLOR,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),

                                    /// Profile details
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              /// Full Name
                                              Expanded(
                                                child: Text(
                                                  '${widget.user.userFullname}, '
                                                  '${userAge.toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),

                                              /// Show verified badge
                                              widget.user.userIsVerified
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Image.asset(
                                                          'assets/images/verified_badge.png',
                                                          width: 30,
                                                          height: 30))
                                                  : const SizedBox(
                                                      width: 0, height: 0),

                                              /// Show VIP badge for current user
                                              UserModel().user.userId ==
                                                          widget.user.userId &&
                                                      UserModel().userIsVip
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Image.asset(
                                                          'assets/images/crow_badge.png',
                                                          width: 25,
                                                          height: 25))
                                                  : const SizedBox(
                                                      width: 0, height: 0),

                                              /// Location distance
                                              CustomBadge(
                                                  icon: const SvgIcon(
                                                      "assets/icons/location_point_icon.svg",
                                                      color: Colors.white,
                                                      width: 15,
                                                      height: 15),
                                                  text:
                                                      '${_appHelper.getDistanceBetweenUsers(userLat: widget.user.userGeoPoint.latitude, userLong: widget.user.userGeoPoint.longitude)}km')
                                            ],
                                          ),
                                          const SizedBox(height: 5),

                                          /// Job title
                                          _rowProfileInfo(
                                            context,
                                            icon: const SvgIcon(
                                                "assets/icons/job_bag_icon.svg",
                                                color: Colors.black38,
                                                width: 27,
                                                height: 27),
                                            title: widget.user.userJobTitle,
                                          ),

                                          const SizedBox(height: 5),

                                          /// Profile bio
                                          const Text("About",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                          Text(widget.user.userBio,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black38)),
                                          const SizedBox(height: 5),

                                          /// Home location
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                               Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text("Mingle Events",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      "Anti Valentines Day Party",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.black38)),
                                                  SizedBox(height: 5),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  DefaultButton(
                                                    child:
                                                        const Text("Atteding"),
                                                    onPressed: () {},
                                                  ),
                                                  const SizedBox(height: 5),
                                                  const Text("14th Feb 2021",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.black38)),
                                                  const SizedBox(height: 5),
                                                ],
                                              )
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Intersets",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          const SizedBox(
                                            height: 150,
                                          ),
                                          _rowProfileInfo(
                                            context,
                                            icon: SvgIcon(
                                                "assets/icons/location_point_icon.svg",
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 24,
                                                height: 24),
                                            title:
                                                "${widget.user.userLocality}, ${widget.user.userCountry}",
                                          ),

                                          /// Education
                                          _rowProfileInfo(context,
                                              icon: SvgIcon(
                                                  "assets/icons/university_icon.svg",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 34,
                                                  height: 34),
                                              title: widget.user.userSchool),

                                          /// Birthday
                                          _rowProfileInfo(context,
                                              icon: SvgIcon(
                                                  "assets/icons/gift_icon.svg",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 28,
                                                  height: 28),
                                              title:
                                                  '${_i18n.translate('birthday')} ${widget.user.userBirthYear}/${widget.user.userBirthMonth}/${widget.user.userBirthDay}'),

                                          /// Join date
                                          _rowProfileInfo(context,
                                              icon: SvgIcon(
                                                  "assets/icons/info_icon.svg",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 28,
                                                  height: 28),
                                              title: 'HELO'
                                              // title:
                                              //     '${_i18n.translate('join_date')} ${timeago.format(widget.user.userRegDate)}'),
                                              ),
                                          const Divider(),
                                          const UserGallery(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),

              /// AppBar to return back
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  actions: <Widget>[
                    // Check the current User ID
                    if (UserModel().user.userId != widget.user.userId)
                      IconButton(
                        icon: Icon(Icons.flag,
                            color: Theme.of(context).primaryColor, size: 32),
                        // Report/Block profile dialog
                        onPressed: () =>
                            ReportDialog(userId: widget.user.userId).show(),
                      )
                  ],
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar:
            widget.showButtons ? _buildButtons(context) : null);
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

  /// Build Like and Dislike buttons
  Widget _buildButtons(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// Dislike profile button
            if (!widget.hideDislikeButton)
              cicleButton(
                  padding: 8.0,
                  icon:
                      Icon(Icons.close, color: Theme.of(context).primaryColor),
                  bgColor: Colors.grey,
                  onTap: () {
                    // Dislike profile
                    _dislikesApi.dislikeUser(
                        dislikedUserId: widget.user.userId,
                        onDislikeResult: (result) {
                          /// Check result to show message
                          if (!result) {
                            // Show error message
                            showScaffoldMessage(
                                context: context,
                                message: _i18n.translate(
                                    "you_already_disliked_this_profile"));
                          }
                        });
                  }),

            /// Like profile button
            cicleButton(
                padding: 8.0,
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                bgColor: Theme.of(context).primaryColor,
                onTap: () {
                  // Like user
                  _likeUser(context);
                }),
          ],
        ));
  }

  /// Like user function
  Future<void> _likeUser(BuildContext context) async {
    /// Check match first
    _matchesApi
        .checkMatch(
            userId: widget.user.userId,
            onMatchResult: (result) {
              if (result) {
                /// Show It`s match dialog
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return ItsMatchDialog(
                        matchedUser: widget.user,
                        showSwipeButton: false,
                        swipeKey: null,
                      );
                    });
              }
            })
        .then((_) {
      /// Like user
      _likesApi.likeUser(
          likedUserId: widget.user.userId,
          userDeviceToken: widget.user.userDeviceToken,
          nMessage: "${UserModel().user.userFullname.split(' ')[0]}, "
              "${_i18n.translate("liked_your_profile_click_and_see")}",
          onLikeResult: (result) async {
            if (result) {
              // Show success message
              showScaffoldMessage(
                  context: context,
                  message:
                      '${_i18n.translate("like_sent_to")} ${widget.user.userFullname}');
            } else if (!result) {
              // Show error message
              showScaffoldMessage(
                  context: context,
                  message: _i18n.translate("you_already_liked_this_profile"));
            }

            /// Validate to delete disliked user from disliked list
            else if (result && widget.fromDislikesScreen) {
              // Delete in database
              await _dislikesApi.deleteDislikedUser(widget.user.userId);
            }
          });
    });
  }
}
