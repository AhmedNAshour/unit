import 'package:flutter/material.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/otherProfile.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget {
  final UserData user;

  const UserCard({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, OtherProfile.id, arguments: user);
      },
      child: Card(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: width * 0.09,
                  backgroundImage: user.picURL != ''
                      ? NetworkImage(user.picURL)
                      : AssetImage('assets/images/userPlaceholder.png'),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: width * 0.05,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.role,
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
                    child: GestureDetector(
                      onTap: () {
                        launch("tel://${user.phoneNumber}");
                      },
                      child: Icon(
                        Icons.phone_android,
                        color: kSecondaryColor,
                        size: height * 0.04,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
