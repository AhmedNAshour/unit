import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/constants.dart';
import 'package:unit/models/location.dart';
import 'package:unit/services/database.dart';
import 'package:unit/translations/locale_keys.g.dart';

class FilterCompoundsForm extends StatefulWidget {
  const FilterCompoundsForm({
    Key key,
    this.changeGovernateFilter,
    this.changeDistrictFilter,
    this.governateFilter,
    this.districtFilter,
  }) : super(key: key);

  final Function changeGovernateFilter;
  final Function changeDistrictFilter;

  final String governateFilter;
  final String districtFilter;

  // final Function changePropertyTypeFilter;

  @override
  _FilterCompoundsFormState createState() => _FilterCompoundsFormState();
}

class _FilterCompoundsFormState extends State<FilterCompoundsForm> {
  int listingType;
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
    selectedGov = widget.governateFilter;
    selectedDistrict = widget.districtFilter;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Location> governates = Provider.of<List<Location>>(context) ?? [];
    return StreamBuilder<List<Location>>(
        stream: selectedGov != '' && selectedGov != null
            ? DatabaseService().getDistricts(selectedGov)
            : null,
        builder: (context, districtsSnapshot) {
          districtsSnapshot.hasData
              ? districts = districtsSnapshot.data
              : districts = [];
          return StreamBuilder<Object>(
              stream: selectedDistrict != null && selectedDistrict != ''
                  ? DatabaseService().getAreas(selectedGov, selectedDistrict)
                  : null,
              builder: (context, areasSnapshot) {
                areasSnapshot.hasData ? areas = areasSnapshot.data : areas = [];
                return Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LocaleKeys.location),
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                            selectedGov == '' || selectedGov == null
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
                          }),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
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
                                  selectedDistrict == '' ||
                                          selectedDistrict == null
                                      ? tr(LocaleKeys.city)
                                      : selectedDistrict,
                                ),
                                items: districts.map((district) {
                                  return DropdownMenuItem(
                                    value: district.docId,
                                    child: context.locale == Locale('en')
                                        ? Text('${district.docId}')
                                        : Text('${district.nameAr}'),
                                  );
                                }).toList(),
                                onChanged: (val) => setState(() {
                                  selectedDistrict = val;
                                  selectedArea = '';
                                  widget
                                      .changeDistrictFilter(selectedDistrict);
                                }),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
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
                );
              });
        });
  }
}
