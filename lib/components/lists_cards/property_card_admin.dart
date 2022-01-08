import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/property_info.dart';
import 'package:unit/services/database.dart';
import 'package:intl/intl.dart';
import 'package:unit/translations/locale_keys.g.dart';

class AdminPropertyCard extends StatefulWidget {
  const AdminPropertyCard({
    Key key,
    this.property,
  }) : super(key: key);

  final Property property;

  @override
  _AdminPropertyCardState createState() => _AdminPropertyCardState();
}

class _AdminPropertyCardState extends State<AdminPropertyCard> {
  bool isLiked = false;
  Widget showStatus(String status, double height) {
    Color color;
    if (status == 'active') color = Colors.green;
    if (status == 'pending') color = kSecondaryColor;
    if (status == 'denied') color = Colors.red;
    if (status == 'inactive') color = Colors.red;

    return Text(
      status,
      style: TextStyle(
        color: color,
        fontSize: height * 0.02,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    UserData userData;
    var f = NumberFormat("###,###", "en_US");

    if (user != null) {
      userData = Provider.of<UserData>(context);
    }

    if (userData != null) {
      isLiked = userData.likes.contains(widget.property.uid);
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
            PropertyInfo.id,
            arguments: widget.property,
          );
        },
        child: Container(
          padding: EdgeInsets.all(width * 0.02),
          height: height * 0.3,
          width: width * 0.88,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            image: DecorationImage(
              image: widget.property.images.isNotEmpty
                  ? NetworkImage(
                      widget.property.images[0],
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
                child: widget.property.status != 'pending'
                    ? Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3000),
                            child: GestureDetector(
                              onTap: () async {
                                if (isLiked) {
                                  userData.likes.remove(widget.property.uid);
                                  await DatabaseService(uid: user.uid)
                                      .updateUserLikes(userData.likes);
                                } else {
                                  userData.likes.add(widget.property.uid);
                                  await DatabaseService(uid: user.uid)
                                      .updateUserLikes(userData.likes);
                                }
                              },
                              child: Container(
                                color: kPrimaryLightColor,
                                height: height * 0.05,
                                width: height * 0.05,
                                child: Icon(
                                  isLiked
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.04),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3000),
                            child: GestureDetector(
                              onTap: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Deactivate Property',
                                  desc:
                                      'Are your sure you want to deactivate this property ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    await DatabaseService()
                                        .updatePropertyStatus(
                                            propertyID: widget.property.uid,
                                            status: 'inactive');
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
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3000),
                            child: GestureDetector(
                              onTap: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Deny Request',
                                  desc:
                                      'Are your sure you want to deny this request ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    await DatabaseService()
                                        .updatePropertyStatus(
                                            propertyID: widget.property.uid,
                                            status: 'denied');
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
                          ),
                          SizedBox(width: width * 0.04),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3000),
                            child: GestureDetector(
                              onTap: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Accept Request',
                                  desc:
                                      'Are your sure you want to accept this request ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    await DatabaseService()
                                        .updatePropertyStatus(
                                            propertyID: widget.property.uid,
                                            status: 'active');
                                  },
                                )..show();
                              },
                              child: Container(
                                color: kPrimaryLightColor,
                                height: height * 0.05,
                                width: height * 0.05,
                                child: Icon(
                                  FontAwesomeIcons.check,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              Positioned(
                bottom: 0,
                left: width * 0.005,
                right: width * 0.005,
                child: Container(
                  padding: EdgeInsets.all(width * 0.03),
                  height: height * 0.16,
                  width: width * 0.88,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.property.propertyType,
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: height * 0.02,
                            ),
                          ),
                          showStatus(widget.property.status, height),
                        ],
                      ),
                      widget.property.listingType == 1
                          ? Text(
                              '${f.format(widget.property.price)} ${tr(LocaleKeys.egp)}',
                              style: TextStyle(
                                color: kPrimaryTextColor,
                                fontSize: height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                  fontSize: height * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${f.format(widget.property.price)}',
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${widget.property.rentType == 1 ? tr(LocaleKeys.egp_month) : tr(LocaleKeys.egp_day)}',
                                    style: TextStyle(
                                      color: kPrimaryLightTextColor,
                                      fontSize: height * 0.03,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                      Text(
                        '${widget.property.area} , ${widget.property.district} , ${widget.property.governate}',
                        style: TextStyle(
                          color: kPrimaryLightTextColor,
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            FontAwesomeIcons.bed,
                            size: width * 0.05,
                            color: kPrimaryLightTextColor,
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Text(
                            '${widget.property.numBedrooms}',
                            style: TextStyle(
                              color: kPrimaryTextColor,
                              // fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Icon(
                            FontAwesomeIcons.bath,
                            size: width * 0.05,
                            color: kPrimaryLightTextColor,
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Text(
                            '${widget.property.numBathrooms}',
                            style: TextStyle(
                              color: kPrimaryTextColor,
                              // fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Icon(
                            FontAwesomeIcons.rulerCombined,
                            size: width * 0.05,
                            color: kPrimaryLightTextColor,
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Text(
                            '${widget.property.size} sqm',
                            style: TextStyle(
                              color: kPrimaryTextColor,
                              // fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
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
