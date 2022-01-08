import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/loginSingupModalBottomSheet.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/property_info.dart';
import 'package:unit/services/database.dart';
import 'package:intl/intl.dart';
import 'package:unit/translations/locale_keys.g.dart';

class PropertyCard extends StatefulWidget {
  const PropertyCard({
    Key key,
    this.property,
  }) : super(key: key);

  final Property property;
  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool isLiked = false;

  Widget showStatus(double height, MyUser user, Property property) {
    Color color;
    if (property.status == 'active') color = Colors.green;
    if (property.status == 'pending') color = kSecondaryColor;
    if (property.status == 'denied') color = Colors.red;
    if (property.status == 'inactive') color = Colors.red;

    if (user != null) {
      if (user.uid == property.agent.uid) {
        return Text(
          property.status,
          style: TextStyle(
            color: color,
            fontSize: height * 0.02,
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget showDelete(double height, MyUser user, Property property) {
    if (user != null) {
      if (user.uid == property.agent.uid) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(3000),
          child: GestureDetector(
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Deactivate Property',
                desc: 'Are your sure you want to deactivate this property ?',
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  await DatabaseService().updatePropertyStatus(
                      propertyID: widget.property.uid, status: 'inactive');
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
  }

  Map unitTypesAr = {
    'Apartment': 'شقة',
    'Villa': 'فيلا',
    'Commercial/Administrative/Medical': 'تجاري / إداري / طبي',
    'Vacation': 'مصايف',
  };

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    UserData userData;
    if (user != null) {
      userData = Provider.of<UserData>(context);
    }

    if (userData != null) {
      isLiked = userData.likes.contains(widget.property.uid);
    }

    var f = NumberFormat("###,###", "en_US");

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
                right: width * 0.02,
                top: height * 0.015,
                child: Row(
                  children: [
                    showDelete(height, user, widget.property),
                    SizedBox(width: width * 0.04),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3000),
                      child: GestureDetector(
                        onTap: () async {
                          if (user != null) {
                            if (isLiked) {
                              userData.likes.remove(widget.property.uid);
                              await DatabaseService(uid: user.uid)
                                  .updateUserLikes(userData.likes);
                            } else {
                              userData.likes.add(widget.property.uid);
                              await DatabaseService(uid: user.uid)
                                  .updateUserLikes(userData.likes);
                            }
                          } else {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)),
                              ),
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.9,
                                  child: DraggableScrollableSheet(
                                    initialChildSize: 1.0,
                                    maxChildSize: 1.0,
                                    minChildSize: 0.25,
                                    builder: (BuildContext context,
                                        ScrollController scrollController) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter insideState) {
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
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: width * 0.005,
                right: width * 0.005,
                child: Container(
                  padding: EdgeInsets.all(width * 0.03),
                  // height: height * 0.12,
                  // width: width * 0.85,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.locale == Locale('en')
                                ? widget.property.propertyType
                                : unitTypesAr[widget.property.propertyType],
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.property.size} ${tr(LocaleKeys.sqm)}',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          showStatus(height, user, widget.property)
                        ],
                      ),
                      widget.property.listingType == 1
                          ? RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                  fontSize: height * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '${f.format(widget.property.price)} ${tr(LocaleKeys.egp)}',
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: height * 0.03,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // TextSpan(
                                  //   text:
                                  //       '      ${widget.property.size} ${tr(LocaleKeys.sqm)}',
                                  //   style: TextStyle(
                                  //     color: kPrimaryColor,
                                  //     fontSize: height * 0.02,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ],
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
                                      text:
                                          '${f.format(widget.property.price)} '),
                                  TextSpan(
                                    text:
                                        '${widget.property.rentType == 1 ? tr(LocaleKeys.egp_month) : tr(LocaleKeys.egp_day)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // TextSpan(
                                  //   text:
                                  //       ' - ${widget.property.size} ${tr(LocaleKeys.sqm)}',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: height * 0.02,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                      Text(
                        context.locale == Locale('en')
                            ? '${widget.property.area} , ${widget.property.district} , ${widget.property.governate}'
                            : '${widget.property.areaAr} , ${widget.property.districtAr} , ${widget.property.governateAr}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Icon(
                      //       FontAwesomeIcons.bed,
                      //       size: width * 0.05,
                      //       color: kPrimaryLightTextColor,
                      //     ),
                      //     SizedBox(
                      //       width: width * 0.04,
                      //     ),
                      //     Text(
                      //       '${widget.property.numBedrooms}',
                      //       style: TextStyle(
                      //         color: kPrimaryTextColor,
                      //         // fontSize: height * 0.02,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: width * 0.05,
                      //     ),
                      //     Icon(
                      //       FontAwesomeIcons.bath,
                      //       size: width * 0.05,
                      //       color: kPrimaryLightTextColor,
                      //     ),
                      //     SizedBox(
                      //       width: width * 0.04,
                      //     ),
                      //     Text(
                      //       '${widget.property.numBathrooms}',
                      //       style: TextStyle(
                      //         color: kPrimaryTextColor,
                      //         // fontSize: height * 0.02,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: width * 0.05,
                      //     ),
                      //     Icon(
                      //       FontAwesomeIcons.rulerCombined,
                      //       size: width * 0.05,
                      //       color: kPrimaryLightTextColor,
                      //     ),
                      //     SizedBox(
                      //       width: width * 0.04,
                      //     ),
                      //     Text(
                      //       '${widget.property.size} sqm',
                      //       style: TextStyle(
                      //         color: kPrimaryTextColor,
                      //         // fontSize: height * 0.02,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
