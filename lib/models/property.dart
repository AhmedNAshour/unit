import 'package:unit/models/user.dart';

class Property {
  final String uid;
  final String description;
  final String additionalInfo;
  final String area;
  final int rentType;
  final String district;
  final String governate;
  final String governateAr;
  final String areaAr;
  final String districtAr;
  final String propertyType;
  final int listingType;
  final List images;
  final List amenities;
  final int price;
  final int size;
  final int level;
  final String finishingType;
  final int numBathrooms;
  final int numBedrooms;
  final double latitude;
  final double longitude;
  final UserData agent;
  final DateTime dateTime;
  final String status;

  Property({
    this.additionalInfo,
    this.rentType,
    this.governateAr,
    this.areaAr,
    this.districtAr,
    this.dateTime,
    this.description,
    this.level,
    this.finishingType,
    this.amenities,
    this.agent,
    this.status,
    this.uid,
    this.area,
    this.district,
    this.governate,
    this.propertyType,
    this.listingType,
    this.images,
    this.price,
    this.size,
    this.numBathrooms,
    this.numBedrooms,
    this.latitude,
    this.longitude,
  });
}
