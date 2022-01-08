import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/location_card_select.dart';
import 'package:unit/models/location.dart';

class SelectLocationList extends StatefulWidget {
  @override
  _SelectLocationListState createState() => _SelectLocationListState();
  List<Location> searchList = <Location>[];
  String search = '';
  String govName;
  String districtName;
  String govNameAr;
  String districtNameAr;
  String addType;
  // ignore: use_key_in_widget_constructors
  SelectLocationList(String search, String govName, String districtName,
      String govNameAr, String districtNameAr, addType) {
    this.search = search;
    this.govName = govName;
    this.districtName = districtName;
    this.govNameAr = govNameAr;
    this.districtNameAr = districtNameAr;
    this.addType = addType;
  }
}

class _SelectLocationListState extends State<SelectLocationList> {
  @override
  Widget build(BuildContext context) {
    final locations = Provider.of<List<Location>>(context) ?? [];
    setState(() {
      //print(DateFormat('dd-MM-yyyy').format(salesLogsList[0].date.toDate()));
      widget.searchList = locations
          .where((element) => (element.docId
              .toLowerCase()
              .contains(widget.search.toLowerCase())))
          .toList();
      widget.searchList.sort((a, b) {
        var adate = a.docId; //before -> var adate = a.expiry;
        var bdate = b.docId; //before -> var bdate = b.expiry;
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });
    });
    if (widget.search == '') {
      return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return SelectLocationCard(
            location: locations[index],
            govName: widget.govName,
            districtName: widget.districtName,
            govNameAr: widget.govNameAr,
            districtNameAr: widget.districtNameAr,
            addType: widget.addType,
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return SelectLocationCard(
            location: widget.searchList[index],
            govName: widget.govName,
            districtName: widget.districtName,
            govNameAr: widget.govNameAr,
            districtNameAr: widget.districtNameAr,
            addType: widget.addType,
          );
        },
      );
    }
  }
}
