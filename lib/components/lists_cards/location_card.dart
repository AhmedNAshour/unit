import 'package:flutter/material.dart';
import 'package:unit/models/location.dart';
import 'package:unit/screens/admin/admin_addLocation_area.dart';
import 'package:unit/screens/admin/admin_addLocation_district.dart';
import 'package:unit/constants.dart';

class AddLocationCard extends StatelessWidget {
  const AddLocationCard({
    Key key,
    @required this.location,
    this.govName,
  }) : super(key: key);

  final Location location;
  final String govName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (location.type == 0) {
              Navigator.pushNamed(context, AdminAddDistrict.id, arguments: {
                'govName': location.docId,
              });
            } else if (location.type == 1) {
              Navigator.pushNamed(context, AdminAddArea.id, arguments: {
                'govName': govName,
                'districtName': location.docId,
              });
            }
          },
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Container(
                  width: screenWidth * 0.9,
                  // margin: EdgeInsets.only(bottom: size.height * 0.025),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.docId,
                        style: TextStyle(
                            color: kPrimaryTextColor,
                            fontSize: size.width * 0.05),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ],
    );
  }
}
