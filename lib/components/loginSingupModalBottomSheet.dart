import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unit/components/modalBottomSheetTabSelector.dart';
import 'package:unit/components/modalBottomSheetheader.dart';
import 'package:unit/screens/shared/login.dart';
import 'package:unit/screens/shared/signup.dart';
import 'package:unit/translations/locale_keys.g.dart';

class LoginSignupModalBottomSheet extends StatefulWidget {
  const LoginSignupModalBottomSheet({
    Key key,
    @required this.modalBottomSheetState,
  }) : super(key: key);

  // final int selectedTab;
  // final Function changeSelectedTab;
  final StateSetter modalBottomSheetState;

  @override
  _LoginSignupModalBottomSheetState createState() =>
      _LoginSignupModalBottomSheetState();
}

class _LoginSignupModalBottomSheetState
    extends State<LoginSignupModalBottomSheet> {
  int selectedTab = 0;
  changeSelectedTab(int newSelection) {
    selectedTab = newSelection;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ModalBottomSheetHeader(
          title: tr(LocaleKeys.login_signup),
          sizedBoxWidth: 0.22,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
          ),
          child: Row(
            children: [
              ModalBottomSheetTabSelector(
                tabIndex: 0,
                selectedTab: selectedTab,
                changeSelectedTab: changeSelectedTab,
                state: widget.modalBottomSheetState,
                tabName: tr(LocaleKeys.signup),
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              ModalBottomSheetTabSelector(
                tabIndex: 1,
                selectedTab: selectedTab,
                changeSelectedTab: changeSelectedTab,
                state: widget.modalBottomSheetState,
                tabName: tr(LocaleKeys.login),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Expanded(
          child: Container(
            child: selectedTab == 0 ? Signup() : Login(),
          ),
        ),
      ],
    );
  }
}
