import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/dateSelection_ModalBottomSheet.dart';
import 'package:unit/components/lists_cards/user_card.dart';
import 'package:unit/components/loginSingupModalBottomSheet.dart';
import 'package:unit/components/propertyImages-carousel.dart';
import 'package:unit/models/property.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/database.dart';
import 'package:unit/translations/locale_keys.g.dart';
import 'openMap.dart';
import 'package:intl/intl.dart';

class PropertyInfo extends StatefulWidget {
  static const id = 'PropertyInfo';

  @override
  _PropertyInfoState createState() => _PropertyInfoState();
}

class _PropertyInfoState extends State<PropertyInfo> {
  Property property;
  int selectedTab = 0;
  String dateSearch = '';
  var dateTextController = new TextEditingController();

  changeDateSearch(newDate) {
    setState(() {
      dateSearch = newDate;
    });
  }

  bool isLiked = false;

  Map amenities = {
    'Kitchen Appliances': 'assets/images/kitchen.svg',
    'Private Garden': 'assets/images/garden-svgrepo-com.svg',
    'Central A/C': 'assets/images/air-conditioner-svgrepo-com.svg',
    'Security': 'assets/images/secure-svgrepo-com.svg',
    'Parking': 'assets/images/parking-svgrepo-com.svg',
    'Maids Room': 'assets/images/kitchen-apron-svgrepo-com.svg',
    'Pets Allowed': 'assets/images/pets.svg',
    'Private Pool': 'assets/images/swimming-silhouette-svgrepo-com.svg',
    'Elevator': 'assets/images/elevator-svgrepo-com.svg',
    'Furnished': 'assets/images/sofa.svg',
    'Private Entrance': 'assets/images/gate.svg',
  };

  Map amenitiesAr = {
    'Kitchen Appliances': 'مطبخ',
    'Private Garden': 'حديقة خاصة',
    'Central A/C': 'تكييف مركزي',
    'Security': 'امن',
    'Parking': 'جراج',
    'Maids Room': 'غرفة للمساعدة',
    'Pets Allowed': 'يسمح بالحيوانات الاليفة',
    'Private Pool': 'حمام سباحة خاص',
    'Elevator': 'مصعد',
    'Furnished': 'مفروش',
    'Private Entrance': 'مدخل خاص',
  };

  Map finishingTypeAr = {
    'Finished': 'متشطب',
    'Semi-Finished': 'نصف تشطيب',
    'Core & Shell': 'طوب احمر',
  };
  Map unitTypesAr = {
    'Apartment': 'شقة',
    'Villa': 'فيلا',
    'Commercial/Administrative/Medical': 'تجاري / إداري / طبي',
    'Vacation': 'مصايف',
  };

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    property = ModalRoute.of(context).settings.arguments;
    var f = NumberFormat("###,###", "en_US");

    return user != null
        ? StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                isLiked = userData.likes.contains(property.uid);
                return SafeArea(
                  child: Scaffold(
                    body: Stack(
                      children: [
                        PropertyImages(
                          images: property.images,
                        ),
                        Positioned(
                          top: height * 0.02,
                          left: width * 0.05,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3000),
                            child: Container(
                              color: kPrimaryLightColor,
                              height: height * 0.05,
                              width: height * 0.05,
                              child: BackButton(
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: height * 0.02,
                          right: width * 0.05,
                          child: userData.role != 'admin'
                              ? Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3000),
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.pushNamed(
                                              context, MapOpen.id,
                                              arguments: {
                                                'lat': property.latitude,
                                                'long': property.longitude,
                                              });
                                        },
                                        child: Container(
                                          color: kPrimaryLightColor,
                                          height: height * 0.05,
                                          width: height * 0.05,
                                          child: Icon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            color: kSecondaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3000),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (isLiked) {
                                            userData.likes.remove(property.uid);
                                            await DatabaseService(uid: user.uid)
                                                .updateUserLikes(
                                                    userData.likes);
                                          } else {
                                            userData.likes.add(property.uid);
                                            await DatabaseService(uid: user.uid)
                                                .updateUserLikes(
                                                    userData.likes);
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
                                )
                              : property.status != 'pending'
                                  ? Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3000),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (isLiked) {
                                                userData.likes
                                                    .remove(property.uid);
                                                await DatabaseService(
                                                        uid: user.uid)
                                                    .updateUserLikes(
                                                        userData.likes);
                                              } else {
                                                userData.likes
                                                    .add(property.uid);
                                                await DatabaseService(
                                                        uid: user.uid)
                                                    .updateUserLikes(
                                                        userData.likes);
                                              }
                                            },
                                            child: Container(
                                              color: kPrimaryLightColor,
                                              height: height * 0.05,
                                              width: height * 0.05,
                                              child: Icon(
                                                isLiked
                                                    ? FontAwesomeIcons
                                                        .solidHeart
                                                    : FontAwesomeIcons.heart,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width * 0.02),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3000),
                                          child: GestureDetector(
                                            onTap: () async {
                                              Navigator.pushNamed(
                                                  context, MapOpen.id,
                                                  arguments: {
                                                    'lat': property.latitude,
                                                    'long': property.longitude,
                                                  });
                                            },
                                            child: Container(
                                              color: kPrimaryLightColor,
                                              height: height * 0.05,
                                              width: height * 0.05,
                                              child: Icon(
                                                FontAwesomeIcons.mapMarkerAlt,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3000),
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
                                                          propertyID:
                                                              property.uid,
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
                                          borderRadius:
                                              BorderRadius.circular(3000),
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
                                                          propertyID:
                                                              property.uid,
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
                                          borderRadius:
                                              BorderRadius.circular(3000),
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
                                                          propertyID:
                                                              property.uid,
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
                            height: size.height * 0.50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(53),
                                  topRight: Radius.circular(53)),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.locale == Locale('en')
                                        ? property.propertyType
                                        : unitTypesAr[property.propertyType],
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: height * 0.025,
                                    ),
                                  ),
                                  property.listingType == 1
                                      ? Text(
                                          '${f.format(property.price)} ${tr(LocaleKeys.egp)}',
                                          style: TextStyle(
                                            color: kPrimaryTextColor,
                                            fontSize: height * 0.05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: kPrimaryTextColor,
                                              fontSize: height * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      '${f.format(property.price)}'),
                                              TextSpan(
                                                text:
                                                    ' ${property.rentType == 1 ? tr(LocaleKeys.egp_month) : tr(LocaleKeys.egp_day)}',
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
                                    context.locale == Locale('en')
                                        ? '${property.area} , ${property.district} , ${property.governate}'
                                        : '${property.areaAr} , ${property.districtAr} , ${property.governateAr}',
                                    style: TextStyle(
                                      color: kPrimaryLightTextColor,
                                      fontSize: height * 0.03,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.bed,
                                              size: width * 0.06,
                                              color: kPrimaryLightTextColor,
                                            ),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            Text(
                                              '${property.numBedrooms}',
                                              style: TextStyle(
                                                color: kPrimaryTextColor,
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.bath,
                                              size: width * 0.06,
                                              color: kPrimaryLightTextColor,
                                            ),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            Text(
                                              '${property.numBathrooms}',
                                              style: TextStyle(
                                                color: kPrimaryTextColor,
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.rulerCombined,
                                              size: width * 0.06,
                                              color: kPrimaryLightTextColor,
                                            ),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            Text(
                                              '${property.size} ${tr(LocaleKeys.sqm)}',
                                              style: TextStyle(
                                                color: kPrimaryTextColor,
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.checkCircle,
                                              size: width * 0.06,
                                              color: kPrimaryLightTextColor,
                                            ),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            Text(
                                              context.locale == Locale('en')
                                                  ? property.finishingType
                                                  : finishingTypeAr[
                                                      property.finishingType],
                                              style: TextStyle(
                                                color: kPrimaryTextColor,
                                                fontSize: width * 0.043,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  // property.listingType == 1
                                  //     ? Container(
                                  //         margin: EdgeInsets.symmetric(
                                  //             vertical: height * 0.02),
                                  //         height: height * 0.0001,
                                  //         color: kPrimaryTextColor,
                                  //       )
                                  //     : Container(),
                                  // Text(
                                  //   'Amenities',
                                  //   style: TextStyle(
                                  //     color: kPrimaryLightTextColor,
                                  //     fontSize: size.height * 0.025,
                                  //   ),
                                  // ),
                                  // Container(
                                  //   margin: EdgeInsets.symmetric(
                                  //       vertical: height * 0.02),
                                  //   height: height * 0.0001,
                                  //   color: kPrimaryTextColor,
                                  // ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Container(
                                    height: size.height * 0.16,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.zero,
                                      itemCount: property.amenities.length,
                                      itemBuilder: (context, index) {
                                        return property.amenities.isNotEmpty
                                            ? Padding(
                                                padding: EdgeInsets.all(
                                                    size.width * 0.04),
                                                child: Column(
                                                  children: [
                                                    SvgPicture.asset(
                                                      amenities[property
                                                          .amenities[index]],
                                                      height: size.width * 0.14,
                                                      width: size.width * 0.14,
                                                      color:
                                                          kPrimaryLightTextColor,
                                                    ),
                                                    SizedBox(
                                                        height: size.height *
                                                            0.003),
                                                    Text(
                                                      context.locale ==
                                                              Locale('en')
                                                          ? property
                                                              .amenities[index]
                                                          : amenitiesAr[property
                                                                  .amenities[
                                                              index]],
                                                      style: TextStyle(
                                                        color:
                                                            kPrimaryLightTextColor,
                                                        fontSize:
                                                            size.height * 0.019,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: height * 0.02),
                                          height: height * 0.0001,
                                          color: kPrimaryTextColor,
                                        )
                                      : Container(),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? Text(
                                          'Additional Info',
                                          style: TextStyle(
                                            color: kPrimaryLightTextColor,
                                            fontSize: size.height * 0.025,
                                          ),
                                        )
                                      : Container(),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? SizedBox(
                                          height: height * 0.01,
                                        )
                                      : Container(),
                                  Container(
                                    // height: height * 0.15,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        property.additionalInfo,
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: size.height * 0.02,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    tr(LocaleKeys.description),
                                    style: TextStyle(
                                      color: kPrimaryLightTextColor,
                                      fontSize: size.height * 0.025,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    // height: height * 0.15,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        property.description,
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: size.height * 0.02,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: height * 0.02),
                                          height: height * 0.0001,
                                          color: kPrimaryTextColor,
                                        )
                                      : Container(),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? Text(
                                          'Listing Agent',
                                          style: TextStyle(
                                            color: kPrimaryTextColor,
                                            fontSize: size.height * 0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Container(),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? SizedBox(
                                          height: height * 0.01,
                                        )
                                      : Container(),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? UserCard(user: property.agent)
                                      : Container(),
                                  userData.role == 'admin' ||
                                          userData.role == 'salesman'
                                      ? SizedBox(
                                          height: height * 0.02,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton:
                        userData.role == 'admin' || userData.role == 'salesman'
                            ? null
                            : RawMaterialButton(
                                onPressed: () async {
                                  if (user != null) {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0)),
                                      ),
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter insideState) {
                                          return DateSelectionForm(
                                            sheetState: insideState,
                                            changeDateSearch: changeDateSearch,
                                            dateSearch: dateSearch,
                                            property: property,
                                            user: userData,
                                          );
                                        });
                                      },
                                      isScrollControlled: true,
                                    );
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0)),
                                      ),
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter insideState) {
                                          return LoginSignupModalBottomSheet(
                                            modalBottomSheetState: insideState,
                                          );
                                        });
                                      },
                                      isScrollControlled: true,
                                    );
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    height: height * 0.06,
                                    width: width * 0.3,
                                    color: Color(0xFFff2800),
                                    child: Center(
                                      child: Text(
                                        tr(LocaleKeys.book),
                                        style: TextStyle(
                                          color: kPrimaryLightColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.05,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                  ),
                );
              } else {
                return Loading();
              }
            })
        : SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  PropertyImages(
                    images: property.images,
                  ),
                  Positioned(
                    top: height * 0.02,
                    left: width * 0.05,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3000),
                      child: Container(
                        color: kPrimaryLightColor,
                        height: height * 0.05,
                        width: height * 0.05,
                        child: BackButton(
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.02,
                    right: width * 0.05,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3000),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, MapOpen.id,
                                  arguments: {
                                    'lat': property.latitude,
                                    'long': property.longitude,
                                  });
                            },
                            child: Container(
                              color: kPrimaryLightColor,
                              height: height * 0.05,
                              width: height * 0.05,
                              child: Icon(
                                FontAwesomeIcons.mapMarkerAlt,
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3000),
                          child: GestureDetector(
                            onTap: () {
                              if (user != null) {
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
                                              modalBottomSheetState:
                                                  insideState,
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
                                FontAwesomeIcons.heart,
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      height: size.height * 0.50,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(53),
                            topRight: Radius.circular(53)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.locale == Locale('en')
                                  ? property.propertyType
                                  : unitTypesAr[property.propertyType],
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: height * 0.025,
                              ),
                            ),
                            property.listingType == 1
                                ? Text(
                                    '${f.format(property.price)} ${tr(LocaleKeys.egp)}',
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: height * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: kPrimaryTextColor,
                                        fontSize: height * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${f.format(property.price)}',
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${property.rentType == 1 ? tr(LocaleKeys.egp_month) : tr(LocaleKeys.egp_day)}',
                                          style: TextStyle(
                                            color: kPrimaryLightTextColor,
                                            fontSize: height * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            Text(
                              context.locale == Locale('en')
                                  ? '${property.area} , ${property.district} , ${property.governate}'
                                  : '${property.areaAr} , ${property.districtAr} , ${property.governateAr}',
                              style: TextStyle(
                                color: kPrimaryLightTextColor,
                                fontSize: height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.bed,
                                        size: width * 0.06,
                                        color: kPrimaryLightTextColor,
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Text(
                                        '${property.numBedrooms}',
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.bath,
                                        size: width * 0.06,
                                        color: kPrimaryLightTextColor,
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Text(
                                        '${property.numBathrooms}',
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.rulerCombined,
                                        size: width * 0.06,
                                        color: kPrimaryLightTextColor,
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Text(
                                        '${property.size} ${tr(LocaleKeys.sqm)}',
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Expanded(
                                    child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.checkCircle,
                                      size: width * 0.06,
                                      color: kPrimaryLightTextColor,
                                    ),
                                    SizedBox(
                                      width: width * 0.04,
                                    ),
                                    Text(
                                      property.finishingType,
                                      style: TextStyle(
                                        color: kPrimaryTextColor,
                                        fontSize: width * 0.043,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            // Container(
                            //   margin:
                            //       EdgeInsets.symmetric(vertical: height * 0.02),
                            //   height: height * 0.0001,
                            //   color: kPrimaryTextColor,
                            // ),
                            //  Container(),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            // Text(
                            //   'Amenities',
                            //   style: TextStyle(
                            //     color: kPrimaryLightTextColor,
                            //     fontSize: size.height * 0.025,
                            //   ),
                            // ),
                            Container(
                              height: size.height * 0.13,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                itemCount: property.amenities.length,
                                itemBuilder: (context, index) {
                                  return property.amenities.isNotEmpty
                                      ? Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.02),
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                amenities[
                                                    property.amenities[index]],
                                                height: size.width * 0.14,
                                                width: size.width * 0.14,
                                                color: kPrimaryLightTextColor,
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.003),
                                              Text(
                                                context.locale == Locale('en')
                                                    ? property.amenities[index]
                                                    : amenitiesAr[property
                                                        .amenities[index]],
                                                style: TextStyle(
                                                  color: kPrimaryLightTextColor,
                                                  fontSize: size.height * 0.019,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container();
                                },
                              ),
                            ),

                            Text(
                              tr(LocaleKeys.description),
                              style: TextStyle(
                                color: kPrimaryLightTextColor,
                                fontSize: size.height * 0.025,
                              ),
                            ),

                            Container(
                              // height: height * 0.15,
                              child: SingleChildScrollView(
                                child: Text(
                                  property.description,
                                  style: TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: size.height * 0.02,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: RawMaterialButton(
                onPressed: () {
                  if (user != null) {
                  } else {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      ),
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.8,
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
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: height * 0.06,
                    width: width * 0.3,
                    color: Color(0xFFff2800),
                    child: Center(
                      child: Text(
                        tr(LocaleKeys.book),
                        style: TextStyle(
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
