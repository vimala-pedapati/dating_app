import 'package:Mingledxb/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../api/dislikes_api.dart';
import '../api/visits_api.dart';
import '../constants/constants.dart';
import '../datas/user.dart';
import '../dialogs/vip_dialog.dart';
import '../helpers/app_helper.dart';
import '../helpers/app_localizations.dart';
import '../models/user_model.dart';
import '../widgets/build_title.dart';
import '../widgets/loading_card.dart';
import '../widgets/no_data.dart';
import '../widgets/processing.dart';
import '../widgets/profile_card.dart';
import '../widgets/users_grid.dart';

class DislikedProfilesScreen extends StatefulWidget {
  const DislikedProfilesScreen({Key? key}) : super(key: key);

  @override
  _DislikedProfilesScreenState createState() => _DislikedProfilesScreenState();
}

class _DislikedProfilesScreenState extends State<DislikedProfilesScreen> {
  // Variables
  final ScrollController _gridViewController = ScrollController();
  final DislikesApi _dislikesApi = DislikesApi();
  final VisitsApi _visitsApi = VisitsApi();
  late AppLocalizations _i18n;
  List<DocumentSnapshot<Map<String, dynamic>>>? _dislikedUsers;
  late DocumentSnapshot<Map<String, dynamic>> _userLastDoc;
  bool _loadMore = true;

  /// Load more users
  void _loadMoreUsersListener() async {
    _gridViewController.addListener(() {
      if (_gridViewController.position.pixels == _gridViewController.position.maxScrollExtent) {
        /// Load more users
        if (_loadMore) {
          _dislikesApi
              .getDislikedUsers(withLimit: true, loadMore: true, userLastDoc: _userLastDoc)
              .then((users) {
            /// Update user list
            if (users.isNotEmpty) {
              _updateUserList(users);
            } else {
              setState(() => _loadMore = false);
            }
            debugPrint('load more users: ${users.length}');
          });
        } else {
          debugPrint('No more users');
        }
      }
    });
  }

  /// Update list
  void _updateUserList(List<DocumentSnapshot<Map<String, dynamic>>> users) {
    if (mounted) {
      setState(() {
        _dislikedUsers!.addAll(users);
        if (users.isNotEmpty) {
          _userLastDoc = users.last;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dislikesApi.getDislikedUsers(withLimit: true).then((users) {
      // Check result
      if (users.isNotEmpty) {
        if (mounted) {
          setState(() {
            _dislikedUsers = users;
            _userLastDoc = users.last;
          });
        }
      } else {
        setState(() => _dislikedUsers = []);
      }
    });

    /// Listener
    _loadMoreUsersListener();
  }

  @override
  void dispose() {
    _gridViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialization
    _i18n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        // change color for backbutton
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black, // Background color of the app bar
        title: Text(
          _i18n.translate("disliked_profiles"),
          style: const TextStyle(color: Colors.white), // Text color of the app bar title
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Header Title
          BuildTitle(
            svgIconName: "close_icon",
            title: _i18n.translate("profiles_you_rejected"),
          ),

          /// Matches
          Expanded(child: _showProfiles())
        ],
      ),
    );
  }

  /// Show profiles
  Widget _showProfiles() {
    if (_dislikedUsers == null) {
      return Processing(text: _i18n.translate("loading"));
    } else if (_dislikedUsers!.isEmpty) {
      // No data
      return NoData(svgName: 'close_icon', text: _i18n.translate("no_dislike"));
    } else {
      /// Show users
      return UsersGrid(
        gridViewController: _gridViewController,
        itemCount: _dislikedUsers!.length + 1,

        /// Workaround for loading more
        itemBuilder: (context, index) {
          /// Validate fake index
          if (index < _dislikedUsers!.length) {
            /// Get user id
            final userId = _dislikedUsers![index][DISLIKED_USER_ID];

            /// Load profile
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: UserModel().getUser(userId),
                builder: (context, snapshot) {
                  /// Check result
                  if (!snapshot.hasData) {
                    return const LoadingCard();
                  } else if (snapshot.data?.data() == null) {
                    AppHelper().ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _dislikedUsers!.removeAt(index);
                        });
                      }
                    });

                    return const LoadingCard();
                  } else {
                    /// Get user object
                    final User user = User.fromDocument(snapshot.data!.data()!);

                    /// Show user card
                    return GestureDetector(
                      child: ProfileCard(user: user, page: 'require_vip'),
                      onTap: () {
                        /// Check vip account
                        if (UserModel().userIsVip) {
                          /// Go to profile screen - using showDialog to
                          /// prevents reloading getUser FutureBuilder
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return ProfileScreen(
                                    user: user, hideDislikeButton: true, fromDislikesScreen: true);
                              });

                          /// Increment user visits an push notification
                          _visitsApi.visitUserProfile(
                            visitedUserId: user.userId,
                            userDeviceToken: user.userDeviceToken,
                            nMessage: "${UserModel().user.userFullname.split(' ')[0]}, "
                                "${_i18n.translate("visited_your_profile_click_and_see")}",
                          );
                        } else {
                          /// Show VIP dialog
                          showDialog(context: context, builder: (context) => const VipDialog());
                        }
                      },
                    );
                  }
                });
          } else {
            return Container();
          }
        },
      );
    }
  }
}
