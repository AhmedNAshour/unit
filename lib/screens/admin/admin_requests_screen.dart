import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/appointmentRequestsList_admin.dart';
import 'package:unit/components/lists_cards/propertiesList_admin.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/request.dart';
import 'package:unit/services/database.dart';
import 'package:unit/constants.dart';

class AdminRequests extends StatefulWidget {
  @override
  _AdminRequestsState createState() => _AdminRequestsState();
}

class _AdminRequestsState extends State<AdminRequests> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return MultiProvider(
      providers: [
        StreamProvider<List<Property>>.value(
          value: DatabaseService().getPropertiesBySearch(
            limited: false,
            status: 'pending',
          ),
        ),
      ],
      child: Scaffold(
        // backgroundColor: Color(0xFFF0F0F0),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              Text(
                'Requests',
                style: TextStyle(
                  color: kPrimaryTextColor,
                  fontSize: size.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: size.width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selectedTab == 0 ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedTab == 0
                                ? Colors.transparent
                                : kSecondaryColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Listing',
                            style: TextStyle(
                              color: selectedTab == 0
                                  ? Colors.white
                                  : kPrimaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                          horizontal: size.width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color:
                              selectedTab == 1 ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedTab == 1
                                ? Colors.transparent
                                : kSecondaryColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Booking',
                            style: TextStyle(
                              color: selectedTab == 1
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
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: Container(
                  child: selectedTab == 0
                      ? PropertiesListAdmin('', Axis.vertical)
                      : MultiProvider(
                          providers: [
                            StreamProvider<List<Request>>.value(
                                value: DatabaseService()
                                    .getAppointmentRequestsBySearch())
                          ],
                          child: AppointmentRequestsListAdmin(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
