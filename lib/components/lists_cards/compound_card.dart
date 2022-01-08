import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/compound.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/compound_info.dart';
import 'package:unit/services/database.dart';
import 'package:intl/intl.dart';
import 'package:unit/translations/locale_keys.g.dart';

class CompoundCard extends StatefulWidget {
  const CompoundCard({
    Key key,
    this.compound,
  }) : super(key: key);

  final Compound compound;
  @override
  _CompoundCardState createState() => _CompoundCardState();
}

class _CompoundCardState extends State<CompoundCard> {
  bool isLiked = false;
  UserData userData;

  var f = NumberFormat("###,###", "en_US");

  Widget showDelete(double height, MyUser user) {
    if (user != null) {
      UserData userData = Provider.of<UserData>(context);
      if (userData != null) {
        if (userData.role == 'admin') {
          return ClipRRect(
            borderRadius: BorderRadius.circular(3000),
            child: GestureDetector(
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Deactivate Compound',
                  desc: 'Are your sure you want to deactivate this compound ?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    await DatabaseService().updateCompoundStatus(
                        compoundId: widget.compound.uid, status: 'inactive');
                  },
                )..show();
              },
              child: Container(
                color: kPrimaryLightColor,
                height: height * 0.05,
                width: height * 0.05,
                child: Icon(
                  FontAwesomeIcons.trash,
                  color: kSecondaryColor,
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);

    if (user == null) {
      userData = Provider.of<UserData>(context);
    }

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            CompoundInfo.id,
            arguments: {
              'compound': widget.compound,
              'user': userData,
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(width * 0.02),
          height: height * 0.3,
          width: width * 1,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            image: DecorationImage(
              image: widget.compound.images.isNotEmpty
                  ? NetworkImage(
                      widget.compound.images[0],
                    )
                  : AssetImage('assets/images/propertyPlaceholder.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: width * 0.04,
                top: height * 0.015,
                child: showDelete(height, user),
              ),
              Positioned(
                child: CircleAvatar(
                  radius: size.width * 0.12,
                  backgroundImage: widget.compound.logoURL != ''
                      ? NetworkImage(
                          widget.compound.logoURL,
                        )
                      : AssetImage('assets/images/userPlaceholder.png'),
                ),
              ),
              Positioned(
                bottom: 0,
                left: width * 0.01,
                right: width * 0.01,
                child: Container(
                  padding: EdgeInsets.all(width * 0.03),
                  // height: height * 0.1,
                  width: width * 0.85,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.locale == Locale('en')
                                ? '${widget.compound.name}'
                                : '${widget.compound.nameAr}',
                            style: TextStyle(
                              color: kPrimaryLightColor,
                              fontSize: height * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            context.locale == Locale('en')
                                ? '${widget.compound.locationLevel2}'
                                : '${widget.compound.districtAr}',
                            style: TextStyle(
                              color: kPrimaryLightColor,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.locale == Locale('en')
                                ? '${widget.compound.paymentPlan}'
                                : '${widget.compound.paymentPlanAr}',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${f.format(widget.compound.startingPrice)} ${tr(LocaleKeys.egp)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.022,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
