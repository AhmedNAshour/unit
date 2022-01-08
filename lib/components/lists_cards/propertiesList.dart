import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/property_card.dart';
import 'package:unit/models/property.dart';
import 'package:unit/translations/locale_keys.g.dart';

class PropertiesList extends StatefulWidget {
  @override
  _PropertiesListState createState() => _PropertiesListState();
  List<Property> searchList = <Property>[];
  String search = '';
  Axis axis;
  List userFavorites;
  PropertiesList(String search, Axis axis) {
    this.search = search;
    this.axis = axis;
  }

  PropertiesList.searchByFavorites(
      String search, Axis axis, List userFavorites) {
    this.search = search;
    this.axis = axis;
    this.userFavorites = userFavorites;
  }
}

class _PropertiesListState extends State<PropertiesList> {
  @override
  Widget build(BuildContext context) {
    List<Property> properties = Provider.of<List<Property>>(context) ?? [];
    Size size = MediaQuery.of(context).size;

    if (properties.length == 0) {
      return Center(
        child: Container(
          child: Text(tr(LocaleKeys.no_units_match_search)),
        ),
      );
    }
    properties.sort((a, b) {
      var aTitle = b.dateTime; //before -> var adate = a.expiry;
      var bTitle = a.dateTime; //before -> var bdate = b.expiry;
      return aTitle.compareTo(
          bTitle); //to get the order other way just switch `adate & bdate`
    });
    if (widget.userFavorites != null) {
      setState(() {
        widget.searchList = properties
            .where((element) => (widget.userFavorites.contains(element.uid)))
            .toList();
        // widget.searchList.sort((a, b) {
        //   var adate = a.startTime; //before -> var adate = a.expiry;
        //   var bdate = b.startTime; //before -> var bdate = b.expiry;
        //   return adate.compareTo(
        //       bdate); //to get the order other way just switch `adate & bdate`
        // });
      });
    }

    if (widget.userFavorites == null) {
      return ListView.builder(
        scrollDirection: widget.axis,
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return widget.axis == Axis.horizontal
              ? Row(
                  children: [
                    PropertyCard(property: properties[index]),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyCard(property: properties[index]),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
                );
        },
      );
    } else {
      return ListView.builder(
        scrollDirection: widget.axis,
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              PropertyCard(property: widget.searchList[index]),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          );
        },
      );
    }
  }
}
