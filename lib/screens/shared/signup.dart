import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/forms/rounded_input_field.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/auth.dart';
import 'package:unit/constants.dart';
import 'package:unit/services/database.dart';
import 'package:unit/translations/locale_keys.g.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String phoneNumber = '';
  String error = '';
  int gender = 0;
  File newProfilePic;

  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  bool loading = false;
  // final FirebaseMessaging messaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    // configureCallbacks();
    Size size = MediaQuery.of(context).size;

    return loading
        ? Loading()
        : Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      //Gender switch
                      CircleAvatar(
                        radius: size.width * 0.12,
                        backgroundImage: newProfilePic != null
                            ? FileImage(newProfilePic)
                            : AssetImage(
                                'assets/images/userPlaceholder.png',
                              ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              bottom: -size.width * 0.01,
                              right: -size.width * 0.01,
                              child: GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: SvgPicture.asset(
                                  'assets/images/add.svg',
                                  width: size.width * 0.095,
                                  height: size.width * 0.095,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.1),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gender = 0;
                                  });
                                },
                                child: Container(
                                  // width: size.width * 0.35,
                                  // height: size.height * 0.07,
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02,
                                    horizontal: size.width * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: gender == 0
                                        ? kPrimaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: gender == 0
                                          ? Colors.transparent
                                          : kPrimaryLightColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      tr(LocaleKeys.gender_one),
                                      style: TextStyle(
                                        color: gender == 0
                                            ? Colors.white
                                            : kPrimaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gender = 1;
                                  });
                                },
                                child: Container(
                                  // width: size.width * 0.35,
                                  // height: size.height * 0.07,
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02,
                                    horizontal: size.width * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: gender == 1
                                        ? kPrimaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: gender == 1
                                          ? Colors.transparent
                                          : kPrimaryLightColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      tr(LocaleKeys.gender_two),
                                      style: TextStyle(
                                        color: gender == 1
                                            ? Colors.white
                                            : kPrimaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      RoundedInputField(
                        obsecureText: false,
                        icon: Icons.person_add_alt,
                        hintText: tr(LocaleKeys.name),
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                        validator: (val) =>
                            val.isEmpty ? tr(LocaleKeys.enter_a_name) : null,
                      ),
                      RoundedInputField(
                        obsecureText: false,
                        icon: Icons.phone,
                        hintText: tr(LocaleKeys.phone_number),
                        onChanged: (val) {
                          setState(() => phoneNumber = val);
                        },
                        validator: (val) => val.length != 11
                            ? tr(LocaleKeys.enter_a_number)
                            : null,
                      ),
                      RoundedInputField(
                        obsecureText: false,
                        icon: Icons.email,
                        hintText: tr(LocaleKeys.email),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        validator: (val) =>
                            val.isEmpty ? tr(LocaleKeys.enter_an_email) : null,
                      ),
                      RoundedInputField(
                        obsecureText: true,
                        icon: Icons.lock,
                        hintText: tr(LocaleKeys.password),
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        validator: (val) => val.length < 6
                            ? tr(LocaleKeys.enter_a_password)
                            : null,
                      ),
                      RoundedButton(
                        text: tr(LocaleKeys.signup),
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });

                            MyUser result =
                                await AuthService().registerWithEmailAndPasword(
                              email,
                              password,
                              name,
                              phoneNumber,
                              gender == 0 ? 'male' : 'female',
                              'client',
                              '',
                            );

                            if (result == null) {
                              setState(() {
                                error = tr(LocaleKeys.invalid_credentials);
                                loading = false;
                              });
                            } else {
                              String downloadUrl;
                              if (newProfilePic != null) {
                                final Reference firebaseStorageRef =
                                    FirebaseStorage.instance
                                        .ref()
                                        .child('profilePics/${result.uid}.jpg');
                                UploadTask task =
                                    firebaseStorageRef.putFile(newProfilePic);
                                TaskSnapshot taskSnapshot = await task;
                                downloadUrl =
                                    await taskSnapshot.ref.getDownloadURL();
                              }

                              // Add client to clients collectionab
                              DatabaseService db =
                                  DatabaseService(uid: result.uid);

                              await db.updateUserProfilePicture(
                                  newProfilePic != null ? downloadUrl : '');

                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
