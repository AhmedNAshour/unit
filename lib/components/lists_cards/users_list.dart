import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/user_card.dart';
import 'package:unit/models/user.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
  List<UserData> searchList = <UserData>[];
  String search = '';
  UsersList(String search) {
    this.search = search;
  }
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context) ?? [];
    setState(() {
      widget.searchList = users
          .where((element) => (element.name
                  .toLowerCase()
                  .contains(widget.search.toLowerCase()) ||
              element.phoneNumber.contains(widget.search)))
          .toList();
      widget.searchList.sort((a, b) {
        var adate = a.name; //before -> var adate = a.expiry;
        var bdate = b.name; //before -> var bdate = b.expiry;
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });
    });
    if (widget.search == null) {
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserCard(user: users[index]);
        },
      );
    } else {
      return ListView.builder(
        itemCount: widget.searchList.length,
        itemBuilder: (context, index) {
          return UserCard(user: widget.searchList[index]);
        },
      );
    }
  }
}
