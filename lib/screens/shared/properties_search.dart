import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/property_filtering_form.dart';
import 'package:unit/components/lists_cards/propertiesList.dart';
import 'package:unit/components/lists_cards/propertiesList_admin.dart';
import 'package:unit/components/loginSingupModalBottomSheet.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/admin/selectLocation_governate.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/database.dart';
import 'package:unit/translations/locale_keys.g.dart';

class PropertiesSearch extends StatefulWidget {
  static const id = 'PropertiesSearch';
  @override
  _PropertiesSearchState createState() => _PropertiesSearchState();
}

class _PropertiesSearchState extends State<PropertiesSearch> {
  String governateFilter = '';
  String districtFilter = '';
  String areaFilter = '';
  int numBedroomsFilter;
  int numBathroomsFilter;
  int sizeMinFilter;
  int sizeMaxFilter;
  int priceMinFilter;
  int priceMaxFilter;
  int listingTypeFilter;
  int rentTypeFilter;
  int propertyTypeFilter;
  Map navigationData = {};
  bool firstTime = true;

  changeGovernateFilter(String newGovernateFilter) {
    setState(() {
      governateFilter = newGovernateFilter;
    });
  }

  changeDistrictFilter(newDistrictFilter) {
    setState(() {
      districtFilter = newDistrictFilter;
    });
  }

  changeAreaFilter(newAreaFilter) {
    setState(() {
      areaFilter = newAreaFilter;
    });
  }

  changeNumBedroomsFilter(newNumBedrooms) {
    setState(() {
      numBedroomsFilter = newNumBedrooms;
    });
  }

  changeNumBathroomsFilter(newNumBathrooms) {
    setState(() {
      numBathroomsFilter = newNumBathrooms;
    });
  }

  changeSizeMinFilter(newSizeMinFilter) {
    setState(() {
      sizeMinFilter = newSizeMinFilter;
    });
  }

  changeSizeMaxFilter(newSizeMaxFilter) {
    setState(() {
      sizeMaxFilter = newSizeMaxFilter;
    });
  }

  changePriceMinFilter(newPriceMinFilter) {
    setState(() {
      priceMinFilter = newPriceMinFilter;
    });
  }

  changePriceMaxFilter(newPriceMaxFilter) {
    setState(() {
      priceMaxFilter = newPriceMaxFilter;
    });
  }

  changeListingTypeFilter(newListingTypeFilter) {
    setState(() {
      listingTypeFilter = newListingTypeFilter;
    });
  }

  changeRentTypeFilter(newRentTypeFilter) {
    setState(() {
      rentTypeFilter = newRentTypeFilter;
    });
  }

  changePropertyTypeFilter(newPropertyTypeFilter) {
    setState(() {
      propertyTypeFilter = newPropertyTypeFilter;
    });
  }

  String createSearchBubbleText(int index) {
    if (index == 3) {
      return ' ' + tr(LocaleKeys.bedrooms);
    } else if (index == 4) {
      return ' ' + tr(LocaleKeys.bathrooms);
    } else if (index == 5) {
      return ' ' + tr(LocaleKeys.min_area);
    } else if (index == 6) {
      return ' ' + tr(LocaleKeys.max_area);
    } else if (index == 7) {
      return ' ' + tr(LocaleKeys.min_price);
    } else if (index == 8) {
      return ' ' + tr(LocaleKeys.max_price);
    } else {
      return '';
    }
  }

  final List<String> propertyTypes = [
    'Apartment',
    'Villa',
    'Commercial / Administrative / Medical',
    'Vacation',
  ];

  final List<String> propertyTypesAr = [
    'شقق',
    'فيلات',
    'تجاري / إداري / طبي',
    'مصيف',
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    navigationData = ModalRoute.of(context).settings.arguments;
    if (firstTime) listingTypeFilter = navigationData['listingType'];
    if (firstTime) propertyTypeFilter = navigationData['propertyType'];
    firstTime = false;

    List filters = [
      governateFilter,
      districtFilter,
      areaFilter,
      numBedroomsFilter,
      numBathroomsFilter,
      sizeMinFilter,
      sizeMaxFilter,
      priceMinFilter,
      priceMaxFilter,
      listingTypeFilter != null
          ? listingTypeFilter == 0
              ? tr(LocaleKeys.rent)
              : tr(LocaleKeys.buy)
          : null,
      rentTypeFilter != null || rentTypeFilter == 0
          ? rentTypeFilter == 1
              ? tr(LocaleKeys.rent_month)
              : tr(LocaleKeys.rent_week)
          : null,
      propertyTypeFilter != null
          ? context.locale == Locale('en')
              ? propertyTypes[propertyTypeFilter]
              : propertyTypesAr[propertyTypeFilter]
          : null,
    ];

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return MultiProvider(
      providers: [
        StreamProvider<List<Property>>.value(
          value: DatabaseService().getPropertiesBySearch(
            limited: false,
            listingType: listingTypeFilter,
            propertyType: propertyTypeFilter != null
                ? propertyTypes[propertyTypeFilter]
                : null,
            governate: governateFilter,
            district: districtFilter,
            area: areaFilter,
            numberBathrooms: numBathroomsFilter,
            numberBedrooms: numBedroomsFilter,
            rentType: rentTypeFilter,
            sizeMin: sizeMinFilter,
            sizeMax: sizeMaxFilter,
            status: 'active',
          ),
        ),
        StreamProvider<UserData>.value(
            value:
                user != null ? DatabaseService(uid: user.uid).userData : null),
      ],
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: Color(0xFFF0F0F0),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.04, vertical: height * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                Row(
                  children: [
                    BackButton(
                      color: kSecondaryColor,
                    ),
                    Text(
                      tr(LocaleKeys.search_in_resale),
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                //Filtering
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
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
                                    return Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.02,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: size.width * 0.02,
                                                  right: size.width * 0.02,
                                                  bottom: size.height * 0.01),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    width: size.height * 0.001,
                                                    color: kPrimaryLightColor,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    tr(LocaleKeys.filter),
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width * 0.05,
                                                        color:
                                                            kPrimaryTextColor),
                                                  ),
                                                  SizedBox(
                                                      width: size.width * 0.28),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: kPrimaryTextColor,
                                                      size: size.width * 0.085,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: size.height * 0.02,
                                            // ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.04,
                                              ),
                                              child: Text(
                                                tr(LocaleKeys.unit_type),
                                                style: TextStyle(
                                                  color: kPrimaryTextColor,
                                                  fontSize: size.height * 0.02,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                width: size.width * 0.9,
                                                height: size.height * 0.11,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      propertyTypes.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        insideState(() {
                                                          propertyTypeFilter =
                                                              index;
                                                        });
                                                        this.setState(() {
                                                          propertyTypeFilter =
                                                              index;
                                                        });
                                                      },
                                                      child: Container(
                                                        width:
                                                            size.width * 0.35,
                                                        height:
                                                            size.height * 0.01,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          vertical:
                                                              size.height *
                                                                  0.02,
                                                          horizontal:
                                                              size.width * 0.01,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: propertyTypeFilter ==
                                                                  index
                                                              ? kPrimaryColor
                                                              : kPrimaryLightColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: propertyTypeFilter ==
                                                                      index
                                                                  ? Colors
                                                                      .transparent
                                                                  : kSecondaryColor),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            context.locale ==
                                                                    Locale('en')
                                                                ? propertyTypes[
                                                                    index]
                                                                : propertyTypesAr[
                                                                    index],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: propertyTypeFilter ==
                                                                      index
                                                                  ? kPrimaryLightColor
                                                                  : kPrimaryTextColor,
                                                              // fontSize:
                                                              //     size.width * 0.04,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.04,
                                                ),
                                                child: FilterPropertiesForm(
                                                  changeGovernateFilter:
                                                      changeGovernateFilter,
                                                  changeRentType:
                                                      changeRentTypeFilter,
                                                  changeDistrictFilter:
                                                      changeDistrictFilter,
                                                  changeAreaFilter:
                                                      changeAreaFilter,
                                                  changeListingTypeFilter:
                                                      changeListingTypeFilter,
                                                  changeNumBathroomsFilter:
                                                      changeNumBathroomsFilter,
                                                  changeNumBedroomsFilter:
                                                      changeNumBedroomsFilter,
                                                  changePriceMaxFilter:
                                                      changePriceMaxFilter,
                                                  changePriceMinFilter:
                                                      changePriceMinFilter,
                                                  changeSizeMinFilter:
                                                      changeSizeMinFilter,
                                                  changeSizeMaxFilter:
                                                      changeSizeMaxFilter,
                                                  listingTypeFilter:
                                                      listingTypeFilter,
                                                  rentTypeFilter:
                                                      rentTypeFilter,
                                                  governateFilter:
                                                      governateFilter,
                                                  districtFilter:
                                                      districtFilter,
                                                  areaFilter: areaFilter,
                                                  numBathroomsFilter:
                                                      numBathroomsFilter,
                                                  numBedroomsFilter:
                                                      numBedroomsFilter,
                                                  priceMinFilter:
                                                      priceMinFilter,
                                                  priceMaxFilter:
                                                      priceMaxFilter,
                                                  sizeMinFilter: sizeMinFilter,
                                                  sizeMaxFilter: sizeMaxFilter,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            );
                          },
                          isScrollControlled: true,
                        );
                      },
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              FontAwesomeIcons.filter,
                              color: kPrimaryLightColor,
                              size: height * 0.025,
                            ),
                            Text(
                              tr(LocaleKeys.search),
                              style: TextStyle(
                                color: kPrimaryLightColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Expanded(
                      child: Container(
                        height: height * 0.05,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            return filters[index] != null &&
                                    filters[index] != ''
                                ? Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.02),
                                    padding: EdgeInsets.all(width * 0.02),
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                      color: kPrimaryLightColor,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: kPrimaryTextColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          filters[index].toString() +
                                              createSearchBubbleText(index),
                                          style: TextStyle(
                                            color: kPrimaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (index == 0) {
                                                governateFilter = '';
                                                districtFilter = '';
                                                areaFilter = '';
                                              } else if (index == 1) {
                                                districtFilter = '';
                                                areaFilter = '';
                                              } else if (index == 2) {
                                                areaFilter = '';
                                              } else if (index == 3) {
                                                numBedroomsFilter = null;
                                              } else if (index == 4) {
                                                numBathroomsFilter = null;
                                              } else if (index == 5) {
                                                sizeMinFilter = null;
                                              } else if (index == 6) {
                                                sizeMaxFilter = null;
                                              } else if (index == 7) {
                                                priceMinFilter = null;
                                              } else if (index == 8) {
                                                priceMaxFilter = null;
                                              } else if (index == 9) {
                                                listingTypeFilter = null;
                                                rentTypeFilter = null;
                                              } else if (index == 10) {
                                                rentTypeFilter = null;
                                              } else if (index == 11) {
                                                propertyTypeFilter = null;
                                              }
                                            });
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.minusCircle,
                                            color: kSecondaryColor,
                                            size: width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                //Listing
                Expanded(
                  child: Container(
                    child: user != null
                        ? StreamBuilder<Object>(
                            stream: DatabaseService(uid: user.uid).userData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                UserData userData = snapshot.data;
                                return userData.role == 'admin'
                                    ? PropertiesListAdmin('', Axis.vertical)
                                    : PropertiesList('', Axis.vertical);
                              } else {
                                return Loading();
                              }
                            })
                        : PropertiesList('', Axis.vertical),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: kSecondaryColor,
            onPressed: () {
              if (user != null) {
                Navigator.pushNamed(context, SelectGovernate.id, arguments: {
                  'type': 'resale',
                });
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
                              (BuildContext context, StateSetter insideState) {
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
            child: Icon(
              FontAwesomeIcons.plus,
            ),
          ),
        ),
      ),
    );
  }
}
