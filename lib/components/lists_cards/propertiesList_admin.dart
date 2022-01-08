import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/property_card_admin.dart';
import 'package:unit/models/property.dart';

class PropertiesListAdmin extends StatefulWidget {
  @override
  _PropertiesListAdminState createState() => _PropertiesListAdminState();
  List<Property> searchList = <Property>[];
  String search = '';
  Axis axis;
  List userFavorites;

  // ignore: use_key_in_widget_constructors
  PropertiesListAdmin(String search, Axis axis) {
    this.search = search;
    this.axis = axis;
  }
  PropertiesListAdmin.getLikes(String search, Axis axis, List userFavorites) {
    this.search = search;
    this.axis = axis;
    this.userFavorites = userFavorites;
  }
}

class _PropertiesListAdminState extends State<PropertiesListAdmin> {
  @override
  Widget build(BuildContext context) {
    List<Property> properties = Provider.of<List<Property>>(context) ?? [];
    Size size = MediaQuery.of(context).size;

    if (properties.length == 0) {
      return Center(
        child: Container(
          child: Text('Unfortunately , no matching properties exist :/'),
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
        //print(DateFormat('dd-MM-yyyy').format(salesLogsList[0].date.toDate()));
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
      return Column(
        children: [
          Text(
            'Number of properties: ${properties.length}',
            style: TextStyle(
              fontSize: size.width * 0.04,
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: widget.axis,
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return widget.axis == Axis.horizontal
                    ? Row(
                        children: [
                          AdminPropertyCard(property: properties[index]),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdminPropertyCard(property: properties[index]),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                        ],
                      );
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            'Number of properties: ${properties.length}',
            style: TextStyle(
              fontSize: size.width * 0.04,
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: widget.axis,
              itemCount: widget.searchList.length,
              itemBuilder: (context, index) {
                return AdminPropertyCard(property: widget.searchList[index]);
              },
            ),
          ),
        ],
      );
    }
  }
}
