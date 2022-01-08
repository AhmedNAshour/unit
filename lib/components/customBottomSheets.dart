import 'package:flutter/material.dart';
import 'package:unit/components/loginSingupModalBottomSheet.dart';

class CustomBottomSheets {
  Future showCustomBottomSheet(Size size, Widget child, BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: DraggableScrollableSheet(
            initialChildSize: 1.0,
            maxChildSize: 1.0,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter insideState) {
                return child;
              });
            },
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  Future showLoginSignupBottomSheet(Size size, BuildContext context,
      int selectedTab, Function changeSelectedTab) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: DraggableScrollableSheet(
            initialChildSize: 1.0,
            maxChildSize: 1.0,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter insideState) {
                return LoginSignupModalBottomSheet(
                  modalBottomSheetState: insideState,
                );
              });
            },
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
