import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/forms/rounded_input_field.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/auth.dart';
import 'package:unit/constants.dart';
import 'package:unit/translations/locale_keys.g.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
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
                      RoundedInputField(
                        labelText: tr(LocaleKeys.email),
                        icon: Icons.email,
                        obsecureText: false,
                        hintText: tr(LocaleKeys.email),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        validator: (val) =>
                            val.isEmpty ? tr(LocaleKeys.enter_an_email) : null,
                      ),
                      RoundedInputField(
                        labelText: tr(LocaleKeys.password),
                        obsecureText: true,
                        icon: Icons.lock,
                        hintText: tr(LocaleKeys.password),
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        validator: (val) =>
                            val.length < 6 ? tr(LocaleKeys.password) : null,
                      ),
                      // Container(
                      //   width: size.width * 0.8,
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: InkWell(
                      //       onTap: () async {
                      //         // await _auth.signOut();
                      //         // Navigator.pushNamed(
                      //         //     context, ResetPassword.id);
                      //       },
                      //       child: Text(
                      //         'Forgot Password?',
                      //         style: TextStyle(
                      //           color: kPrimaryColor,
                      //           fontSize: size.height * 0.02,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: size.height * 0.03,
                      // ),
                      RoundedButton(
                        text: tr(LocaleKeys.login),
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            print(email + ' ' + password);
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = tr(LocaleKeys.couldnt_signin);
                                loading = false;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        },
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

  // void configureCallbacks() {
  //   messaging.configure(
  //     onMessage: (message) async {
  //       print('onMessage: $message');
  //     },
  //   );
  // }
}
