import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/forms/rounded_input_field.dart';
import 'package:unit/components/forms/text_field_container.dart';
import 'package:unit/components/offers-carousel.dart';
import 'package:unit/screens/shared/added.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/database.dart';
import 'dart:io';
import 'package:unit/constants.dart';
import 'package:smart_select/smart_select.dart';
import 'package:geocoder/geocoder.dart' as geoco;
import 'package:geolocator/geolocator.dart' as go;
import 'package:intl/intl.dart';

class AdminAddCompound extends StatefulWidget {
  static const id = 'AddCompound';
  @override
  _AdminAddCompoundState createState() => _AdminAddCompoundState();
}

class _AdminAddCompoundState extends State<AdminAddCompound> {
  // AuthService _auth = AuthService();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position currentPosition;
  var geoLocator = Geolocator();
  GoogleMapController newGoogleMapContoller;

  // text field state
  bool delivered = true;
  String name = '';
  String nameAr = '';
  String agentName = '';
  String location = '';
  String description = '';
  String descriptionAr = '';
  String meterPrice = '';
  String startingPrice = '';
  String finishingType = 'Finished';
  String paymentPlan = '';
  String paymentPlanAr = '';
  String error = '';
  String deliveryDate = '';
  String unitTypes = '';
  String unitsAndAreas = '';
  bool offer = false;
  String pictures = '';
  bool loading = false;
  List<File> images = <File>[];
  List<String> imagesURLs = <String>[];
  String logoURL = '';
  File logoFile;
  bool added = false;

  Future getLogo() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      logoFile = File(tempImage.path);
    });
  }

  Future getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      setState(() {
        images = result.paths.map((path) => File(path)).toList();
      });
    } else {
      // User canceled the picker
    }
  }

  Map locationData = {};

  final _formKey = GlobalKey<FormState>();

  List<String> value = ['Standalone Villa'];
  List<S2Choice<String>> frameworks = [
    S2Choice<String>(value: 'Standalone Villa', title: 'Standalone Villa'),
    S2Choice<String>(value: 'Town house', title: 'Town house'),
    S2Choice<String>(value: 'Twin house', title: 'Twin house'),
    S2Choice<String>(value: 'Studio', title: 'Studio'),
    S2Choice<String>(value: 'Apartment', title: 'Apartment'),
    S2Choice<String>(value: 'Hotel Apartment', title: 'Hotel Apartment'),
    S2Choice<String>(value: 'Penthouse', title: 'Penthouse'),
    S2Choice<String>(value: 'Commercial', title: 'Commercial'),
    S2Choice<String>(value: 'Medical', title: 'Medical'),
    S2Choice<String>(value: 'Admin', title: 'Admin'),
    S2Choice<String>(value: 'Duplex', title: 'Duplex'),
  ];

  List<String> amenitiesValue = ['Clubhouse'];
  List<S2Choice<String>> amenities = [
    S2Choice<String>(value: 'Clubhouse', title: 'Clubhouse'),
    S2Choice<String>(value: 'FoodCourt', title: 'FoodCourt'),
    S2Choice<String>(value: 'Aquarium', title: 'Aquarium'),
    S2Choice<String>(value: 'Plaza', title: 'Plaza'),
    S2Choice<String>(value: 'Sky lounge', title: 'Sky lounge'),
    S2Choice<String>(value: 'Reception desk', title: 'Reception desk'),
    S2Choice<String>(value: 'Coffee corner', title: 'Coffee corner'),
    S2Choice<String>(value: 'Coworking', title: 'Coworking'),
    S2Choice<String>(value: 'Gym & Spa', title: 'Gym & Spa'),
    S2Choice<String>(value: 'Lakes', title: 'Lakes'),
    S2Choice<String>(value: 'Commercial Area', title: 'Commercial Area'),
    S2Choice<String>(value: 'Security', title: 'Security'),
    S2Choice<String>(value: 'Parking', title: 'Parking'),
    S2Choice<String>(value: 'Landscape', title: 'Landscape'),
    S2Choice<String>(value: 'Pets Allowed', title: 'Pets Allowed'),
    S2Choice<String>(value: 'Sports Club', title: 'Sports Club'),
    S2Choice<String>(value: 'Mosque', title: 'Mosque'),
    S2Choice<String>(value: 'Kids Area', title: 'Kids Area'),
    S2Choice<String>(value: 'Cinema', title: 'Cinema'),
    S2Choice<String>(value: 'Medical Center', title: 'Medical Center'),
    S2Choice<String>(value: 'School', title: 'School'),
    S2Choice<String>(value: 'Pool', title: 'Pool'),
    S2Choice<String>(value: 'Hotel', title: 'Hotel'),
    S2Choice<String>(value: 'Private Beach', title: 'Private Beach'),
    S2Choice<String>(value: 'Strip Mall', title: 'Strip Mall'),
  ];

  var dateTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    locationData = ModalRoute.of(context).settings.arguments;
    CameraPosition selectedPosition = CameraPosition(
      target: LatLng(locationData['latitude'], locationData['longitude']),
      zoom: 14.4746,
    );
    return added
        ? Added('Compound')
        : loading
            ? Loading()
            : SafeArea(
                child: Scaffold(
                  body: Stack(
                    children: [
                      OffersCarousel(
                        images: images,
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
                        top: height * 0.3,
                        left: width * 0.06,
                        child: CircleAvatar(
                          radius: size.width * 0.10,
                          backgroundImage: logoFile != null
                              ? FileImage(logoFile)
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
                                    getLogo();
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
                      ),
                      Positioned(
                        top: height * 0.02,
                        right: width * 0.05,
                        child: GestureDetector(
                          onTap: () async {
                            await getImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3000),
                            child: Container(
                              color: kPrimaryLightColor,
                              height: height * 0.05,
                              width: height * 0.05,
                              child: Icon(
                                FontAwesomeIcons.camera,
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                          width: double.infinity,
                          height: size.height * 0.53,
                          decoration: BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(53),
                                topRight: Radius.circular(53)),
                          ),
                          child: Container(
                            // height: size.height * 0.5,
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.2,
                                      child: GoogleMap(
                                        mapType: MapType.terrain,
                                        myLocationEnabled: true,
                                        zoomGesturesEnabled: true,
                                        zoomControlsEnabled: true,
                                        initialCameraPosition: selectedPosition,
                                        markers: Set<Marker>.of(markers.values),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          offer = !offer;
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
                                          color: delivered == true
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: delivered == true
                                                ? Colors.transparent
                                                : kSecondaryColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            offer == true
                                                ? 'Offer'
                                                : 'Compound',
                                            style: TextStyle(
                                              color: delivered == true
                                                  ? Colors.white
                                                  : kPrimaryTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: FontAwesomeIcons.pen,
                                      hintText: 'Name',
                                      onChanged: (val) {
                                        setState(() => name = val);
                                      },
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter a name' : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: FontAwesomeIcons.pen,
                                      hintText: 'Name in Arabic',
                                      onChanged: (val) {
                                        setState(() => nameAr = val);
                                      },
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter a name' : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: FontAwesomeIcons.pen,
                                      hintText: 'Agent name',
                                      onChanged: (val) {
                                        setState(() => agentName = val);
                                      },
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter a name' : null,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Description',
                                          labelStyle: TextStyle(
                                            color: kPrimaryLightTextColor,
                                          ),
                                          icon: Icon(
                                            FontAwesomeIcons.infoCircle,
                                            color: kPrimaryLightTextColor,
                                          ),
                                          hintText: 'Description',
                                          focusColor: kPrimaryColor,
                                        ),
                                        onChanged: (val) {
                                          setState(() => description = val);
                                        },
                                        validator: (val) => val.isEmpty
                                            ? 'Enter a description'
                                            : null,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Description Ar',
                                          labelStyle: TextStyle(
                                            color: kPrimaryLightTextColor,
                                          ),
                                          icon: Icon(
                                            FontAwesomeIcons.infoCircle,
                                            color: kPrimaryLightTextColor,
                                          ),
                                          hintText: 'Description Ar',
                                          focusColor: kPrimaryColor,
                                        ),
                                        onChanged: (val) {
                                          setState(() => descriptionAr = val);
                                        },
                                        validator: (val) => val.isEmpty
                                            ? 'Enter a description'
                                            : null,
                                      ),
                                    ),
                                    RoundedInputField(
                                      textInputType: TextInputType.number,
                                      obsecureText: false,
                                      icon: FontAwesomeIcons.moneyBillAlt,
                                      hintText: 'Meter Price',
                                      onChanged: (val) {
                                        setState(() => meterPrice = val);
                                      },
                                      validator: (val) => val.isEmpty ||
                                              double.tryParse(val) == null
                                          ? 'Enter a valid price'
                                          : null,
                                    ),
                                    RoundedInputField(
                                      textInputType: TextInputType.number,
                                      obsecureText: false,
                                      icon: FontAwesomeIcons.moneyBillAlt,
                                      hintText: 'Starting Price',
                                      onChanged: (val) {
                                        setState(() => startingPrice = val);
                                      },
                                      validator: (val) => val.isEmpty ||
                                              double.tryParse(val) == null
                                          ? 'Enter a valid price'
                                          : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: FontAwesomeIcons.pen,
                                      hintText: 'Payment Plan',
                                      onChanged: (val) {
                                        setState(() => paymentPlan = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? 'Enter an installement plan'
                                          : null,
                                    ),
                                    RoundedInputField(
                                      obsecureText: false,
                                      icon: FontAwesomeIcons.pen,
                                      hintText: 'Payment Plan in Arabic',
                                      onChanged: (val) {
                                        setState(() => paymentPlanAr = val);
                                      },
                                      validator: (val) => val.isEmpty
                                          ? 'Enter an installement plan'
                                          : null,
                                    ),
                                    // RoundedInputField(
                                    //   obsecureText: false,
                                    //   icon: FontAwesomeIcons.ruler,
                                    //   hintText: 'Units & Areas',
                                    //   onChanged: (val) {
                                    //     setState(() => unitsAndAreas = val);
                                    //   },
                                    //   validator: (val) => val.isEmpty
                                    //       ? 'Enter available units & areas'
                                    //       : null,
                                    // ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                delivered = !delivered;
                                                if (delivered == true) {
                                                  deliveryDate = 'Delivered';
                                                }
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
                                                color: delivered == true
                                                    ? kPrimaryColor
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: delivered == true
                                                      ? Colors.transparent
                                                      : kSecondaryColor,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Delivered',
                                                  style: TextStyle(
                                                    color: delivered == true
                                                        ? Colors.white
                                                        : kPrimaryTextColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.04,
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: !delivered
                                                    ? kSecondaryColor
                                                    : kPrimaryLightTextColor,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    delivered == false
                                                        ? showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate:
                                                                DateTime(2020),
                                                            lastDate:
                                                                DateTime(2030),
                                                          )
                                                            .then(
                                                                (value) =>
                                                                    setState(
                                                                        () {
                                                                      if (value ==
                                                                          null) {
                                                                        deliveryDate =
                                                                            '';
                                                                        dateTextController.text =
                                                                            '';
                                                                      } else {
                                                                        deliveryDate =
                                                                            DateFormat('yyyy').format(value);
                                                                        dateTextController
                                                                            .text = DateFormat(
                                                                                'yyyy')
                                                                            .format(value);
                                                                      }
                                                                    }))
                                                        : null;
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .calendar_today_rounded,
                                                    color: !delivered
                                                        ? kSecondaryColor
                                                        : kPrimaryLightTextColor,
                                                  ),
                                                ),
                                                Text(
                                                  deliveryDate,
                                                  style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: size.width * 0.04,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height * 0.02),
                                    SmartSelect<String>.multiple(
                                      title: 'Facilities',
                                      value: amenitiesValue,
                                      choiceItems: amenities,
                                      onChange: (state) => setState(() {
                                        amenitiesValue = state.value;
                                      }),
                                      modalType: S2ModalType.popupDialog,
                                      choiceType: S2ChoiceType.chips,
                                    ),
                                    SizedBox(height: height * 0.02),
                                    SmartSelect<String>.multiple(
                                      title: 'Units types',
                                      value: value,
                                      choiceItems: frameworks,
                                      onChange: (state) => setState(() {
                                        value = state.value;
                                        print(value);
                                      }),
                                      modalType: S2ModalType.popupDialog,
                                      choiceType: S2ChoiceType.chips,
                                    ),
                                    SizedBox(height: height * 0.02),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: GestureDetector(
                                    //         onTap: () {
                                    //           setState(() {
                                    //             finishingType = 'Finished';
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           // width: size.width * 0.35,
                                    //           // height: size.height * 0.07,
                                    //           padding: EdgeInsets.symmetric(
                                    //             vertical: size.height * 0.02,
                                    //             horizontal: size.width * 0.04,
                                    //           ),
                                    //           decoration: BoxDecoration(
                                    //             color: finishingType == 'Finished'
                                    //                 ? kPrimaryColor
                                    //                 : Colors.white,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //             border: Border.all(
                                    //               color:
                                    //                   finishingType == 'Finished'
                                    //                       ? Colors.transparent
                                    //                       : kPrimaryLightColor,
                                    //             ),
                                    //           ),
                                    //           child: Center(
                                    //             child: Text(
                                    //               'Finished',
                                    //               style: TextStyle(
                                    //                 color: finishingType ==
                                    //                         'Finished'
                                    //                     ? Colors.white
                                    //                     : kPrimaryTextColor,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: size.width * 0.02,
                                    //     ),
                                    //     Expanded(
                                    //       child: GestureDetector(
                                    //         onTap: () {
                                    //           setState(() {
                                    //             finishingType = 'Semi-Finished';
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           // width: size.width * 0.35,
                                    //           // height: size.height * 0.07,
                                    //           padding: EdgeInsets.symmetric(
                                    //             vertical: size.height * 0.02,
                                    //             horizontal: size.width * 0.04,
                                    //           ),
                                    //           decoration: BoxDecoration(
                                    //             color: finishingType ==
                                    //                     'Semi-Finished'
                                    //                 ? kPrimaryColor
                                    //                 : Colors.white,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //             border: Border.all(
                                    //               color: finishingType ==
                                    //                       'Semi-Finished'
                                    //                   ? Colors.transparent
                                    //                   : kPrimaryLightColor,
                                    //             ),
                                    //           ),
                                    //           child: Center(
                                    //             child: Text(
                                    //               'Semi-Finished',
                                    //               style: TextStyle(
                                    //                 color: finishingType ==
                                    //                         'Semi-Finished'
                                    //                     ? Colors.white
                                    //                     : kPrimaryTextColor,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: size.width * 0.02,
                                    //     ),
                                    //     Expanded(
                                    //       child: GestureDetector(
                                    //         onTap: () {
                                    //           setState(() {
                                    //             finishingType = 'UnFinished';
                                    //           });
                                    //         },
                                    //         child: Container(
                                    //           // width: size.width * 0.35,
                                    //           // height: size.height * 0.07,
                                    //           padding: EdgeInsets.symmetric(
                                    //             vertical: size.height * 0.02,
                                    //             horizontal: size.width * 0.04,
                                    //           ),
                                    //           decoration: BoxDecoration(
                                    //             color:
                                    //                 finishingType == 'UnFinished'
                                    //                     ? kPrimaryColor
                                    //                     : Colors.white,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //             border: Border.all(
                                    //               color: finishingType ==
                                    //                       'UnFinished'
                                    //                   ? Colors.transparent
                                    //                   : kPrimaryLightColor,
                                    //             ),
                                    //           ),
                                    //           child: Center(
                                    //             child: Text(
                                    //               'UnFinished',
                                    //               style: TextStyle(
                                    //                 color: finishingType ==
                                    //                         'UnFinished'
                                    //                     ? Colors.white
                                    //                     : kPrimaryTextColor,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: size.height * 0.02,
                                    // ),
                                    RoundedButton(
                                      text: 'Add',
                                      press: () async {
                                        if (_formKey.currentState.validate()) {
                                          if (images.length == 0) {
                                            setState(() {
                                              error = 'Please add images';
                                            });
                                          } else {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic result;
                                            imagesURLs = await DatabaseService()
                                                .getDownloadURLs(images, name);
                                            if (logoFile != null) {
                                              final Reference
                                                  firebaseStorageRef =
                                                  FirebaseStorage.instance
                                                      .ref()
                                                      .child(
                                                          'compoundsLogos/${name}.jpg');
                                              UploadTask task =
                                                  firebaseStorageRef
                                                      .putFile(logoFile);
                                              TaskSnapshot taskSnapshot =
                                                  await task;
                                              logoURL = await taskSnapshot.ref
                                                  .getDownloadURL();
                                            }
                                            await DatabaseService()
                                                .updateCompoundData(
                                              agentName: agentName,
                                              facilities: amenitiesValue,
                                              logoURL: logoURL,
                                              name: name,
                                              nameAr: nameAr,
                                              offer: offer,
                                              imagesURLs: imagesURLs,
                                              meterPrice: int.parse(meterPrice),
                                              deliveryDate: deliveryDate,
                                              unitTypes: value,
                                              // areasAndUnits: unitsAndAreas,
                                              paymentPlan: paymentPlan,
                                              paymentPlanAr: paymentPlanAr,
                                              startingPrice:
                                                  int.parse(startingPrice),
                                              finishingType: finishingType,
                                              description: description,
                                              descriptionAr: descriptionAr,
                                              latitude:
                                                  locationData['latitude'],
                                              longitude:
                                                  locationData['longitude'],
                                              governate:
                                                  locationData['govName'],
                                              district:
                                                  locationData['districtName'],
                                              governateAr:
                                                  locationData['govNameAr'],
                                              districtAr: locationData[
                                                  'districtNameAr'],
                                              status: 'active',
                                              highlighted: true,
                                            );

                                            setState(() {
                                              added = true;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      error,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14),
                                    ),
                                  ],
                                ),
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
