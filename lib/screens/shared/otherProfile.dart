import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/info_card.dart';
import 'package:unit/components/lists_cards/propertiesList_admin.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/user.dart';
import 'package:unit/services/database.dart';

class OtherProfile extends StatefulWidget {
  static const id = 'OtherProfile';
  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserData user = ModalRoute.of(context).settings.arguments;
    final admin = Provider.of<MyUser>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                children: [
                  BackButton(
                    color: kSecondaryColor,
                  ),
                  Text(
                    'User Profile',
                    style: TextStyle(
                      color: kPrimaryTextColor,
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: size.width * 0.12,
                  backgroundImage: user.picURL != ''
                      ? NetworkImage(
                          user.picURL,
                        )
                      : AssetImage('assets/images/userPlaceholder.png'),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            // InkWell(
            //   onTap: () async {},
            //   child: Text(
            //     'Edit',
            //     style: TextStyle(
            //       color: kPrimaryColor,
            //       fontSize: 14,
            //     ),
            //   ),
            // ),
            InfoCard(
              title: 'Role',
              body: '${user.role}',
            ),
            InfoCard(
              title: 'Client name',
              body: '${user.name}',
            ),
            InfoCard(
              title: 'Phone number',
              body: '${user.phoneNumber}',
            ),
            InfoCard(
              title: 'Email',
              body: '${user.email}',
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'User Properties',
                  style: TextStyle(
                    color: kPrimaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Container(
                  height: size.height * 0.3,
                  child: MultiProvider(
                    providers: [
                      StreamProvider<List<Property>>.value(
                        value: DatabaseService().getPropertiesBySearch(
                            limited: false, agentId: user.uid),
                      ),
                      StreamProvider<UserData>.value(
                        value: DatabaseService(uid: admin.uid).userData,
                      ),
                    ],
                    child: PropertiesListAdmin('', Axis.horizontal),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
