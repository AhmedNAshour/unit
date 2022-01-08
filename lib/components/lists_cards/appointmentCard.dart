import 'package:flutter/material.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/request.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/compound_info.dart';
import 'package:unit/screens/shared/property_info.dart';
import 'package:unit/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentCard extends StatelessWidget {
  final Request request;

  const AppointmentCard({
    Key key,
    this.request,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            request.compound == null
                ? Navigator.pushNamed(
                    context,
                    PropertyInfo.id,
                    arguments: request.property,
                  )
                : Navigator.pushNamed(
                    context,
                    CompoundInfo.id,
                    arguments: {
                      'compound': request.compound,
                      'user': UserData(
                        role: 'admin',
                      ),
                    },
                  );
          },
          child: Container(
            padding: EdgeInsets.all(width * 0.02),
            height: height * 0.15,
            decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: kPrimaryColor,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: width * 0.1,
                  backgroundImage: request.userPic != ''
                      ? NetworkImage(request.userPic)
                      : AssetImage('assets/images/userPlaceholder.png'),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      request.userName,
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      request.date,
                      style: TextStyle(
                        color: kPrimaryLightTextColor,
                        fontSize: width * 0.04,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      request.userNumber,
                      style: TextStyle(
                        color: kPrimaryLightTextColor,
                        fontSize: width * 0.04,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launch("tel://${request.userNumber}");
                          },
                          child: Icon(
                            Icons.phone_android,
                            color: kSecondaryColor,
                            size: height * 0.04,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        request.status == 'pending'
                            ? GestureDetector(
                                onTap: () async {
                                  await DatabaseService()
                                      .updateAppointmentRequestStatus(
                                          status: 'confirmed',
                                          requestId: request.uid);
                                },
                                child: Icon(
                                  Icons.check,
                                  color: kSecondaryColor,
                                  size: height * 0.04,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await DatabaseService()
                                      .updateAppointmentRequestStatus(
                                          status: 'pending',
                                          requestId: request.uid);
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: kSecondaryColor,
                                  size: height * 0.04,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * 0.02,
        ),
      ],
    );
  }
}
