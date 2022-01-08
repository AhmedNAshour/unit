import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unit/components/dateSelection_ModalBottomSheet.dart';
import 'package:unit/components/loginSingupModalBottomSheet.dart';
import 'package:unit/components/propertyImages-carousel.dart';
import 'package:unit/models/compound.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';
import 'package:unit/services/database.dart';
import 'package:intl/intl.dart';
import 'package:unit/translations/locale_keys.g.dart';
import 'openMap.dart';
import 'package:easy_localization/easy_localization.dart';

class CompoundInfo extends StatefulWidget {
  static const id = 'CompoundInfo';

  @override
  _CompoundInfoState createState() => _CompoundInfoState();
}

class _CompoundInfoState extends State<CompoundInfo> {
  Map compoundAndUserData = {};
  int selectedTab = 0;
  String dateSearch = '';
  var dateTextController = new TextEditingController();

  changeDateSearch(newDate) {
    setState(() {
      dateSearch = newDate;
    });
  }

  bool isLiked = false;

  Map facilities = {
    'Clubhouse': 'assets/images/cinema-svgrepo-com.svg',
    'FoodCourt': 'assets/images/food-court.svg',
    'Aquarium': 'assets/images/aquarium.svg',
    'Plaza': 'assets/images/green-park-city-space-svgrepo-com.svg',
    'Sky lounge': 'assets/images/sky-lounge.svg',
    'Coworking': 'assets/images/coworkingpng.svg',
    'Reception desk': 'assets/images/reception.svg',
    'Coffee corner': 'assets/images/coffe-corner.svg',
    'Gym & Spa': 'assets/images/dumbbell.svg',
    'Lakes': 'assets/images/swimming-silhouette-svgrepo-com.svg',
    'Commercial Area': 'assets/images/commercial-area.svg',
    'Security': 'assets/images/secure-svgrepo-com.svg',
    'Parking': 'assets/images/parking-svgrepo-com.svg',
    'Landscape': 'assets/images/green-park-city-space-svgrepo-com.svg',
    'Pets Allowed': 'assets/images/pets.svg',
    'Sports Club': 'assets/images/sports-club.svg',
    'Mosque': 'assets/images/mosque-svgrepo-com.svg',
    'Kids Area': 'assets/images/kids-couple-svgrepo-com.svg',
    'Cinema': 'assets/images/cinema-ticket-with-a-star-svgrepo-com.svg',
    'Medical Center': 'assets/images/medical-kit-svgrepo-com.svg',
    'School': 'assets/images/book-svgrepo-com.svg',
    'Pool': 'assets/images/swimming-silhouette-svgrepo-com.svg',
    'Hotel': 'assets/images/hotel-svgrepo-com.svg',
    'Private Beach': 'assets/images/beach-svgrepo-com.svg',
    'Strip Mall': 'assets/images/strip-mall.svg',
  };
  Map facilitiesAr = {
    'Clubhouse': 'نادي اجتماعي',
    'FoodCourt': 'منطقة مطاعم',
    'Aquarium': 'احواض سمكيه',
    'Coworking': 'ساحة عمل',
    'Plaza': 'بلازا',
    'Sky lounge': 'روف خدمي',
    'Reception desk': 'استقبال',
    'Coffee corner': 'ركن القهوة',
    'Gym & Spa': 'صالة رياضة',
    'Lakes': 'بحيرات',
    'Commercial Area': 'منطقة تجارية',
    'Security': 'امن',
    'Parking': 'جراج',
    'Landscape': 'مساحات خضراء',
    'Pets Allowed': 'يسمح بالحيوانات الاليفة',
    'Sports Club': 'نادي رياضي',
    'Mosque': 'مسجد',
    'Kids Area': 'كيدز اريا',
    'Cinema': 'سينما',
    'Medical Center': 'مركز طبي',
    'School': 'مدرسة',
    'Pool': 'حمام سباحة',
    'Hotel': 'فندق',
    'Private Beach': 'شاطئ خاص',
    'Strip Mall': 'مركز تسوق',
  };

  Map unitTypesAr = {
    'Standalone Villa': 'فيلا منفصلة',
    'Town house': 'تاون هاوس',
    'Twin house': 'توين هاوس',
    'Studio': 'ستوديو',
    'Apartment': 'شقة',
    'Hotel Apartment': 'وحدة فندقية',
    'Penthouse': 'روف',
    'Commercial': 'تجاري',
    'Medical': 'طبي',
    'Admin': 'إداري',
    'Duplex': 'دوبلكس',
  };

  String showDeliveryDate(String deliveryDate) {
    if (deliveryDate == 'Delivered') {
      return context.locale == Locale('en') ? 'Delivered' : 'استلام فوري';
    } else {
      return deliveryDate;
    }
  }

  Widget showBookingButton(
      UserData user, double width, double height, Compound compound) {
    if (user == null || user.role == 'client') {
      return RawMaterialButton(
        onPressed: () {
          if (user != null) {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter insideState) {
                  return DateSelectionForm(
                    changeDateSearch: changeDateSearch,
                    dateSearch: dateSearch,
                    compound: compound,
                    user: user,
                    sheetState: insideState,
                  );
                });
              },
              isScrollControlled: true,
            );
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
                          (BuildContext context, StateSetter insideState) {
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
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    compoundAndUserData = ModalRoute.of(context).settings.arguments;
    Compound compound = compoundAndUserData['compound'];
    UserData userData = compoundAndUserData['user'];

    var f = NumberFormat("###,###", "en_US");

    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              PropertyImages(
                images: compound.images,
              ),
              Positioned(
                top: height * 0.28,
                left: width * 0.06,
                child: CircleAvatar(
                  radius: size.width * 0.1,
                  backgroundImage: compound.logoURL != null
                      ? NetworkImage(
                          compound.logoURL,
                        )
                      : AssetImage(
                          'assets/images/userPlaceholder.png',
                        ),
                ),
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
              userData != null && userData.role == 'admin'
                  ? Positioned(
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
                                      'lat': compound.latitude,
                                      'long': compound.longitude,
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
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Deactivate Compound',
                                  desc:
                                      'Are your sure you want to deactivate this compound ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    await DatabaseService()
                                        .updatePropertyStatus(
                                            propertyID: compound.uid,
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
                      ),
                    )
                  : Positioned(
                      top: height * 0.02,
                      right: width * 0.05,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3000),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(context, MapOpen.id,
                                arguments: {
                                  'lat': compound.latitude,
                                  'long': compound.longitude,
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
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  height: size.height * 0.55,
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
                        // Text(
                        //   '${compound.meterPrice} EGP/sqm',
                        //   style: TextStyle(
                        //     color: kSecondaryColor,
                        //     fontSize: height * 0.025,
                        //   ),
                        // ),
                        Text(
                          context.locale == Locale('en')
                              ? '${compound.name}'
                              : '${compound.nameAr}',
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: height * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.locale == Locale('en')
                              ? '${compound.locationLevel2} , ${compound.locationLevel1}'
                              : '${compound.districtAr} , ${compound.governateAr}',
                          style: TextStyle(
                            color: kPrimaryLightTextColor,
                            fontSize: size.height * 0.025,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.018,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LocaleKeys.starting_price),
                                    style: TextStyle(
                                      color: kPrimaryLightTextColor,
                                      fontSize: size.height * 0.025,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    '${f.format(compound.startingPrice)} ${tr(LocaleKeys.egp)}',
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LocaleKeys.price_meter),
                                    style: TextStyle(
                                      color: kPrimaryLightTextColor,
                                      fontSize: size.height * 0.025,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    '${f.format(compound.meterPrice)} ${tr(LocaleKeys.egp)}',
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: height * 0.015),
                          height: height * 0.0001,
                          color: kPrimaryTextColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LocaleKeys.payment_plan),
                                    style: TextStyle(
                                      color: kPrimaryLightTextColor,
                                      fontSize: size.height * 0.025,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    context.locale == Locale('en')
                                        ? '${compound.paymentPlan}'
                                        : '${compound.paymentPlanAr}',
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LocaleKeys.delivery_date),
                                    style: TextStyle(
                                      color: kPrimaryLightTextColor,
                                      fontSize: size.height * 0.025,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    showDeliveryDate(compound.deliveryDate),
                                    style: TextStyle(
                                      color: kPrimaryTextColor,
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: height * 0.015),
                          height: height * 0.0001,
                          color: kPrimaryTextColor,
                        ),
                        Text(
                          tr(LocaleKeys.unit_types),
                          style: TextStyle(
                            color: kPrimaryLightTextColor,
                            fontSize: size.height * 0.025,
                          ),
                        ),
                        Container(
                          height: compound.propertyTypes.length > 3
                              ? size.height * 0.12
                              : size.height * 0.06,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 12 / 6,
                            ),
                            itemCount: compound.propertyTypes.length,
                            itemBuilder: (context, index) {
                              return compound.propertyTypes.isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.all(width * 0.01),
                                      padding: EdgeInsets.all(width * 0.01),
                                      decoration: BoxDecoration(
                                        color: kPrimaryLightColor,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: kPrimaryLightTextColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.locale == Locale('en')
                                              ? compound.propertyTypes[index]
                                              : unitTypesAr[compound
                                                  .propertyTypes[index]],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: kPrimaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: height * 0.015),
                          height: height * 0.0001,
                          color: kPrimaryTextColor,
                        ),
                        Text(
                          tr(LocaleKeys.facilities),
                          style: TextStyle(
                            color: kPrimaryLightTextColor,
                            fontSize: size.height * 0.025,
                          ),
                        ),
                        Container(
                          height: size.height * 0.135,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: compound.facilities.length,
                            itemBuilder: (context, index) {
                              return compound.facilities.isNotEmpty
                                  ? Padding(
                                      padding:
                                          EdgeInsets.all(size.width * 0.02),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            facilities[
                                                compound.facilities[index]],
                                            height: size.width * 0.12,
                                            width: size.width * 0.12,
                                            color: kPrimaryLightTextColor,
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Text(
                                            context.locale == Locale('en')
                                                ? compound.facilities[index]
                                                : facilitiesAr[
                                                    compound.facilities[index]],
                                            style: TextStyle(
                                              color: kPrimaryTextColor,
                                              fontSize: size.height * 0.018,
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
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: height * 0.015),
                          height: height * 0.0001,
                          color: kPrimaryTextColor,
                        ),
                        Text(
                          tr(LocaleKeys.developer_name),
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
                              compound.agentName,
                              style: TextStyle(
                                color: kPrimaryTextColor,
                                fontSize: size.height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: height * 0.015),
                          height: height * 0.0001,
                          color: kPrimaryTextColor,
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
                              context.locale == Locale('en')
                                  ? compound.description
                                  : compound.descriptionAr,
                              style: TextStyle(
                                color: kPrimaryTextColor,
                                fontSize: size.height * 0.02,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: height * 0.05,
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
          floatingActionButton:
              showBookingButton(userData, width, height, compound)),
    );
  }
}
