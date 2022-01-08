import 'package:unit/models/compound.dart';
import 'package:unit/models/property.dart';

class Request {
  final Property property;
  final Compound compound;
  final String uid;
  final String userName;
  final String userId;
  final String userNumber;
  final String userPic;
  final DateTime dateTime;
  final String status;
  final String date;

  Request({
    this.dateTime,
    this.compound,
    this.property,
    this.date,
    this.uid,
    this.status,
    this.userName,
    this.userId,
    this.userNumber,
    this.userPic,
  });
}
