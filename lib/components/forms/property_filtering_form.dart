import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/constants.dart';
import 'package:unit/models/location.dart';
import 'package:unit/services/database.dart';
import 'package:unit/translations/locale_keys.g.dart';

class FilterPropertiesForm extends StatefulWidget {
  const FilterPropertiesForm({
    Key key,
    this.changeGovernateFilter,
    this.changeDistrictFilter,
    this.changeAreaFilter,
    this.changeNumBedroomsFilter,
    this.changeNumBathroomsFilter,
    this.changePriceMaxFilter,
    this.changePriceMinFilter,
    this.changeListingTypeFilter,
    this.numBedroomsFilter,
    this.rentTypeFilter,
    this.numBathroomsFilter,
    this.priceMinFilter,
    this.priceMaxFilter,
    this.listingTypeFilter,
    this.propertyTypeFilter,
    this.governateFilter,
    this.districtFilter,
    this.areaFilter,
    this.sizeMinFilter,
    this.sizeMaxFilter,
    this.changeSizeMinFilter,
    this.changeSizeMaxFilter,
    this.changeRentType,
  }) : super(key: key);

  final Function changeGovernateFilter;
  final Function changeDistrictFilter;
  final Function changeAreaFilter;
  final Function changeNumBedroomsFilter;
  final Function changeNumBathroomsFilter;
  final Function changeSizeMinFilter;
  final Function changeSizeMaxFilter;

  final Function changePriceMaxFilter;
  final Function changePriceMinFilter;
  final Function changeListingTypeFilter;
  final Function changeRentType;

  final String governateFilter;
  final String districtFilter;
  final String areaFilter;

  final int numBedroomsFilter;
  final int numBathroomsFilter;
  final int sizeMinFilter;
  final int sizeMaxFilter;
  final int priceMinFilter;
  final int priceMaxFilter;
  final int listingTypeFilter;
  final int propertyTypeFilter;
  final int rentTypeFilter;
  // final Function changePropertyTypeFilter;

  @override
  _FilterPropertiesFormState createState() => _FilterPropertiesFormState();
}

class _FilterPropertiesFormState extends State<FilterPropertiesForm> {
  int listingType;
  int rentType;
  int numBedrooms;
  int numBathrooms;
  String selectedGov = '';
  String selectedDistrict = '';
  String selectedArea = '';
  List<Location> districts;
  List<Location> areas;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    listingType = widget.listingTypeFilter;
    rentType = widget.rentTypeFilter;
    selectedGov = widget.governateFilter;
    selectedDistrict = widget.districtFilter;
    selectedArea = widget.areaFilter;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Location> governates = Provider.of<List<Location>>(context) ?? [];
    return StreamBuilder<List<Location>>(
        stream: selectedGov != ''
            ? DatabaseService().getDistricts(selectedGov)
            : null,
        builder: (context, districtsSnapshot) {
          districtsSnapshot.hasData
              ? districts = districtsSnapshot.data
              : districts = [];
          return StreamBuilder<Object>(
              stream: selectedDistrict != ''
                  ? DatabaseService().getAreas(selectedGov, selectedDistrict)
                  : null,
              builder: (context, areasSnapshot) {
                areasSnapshot.hasData ? areas = areasSnapshot.data : areas = [];
                return SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(LocaleKeys.listing_type),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              // horizontal: size.width * 0.05,
                              ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      listingType = 1;
                                      rentType = 0;
                                      widget
                                          .changeListingTypeFilter(listingType);
                                      widget.changeRentType(rentType);
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
                                      color: listingType == 1
                                          ? kPrimaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: listingType == 1
                                            ? Colors.transparent
                                            : kSecondaryColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        tr(LocaleKeys.buy),
                                        style: TextStyle(
                                          color: listingType == 1
                                              ? Colors.white
                                              : kPrimaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      listingType = 0;

                                      widget
                                          .changeListingTypeFilter(listingType);
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
                                      color: listingType == 0
                                          ? kPrimaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: listingType == 0
                                            ? Colors.transparent
                                            : kSecondaryColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        tr(LocaleKeys.rent),
                                        style: TextStyle(
                                          color: listingType == 0
                                              ? Colors.white
                                              : kPrimaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        listingType == 0
                            ? Text(
                                tr(LocaleKeys.rent_type),
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                  fontSize: size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Container(),
                        listingType == 0
                            ? SizedBox(
                                height: size.height * 0.02,
                              )
                            : Container(),
                        listingType == 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    // horizontal: size.width * 0.05,
                                    ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            rentType = 1;
                                            widget.changeRentType(rentType);
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
                                            color: rentType == 1
                                                ? kPrimaryColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: rentType == 1
                                                  ? Colors.transparent
                                                  : kSecondaryColor,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              tr(LocaleKeys.rent_month),
                                              style: TextStyle(
                                                color: rentType == 1
                                                    ? Colors.white
                                                    : kPrimaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            rentType = 2;
                                            widget.changeRentType(rentType);
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
                                            color: rentType == 2
                                                ? kPrimaryColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: rentType == 2
                                                  ? Colors.transparent
                                                  : kSecondaryColor,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              tr(LocaleKeys.rent_day),
                                              style: TextStyle(
                                                color: rentType == 2
                                                    ? Colors.white
                                                    : kPrimaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          tr(LocaleKeys.bedrooms_bathrooms),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: size.height * 0.06,
                                margin:
                                    EdgeInsets.only(bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  initialValue: widget.numBedroomsFilter != null
                                      ? widget.numBedroomsFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    // labelText: 'Bedrooms',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.bed,
                                    ),
                                    hintText: tr(LocaleKeys.bedrooms),
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget.changeNumBedroomsFilter(
                                        int.parse(value));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Expanded(
                              child: Container(
                                height: size.height * 0.06,
                                margin:
                                    EdgeInsets.only(bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  initialValue:
                                      widget.numBathroomsFilter != null
                                          ? widget.numBathroomsFilter.toString()
                                          : null,
                                  decoration: InputDecoration(
                                    // labelText: 'Bathrooms',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.bath,
                                    ),
                                    hintText: tr(LocaleKeys.bathrooms),
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget.changeNumBathroomsFilter(
                                        int.parse(value));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          tr(LocaleKeys.price_range),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: size.height * 0.06,
                                margin:
                                    EdgeInsets.only(bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  initialValue: widget.priceMinFilter != null
                                      ? widget.priceMinFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    // labelText: 'Min. Price',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.moneyBill,
                                    ),
                                    hintText: tr(LocaleKeys.min_price),
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changePriceMinFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Expanded(
                              child: Container(
                                height: size.height * 0.06,
                                margin:
                                    EdgeInsets.only(bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  initialValue: widget.priceMaxFilter != null
                                      ? widget.priceMaxFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    // labelText: 'Max. Price',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.moneyBill,
                                    ),
                                    hintText: tr(LocaleKeys.max_price),
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changePriceMaxFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          tr(LocaleKeys.area),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: size.height * 0.06,
                                margin:
                                    EdgeInsets.only(bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  initialValue: widget.sizeMinFilter != null
                                      ? widget.sizeMinFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    // labelText: 'Min. Size',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.ruler,
                                    ),
                                    hintText: tr(LocaleKeys.min_area),
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changeSizeMinFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Expanded(
                              child: Container(
                                height: size.height * 0.06,
                                margin:
                                    EdgeInsets.only(bottom: size.height * 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02),
                                child: TextFormField(
                                  initialValue: widget.sizeMaxFilter != null
                                      ? widget.sizeMaxFilter.toString()
                                      : null,
                                  decoration: InputDecoration(
                                    // labelText: 'Max. Size',
                                    labelStyle: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.ruler,
                                    ),
                                    hintText: tr(LocaleKeys.max_area),
                                    focusColor: kPrimaryColor,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    widget
                                        .changeSizeMaxFilter(int.parse(value));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          tr(LocaleKeys.location),
                          style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.height * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          height: 60,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            icon: Icon(
                              Icons.pin_drop,
                              color: kPrimaryColor,
                            ),
                            hint: Text(
                              selectedGov == ''
                                  ? tr(LocaleKeys.governorate)
                                  : selectedGov,
                            ),
                            items: governates.map((gov) {
                              return DropdownMenuItem(
                                value: gov.docId,
                                child: context.locale == Locale('en')
                                    ? Text('${gov.docId}')
                                    : Text('${gov.nameAr}'),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() {
                              selectedGov = val;
                              selectedDistrict = '';
                              selectedArea = '';
                              widget.changeGovernateFilter(selectedGov);
                              widget.changeDistrictFilter('');
                              widget.changeAreaFilter('');
                            }),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        districts.length != 0
                            ? Container(
                                height: 60,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  icon: Icon(
                                    Icons.pin_drop,
                                    color: kPrimaryColor,
                                  ),
                                  hint: Text(
                                    selectedDistrict == ''
                                        ? tr(LocaleKeys.city)
                                        : selectedDistrict,
                                  ),
                                  items: districts.map((district) {
                                    return DropdownMenuItem(
                                        value: district.docId,
                                        child: context.locale == Locale('en')
                                            ? Text('${district.docId}')
                                            : Text('${district.nameAr}'));
                                  }).toList(),
                                  onChanged: (val) => setState(() {
                                    selectedDistrict = val;
                                    selectedArea = '';

                                    widget
                                        .changeDistrictFilter(selectedDistrict);

                                    widget.changeAreaFilter('');
                                  }),
                                ),
                              )
                            : Container(),
                        districts.length != 0
                            ? SizedBox(
                                height: size.height * 0.01,
                              )
                            : Container(),
                        areas.length != 0
                            ? Container(
                                height: 60,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  icon: Icon(
                                    Icons.pin_drop,
                                    color: kPrimaryColor,
                                  ),
                                  hint: Text(
                                    selectedArea == ''
                                        ? tr(LocaleKeys.district)
                                        : selectedArea,
                                  ),
                                  items: areas.map((area) {
                                    return DropdownMenuItem(
                                      value: area.docId,
                                      child: context.locale == Locale('en')
                                          ? Text('${area.docId}')
                                          : Text('${area.nameAr}'),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() {
                                    selectedArea = val;
                                    widget.changeAreaFilter(selectedArea);
                                  }),
                                ),
                              )
                            : Container(),
                        areas.length != 0
                            ? SizedBox(
                                height: size.height * 0.01,
                              )
                            : Container(),
                        Center(
                          child: RoundedButton(
                            text: tr(LocaleKeys.search),
                            press: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
