import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/info_card.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserData user = Provider.of<UserData>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04, vertical: size.height * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   child: Text(
            //     'Profile',
            //     style: TextStyle(
            //       color: kPrimaryTextColor,
            //       fontSize: size.height * 0.03,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: size.height * 0.04,
            // ),
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
              title: 'Name',
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
          ],
        ),
      ),
    );
  }
}
