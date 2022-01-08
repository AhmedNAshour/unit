import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/compound_card.dart';
import 'package:unit/models/compound.dart';
import 'package:unit/models/property.dart';
import 'package:unit/translations/locale_keys.g.dart';

class CompoundsList extends StatefulWidget {
  @override
  _CompoundsListState createState() => _CompoundsListState();
  List<Compound> searchList = <Compound>[];
  String search = '';
  Axis axis;
  // ignore: use_key_in_widget_constructors
  CompoundsList(String search, Axis axis) {
    this.search = search;
    this.axis = axis;
  }

  // ignore: use_key_in_widget_constructors
  CompoundsList.searchByFavorites(
      String search, Axis axis, List userFavorites) {
    this.search = search;
    this.axis = axis;
  }
}

class _CompoundsListState extends State<CompoundsList> {
  @override
  Widget build(BuildContext context) {
    List<Compound> compounds = Provider.of<List<Compound>>(context) ?? [];
    Size size = MediaQuery.of(context).size;

    if (compounds.length == 0) {
      return Center(child: Text(tr(LocaleKeys.no_matching_projects_exist)));
    }

    if (widget.search != '') {
      widget.searchList = compounds
          .where((element) => (element.name
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.nameAr
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.agentName
                  .toLowerCase()
                  .contains(widget.search.toLowerCase())))
          .toList();
      widget.searchList.sort((a, b) {
        var aTitle = b.dateTime; //before -> var adate = a.expiry;
        var bTitle = a.dateTime; //before -> var bdate = b.expiry;
        return aTitle.compareTo(
            bTitle); //to get the order other way just switch `adate & bdate` //to get the order other way just switch `adate & bdate`
      });
    }

    compounds.sort((a, b) {
      var aTitle = b.dateTime; //before -> var adate = a.expiry;
      var bTitle = a.dateTime; //before -> var bdate = b.expiry;
      return aTitle.compareTo(
          bTitle); //to get the order other way just switch `adate & bdate`
    });
    return ListView.builder(
      scrollDirection: widget.axis,
      itemCount:
          widget.search == '' ? compounds.length : widget.searchList.length,
      itemBuilder: (context, index) {
        return widget.axis == Axis.horizontal
            ? Row(
                children: [
                  CompoundCard(compound: compounds[index]),
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompoundCard(
                      compound: widget.search == ''
                          ? compounds[index]
                          : widget.searchList[index]),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                ],
              );
      },
    );
  }
}
