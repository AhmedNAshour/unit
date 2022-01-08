import 'package:flutter/material.dart';
import 'package:unit/constants.dart';

class ModalBottomSheetTabSelector extends StatelessWidget {
  const ModalBottomSheetTabSelector({
    Key key,
    @required this.selectedTab,
    this.state,
    this.changeSelectedTab,
    this.tabName,
    this.tabIndex,
  }) : super(key: key);

  final int selectedTab;
  final StateSetter state;
  final Function changeSelectedTab;
  final String tabName;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          state(() {
            changeSelectedTab(tabIndex);
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
            horizontal: size.width * 0.04,
          ),
          decoration: BoxDecoration(
            color: selectedTab == tabIndex ? kPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedTab == tabIndex
                  ? Colors.transparent
                  : kSecondaryColor,
            ),
          ),
          child: Center(
            child: Text(
              tabName,
              style: TextStyle(
                color:
                    selectedTab == tabIndex ? Colors.white : kPrimaryTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
