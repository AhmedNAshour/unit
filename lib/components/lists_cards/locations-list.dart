import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/location_card.dart';
import 'package:unit/models/location.dart';

class LocationList extends StatefulWidget {
  @override
  _LocationListState createState() => _LocationListState();
  List<Location> searchList = <Location>[];
  String search = '';
  String govName;
  // ignore: use_key_in_widget_constructors
  LocationList(String search, govName) {
    this.search = search;
    this.govName = govName;
  }
}

class _LocationListState extends State<LocationList> {
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
          return AddLocationCard(
            location: locations[index],
            govName: widget.govName,
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return AddLocationCard(
            location: widget.searchList[index],
            govName: widget.govName,
          );
        },
      );
    }
  }
}
