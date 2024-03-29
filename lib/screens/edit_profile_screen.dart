 
import 'package:Mingledxb/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../dialogs/common_dialogs.dart';
import '../dialogs/progress_dialog.dart';
import '../helpers/app_localizations.dart';
import '../models/user_model.dart';
import '../widgets/image_source_sheet.dart';
import '../widgets/svg_icon.dart';
import '../widgets/user_gallery.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Variables
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _schoolController =
      TextEditingController(text: UserModel().user.userSchool);
  final _jobController =
      TextEditingController(text: UserModel().user.userJobTitle);
  final _bioController = TextEditingController(text: UserModel().user.userBio);
  late AppLocalizations _i18n;
  late ProgressDialog _pr;

  @override
  Widget build(BuildContext context) {
    /// Initialization
    _i18n = AppLocalizations.of(context);
    _pr = ProgressDialog(context, isDismissible: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_i18n.translate("edit_profile")),
        actions: [
          // Save changes button
          TextButton(
            child: Text(_i18n.translate("SAVE"),
                style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              /// Validate form
              if (_formKey.currentState!.validate()) {
                _saveChanges();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ScopedModelDescendant<UserModel>(
              builder: (context, child, userModel) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile photo
                GestureDetector(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(userModel.user.userProfilePhoto),
                          radius: 80,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),

                        /// Edit icon
                        Positioned(
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(Icons.edit, color: Colors.white),
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
                const SizedBox(height: 10),
                Center(
                  child: Text(_i18n.translate("profile_photo"),
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center),
                ),

                /// Profile gallery
                Text(_i18n.translate("gallery"),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.left),
                const SizedBox(height: 5),

                /// Show gallery
                const UserGallery(),

                const SizedBox(height: 20),

                /// Bio field
                TextFormField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: _i18n.translate("bio"),
                    hintText: _i18n.translate("write_about_you"),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SvgIcon("assets/icons/info_icon.svg"),
                    ),
                  ),
                  validator: (bio) {
                    if (bio == null) {
                      return _i18n.translate("please_write_your_bio");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                /// School field
                TextFormField(
                  controller: _schoolController,
                  decoration: InputDecoration(
                      labelText: _i18n.translate("school"),
                      hintText: _i18n.translate("enter_your_school_name"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(9.0),
                        child: SvgIcon("assets/icons/university_icon.svg"),
                      )),
                  validator: (school) {
                    if (school == null) {
                      return _i18n.translate("please_enter_your_school_name");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                /// Job title field
                TextFormField(
                  controller: _jobController,
                  decoration: InputDecoration(
                      labelText: _i18n.translate("job_title"),
                      hintText: _i18n.translate("enter_your_job_title"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SvgIcon("assets/icons/job_bag_icon.svg"),
                      )),
                  validator: (job) {
                    if (job == null) {
                      return _i18n.translate("please_enter_your_job_title");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(user: UserModel().user, showButtons: false)));
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
