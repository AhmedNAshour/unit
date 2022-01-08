import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/forms/rounded_input_field.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/auth.dart';
import 'package:unit/services/database.dart';
import 'package:unit/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AdminAddSalesman extends StatefulWidget {
  static const id = 'AddSalesman';
  final Function toggleView;
  AdminAddSalesman({this.toggleView});
  @override
  _AdminAddSalesmanState createState() => _AdminAddSalesmanState();
}

class _AdminAddSalesmanState extends State<AdminAddSalesman> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String lName = '';
  String phoneNumber = '';
  String error = '';
  int numAppointments = 0;
  int gender = 0;
  bool loading = false;
  String curEmail;
  String curPassword;
  File newProfilePic;

  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  uploadImage(String uid) async {
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilePics/$uid.jpg');
    UploadTask task = firebaseStorageRef.putFile(newProfilePic);
    TaskSnapshot taskSnapshot = await task;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => DatabaseService(uid: uid)
              .updateUserProfilePicture(value.toString()),
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        BackButton(
                          color: kSecondaryColor,
                        ),
                        // SizedBox(
                        //   width: size.width * 0.2,
                        // ),
                        Text(
                          'Add Salesman',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Expanded(
                    child: Container(
                      // height: size.height * 0.5,
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.1),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/gender.svg',
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Text(
                                      'Gender',
                                      style: TextStyle(
                                        color: kPrimaryTextColor,
                                        fontSize: size.width * 0.06,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.04,
                                    ),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: gender == 0
                                                  ? Colors.transparent
                                                  : kPrimaryLightColor,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Male',
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: gender == 1
                                                  ? Colors.transparent
                                                  : kPrimaryLightColor,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Female',
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
                                hintText: 'Name',
                                onChanged: (val) {
                                  setState(() => name = val);
                                },
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a name' : null,
                              ),

                              RoundedInputField(
                                obsecureText: false,
                                icon: Icons.phone,
                                hintText: 'Phone Number',
                                onChanged: (val) {
                                  setState(() => phoneNumber = val);
                                },
                                validator: (val) => val.length != 11
                                    ? 'Enter a valid number'
                                    : null,
                              ),

                              RoundedInputField(
                                obsecureText: false,
                                icon: Icons.email,
                                hintText: 'Email',
                                onChanged: (val) {
                                  setState(() => email = val);
                                },
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an email' : null,
                              ),
                              RoundedInputField(
                                obsecureText: true,
                                icon: Icons.lock,
                                hintText: 'Password',
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                                validator: (val) => val.length < 6
                                    ? ' Enter a password 6+ chars long '
                                    : null,
                              ),
                              RoundedButton(
                                text: 'ADD',
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    MyUser result = await _auth
                                        .createUserWithEmailAndPasword(
                                      email,
                                      password,
                                      name,
                                      phoneNumber,
                                      gender == 0 ? 'male' : 'female',
                                      'salesman',
                                      '',
                                    );
                                    if (result == null) {
                                      setState(() {
                                        error = 'invalid credentials';
                                        loading = false;
                                      });
                                    } else {
                                      String downloadUrl;
                                      if (newProfilePic != null) {
                                        final Reference firebaseStorageRef =
                                            FirebaseStorage.instance.ref().child(
                                                'profilePics/${result.uid}.jpg');
                                        UploadTask task = firebaseStorageRef
                                            .putFile(newProfilePic);
                                        TaskSnapshot taskSnapshot = await task;
                                        downloadUrl = await taskSnapshot.ref
                                            .getDownloadURL();
                                      }

                                      // Add client to clients collectionab
                                      DatabaseService db =
                                          DatabaseService(uid: result.uid);

                                      await db.updateUserProfilePicture(
                                          newProfilePic != null
                                              ? downloadUrl
                                              : '');
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                error,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
