import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unit/models/compound.dart';
import 'package:unit/models/location.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/request.dart';
import 'package:unit/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection references
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference compoundsCollection =
      FirebaseFirestore.instance.collection('compounds');
  final CollectionReference propertiesCollection =
      FirebaseFirestore.instance.collection('resale');
  final CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');
  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return UserData(
      uid: uid,
      name: data['name'],
      gender: data['gender'],
      role: data['role'],
      phoneNumber: data['phoneNumber'],
      password: data['password'],
      email: data['email'],
      picURL: data['picURL'],
      likes: data['likes'] ?? [],
    );
  }

  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // create or update government
  Future updateLocationData({
    String govName,
    String nameAr,
  }) async {
    return await FirebaseFirestore.instance
        .collection("locations/")
        .doc(govName)
        .set({'nameAr': nameAr});
  }

  Future updateLocationDataDistrict({
    String districtName,
    String govName,
    String nameAr,
  }) async {
    return await FirebaseFirestore.instance
        .collection("locations/" + govName + "/districts")
        .doc(districtName)
        .set({'nameAr': nameAr});
  }

  Future updateLocationDataArea({
    String districtName,
    String govName,
    String areaName,
    String nameAr,
  }) async {
    return await FirebaseFirestore.instance
        .collection(
            "locations/" + govName + "/districts/" + districtName + '/areas')
        .doc(areaName)
        .set({'nameAr': nameAr});
  }

  List<UserData> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
        name: doc.get('name') ?? '',
        phoneNumber: doc.get('phoneNumber') ?? '',
        gender: doc.get('gender') ?? '',
        uid: doc.id,
        picURL: doc.get('picURL') ?? '',
        email: doc.get('email') ?? '',
        role: doc.get('role') ?? '',
      );
    }).toList();
  }

  Stream<List<UserData>> getUsersBySearch(String role) {
    Query query = FirebaseFirestore.instance.collection('users');
    if (role != '') {
      query = query.where(
        'role',
        isEqualTo: role,
      );
    }
    return query.snapshots().map(_usersListFromSnapshot);
  }

  // create or update user
  Future updateUserData({
    String name,
    String phoneNumber,
    String gender,
    String role,
    String password,
    String email,
    String picURL,
    List likes,
  }) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'role': role,
      'password': password,
      'email': email,
      'picURL': picURL,
      'likes': likes,
    });
  }

  Future updateUserLikes(List likes) async {
    await usersCollection.doc(uid).update({
      'likes': likes,
    });
  }

  Future updateUserProfilePicture(String picURL) async {
    await usersCollection.doc(uid).update({
      'picURL': picURL,
    });
  }

  Future<List<String>> getDownloadURLs(List<File> images, String name) async {
    int imageCounter = 1;
    List<String> imagesURLs = [];
    for (int i = 0; i < images.length; i++) {
      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('compoundPics/$name/$name$imageCounter');
      imageCounter++;
      UploadTask task = firebaseStorageRef.putFile(images.elementAt(i));
      TaskSnapshot taskSnapshot = await task;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      imagesURLs.add(downloadURL);
    }
    return imagesURLs;
  }

  Future updateCompoundData({
    String nameAr,
    String agentName,
    bool offer,
    String logoURL,
    String name,
    String description,
    String descriptionAr,
    int meterPrice,
    String paymentPlan,
    String paymentPlanAr,
    String deliveryDate,
    String governate,
    String district,
    String governateAr,
    String districtAr,
    List<String> unitTypes,
    String areasAndUnits,
    List<String> imagesURLs,
    List facilities,
    double latitude,
    double longitude,
    String status,
    bool highlighted,
    int startingPrice,
    String finishingType,
  }) async {
    return await compoundsCollection.doc().set({
      'agentName': agentName,
      'facilities': facilities,
      'logoURL': logoURL,
      'offer': offer,
      // 'finishingType': finishingType,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'startingPrice': startingPrice,
      'meterPrice': meterPrice,
      'paymentPlan': paymentPlan,
      'paymentPlanAr': paymentPlanAr,
      'deliveryDate': deliveryDate,
      'propertyTypes': unitTypes,
      // 'areasAndUnits': areasAndUnits,
      'date': DateTime.now(),
      'pictures': imagesURLs,
      'latitude': latitude,
      'longitude': longitude,
      'governate': governate,
      'district': district,
      'governateAr': governateAr,
      'districtAr': districtAr,
      'status': status,
      'highlighted': highlighted,
    });
  }

  List<Compound> _compoundsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Compound(
        agentName: doc.get('agentName') ?? '',
        uid: doc.id,
        name: doc.get('name') ?? '',
        nameAr: doc.get('nameAr') ?? '',
        description: doc.get('description') ?? '',
        descriptionAr: doc.get('descriptionAr') ?? '',
        locationLevel2: doc.get('district') ?? '',
        locationLevel1: doc.get('governate') ?? '',
        governateAr: doc.get('governateAr') ?? '',
        districtAr: doc.get('districtAr') ?? '',
        logoURL: doc.get('logoURL') ?? '',
        latitude: doc.get('latitude') ?? 0,
        propertyTypes: doc.get('propertyTypes') ?? [],
        facilities: doc.get('facilities') ?? [],
        offer: doc.get('offer') ?? [],
        longitude: doc.get('longitude') ?? 0,
        images: doc.get('pictures') ?? [],
        meterPrice: doc.get('meterPrice') ?? 0,
        // areasAndUnits: doc.data()['areasAndUnits'] ?? '',
        status: doc.get('status') ?? '',
        highlighted: doc.get('highlighted') ?? false,
        paymentPlan: doc.get('paymentPlan') ?? '',
        paymentPlanAr: doc.get('paymentPlanAr') ?? '',

        deliveryDate: doc.get('deliveryDate') ?? '',
        startingPrice: doc.get('startingPrice') ?? 0,
        dateTime: DateTime.parse(doc.get('date').toDate().toString()) ?? '',

        // finishingType: doc.data()['finishingType'] ?? '',
      );
    }).toList();
  }

  Future updatePropertyData({
    String description,
    String additionalInfo,
    int numberBedrooms,
    int numberBathrooms,
    int price,
    int size,
    String governate,
    String district,
    String area,
    String governateAr,
    String districtAr,
    String areaAr,
    double latitude,
    double longitude,
    String type,
    List<String> imagesURLs,
    List amenities,
    String userName,
    String userRole,
    String userNumber,
    String finishingType,
    String userId,
    String userPic,
    String userEmail,
    String userGender,
    int listingType,
    int rentType,
    // int level,
    String status,
  }) async {
    return await propertiesCollection.doc().set({
      'description': description,
      'additionalInfo': additionalInfo,
      'numberBedrooms': numberBedrooms,
      'numberBathrooms': numberBathrooms,
      'price': price,
      'type': type,
      'date': DateTime.now(),
      'pictures': imagesURLs,
      'latitude': latitude,
      'longitude': longitude,
      'governate': governate,
      'finishingType': finishingType,
      // 'level': level,
      'district': district,
      'area': area,
      'size': size,
      'listingType': listingType,
      'rentType': rentType,
      'userName': userName,
      'userPic': userPic,
      'userId': userId,
      'userNumber': userNumber,
      'userRole': userRole,
      'userEmail': userEmail,
      'userGender': userGender,
      'status': status,
      'amenities': amenities,
      'governateAr': governateAr,
      'districtAr': districtAr,
      'areaAr': areaAr,
    });
  }

  List<Property> _propertiesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Property(
        additionalInfo: doc.get('additionalInfo') ?? '',
        uid: doc.id,
        area: doc.get('area') ?? '',
        district: doc.get('district') ?? '',
        governate: doc.get('governate') ?? '',
        latitude: doc.get('latitude') ?? 0,
        listingType: doc.get('listingType') ?? 0,
        rentType: doc.get('rentType') ?? 0,
        finishingType: doc.get('finishingType') ?? '',
        dateTime: DateTime.parse(doc.get('date').toDate().toString()) ?? '',
        // level: doc.data()['level'] ?? 0,
        longitude: doc.get('longitude') ?? 0,
        numBathrooms: doc.get('numberBathrooms') ?? 0,
        description: doc.get('description') ?? '',
        numBedrooms: doc.get('numberBedrooms') ?? 0,
        images: doc.get('pictures') ?? [],
        amenities: doc.get('amenities') ?? [],
        price: doc.get('price') ?? 0,
        size: doc.get('size') ?? 0,
        propertyType: doc.get('type') ?? '',
        governateAr: doc.get('governateAr') ?? '',
        areaAr: doc.get('areaAr') ?? '',
        districtAr: doc.get('districtAr') ?? '',
        agent: UserData(
          uid: doc.get('userId') ?? '',
          name: doc.get('userName') ?? '',
          phoneNumber: doc.get('userNumber') ?? '',
          picURL: doc.get('userPic') ?? '',
          role: doc.get('userRole') ?? '',
          email: doc.get('userEmail') ?? '',
          gender: doc.get('userGender') ?? '',
        ),
        status: doc.get('status') ?? '',
      );
    }).toList();
  }

  // Future<Compound> getCompound() async {
  //   DocumentSnapshot compoundDocument =
  //       await compoundsCollection.doc('7QqYYi9a8YxciQISpD9P').get();
  //   Compound compound = Compound(
  //     uid: compoundDocument.id,
  //     name: compoundDocument.data()['name'] ?? '',
  //     nameAr: compoundDocument.data()['nameAr'] ?? '',
  //     description: compoundDocument.data()['description'] ?? '',
  //     descriptionAr: compoundDocument.data()['descriptionAr'] ?? '',
  //     locationLevel2: compoundDocument.data()['district'] ?? '',
  //     locationLevel1: compoundDocument.data()['governate'] ?? '',
  //     latitude: compoundDocument.data()['latitude'] ?? 0,
  //     logoURL: compoundDocument.data()['logoURL'] ?? '',
  //     propertyTypes: compoundDocument.data()['unitTypes'] ?? [],
  //     facilities: compoundDocument.data()['facilities'] ?? [],
  //     offer: compoundDocument.data()['offer'] ?? false,
  //     longitude: compoundDocument.data()['longitude'] ?? 0,
  //     images: compoundDocument.data()['pictures'] ?? [],
  //     meterPrice: compoundDocument.data()['meterPrice'] ?? 0,
  //     // areasAndUnits: compoundDocument.data()['areasAndUnits'] ?? '',
  //     status: compoundDocument.data()['status'] ?? '',
  //     highlighted: compoundDocument.data()['highlighted'] ?? false,
  //     paymentPlan: compoundDocument.data()['paymentPlan'] ?? '',
  //     paymentPlanAr: compoundDocument.data()['paymentPlanAr'] ?? '',
  //     deliveryDate: compoundDocument.data()['deliveryDate'] ?? '',
  //     startingPrice: compoundDocument.data()['startingPrice'] ?? 0,
  //     finishingType: compoundDocument.data()['finishingType'] ?? '',
  //   );
  //   return compound;
  // }

  Stream<List<Compound>> getCompoundsBySearch({
    bool limited,
    String status,
    String governate,
    String district,
    String area,
    bool highlighted,
    bool offer,
    String name,
  }) {
    Query query = compoundsCollection;

    if (name != '') {
      query = query.where(
        'name',
        isEqualTo: name,
      );
    }

    if (status != '') {
      query = query.where(
        'status',
        isEqualTo: status,
      );
    }

    if (highlighted != null) {
      query = query.where(
        'highlighted',
        isEqualTo: highlighted,
      );
    }

    if (governate != '') {
      query = query.where(
        'governate',
        isEqualTo: governate,
      );
    }
    if (district != '') {
      query = query.where(
        'district',
        isEqualTo: district,
      );
    }
    if (area != '') {
      query = query.where(
        'area',
        isEqualTo: area,
      );
    }
    if (offer != null) {
      query = query.where(
        'offer',
        isEqualTo: offer,
      );
    }

    return limited != null && limited == true
        ? query.limit(10).snapshots().map(_compoundsListFromSnapshot)
        : query.snapshots().map(_compoundsListFromSnapshot);
  }

  Stream<List<Property>> getPropertiesBySearch({
    bool limited,
    String status,
    String propertyType,
    int listingType,
    int rentType,
    String governate,
    String district,
    String area,
    int numberBedrooms,
    int numberBathrooms,
    int priceMin,
    int priceMax,
    int sizeMin,
    int sizeMax,
    String agentId,
  }) {
    Query query = propertiesCollection;
    if (propertyType != '') {
      query = query.where(
        'type',
        isEqualTo: propertyType,
      );
    }
    if (listingType != null) {
      query = query.where(
        'listingType',
        isEqualTo: listingType,
      );
    }
    if (listingType != null && rentType != null) {
      query = query.where(
        'rentType',
        isEqualTo: rentType,
      );
    }
    if (governate != '') {
      query = query.where(
        'governate',
        isEqualTo: governate,
      );
    }
    if (district != '') {
      query = query.where(
        'district',
        isEqualTo: district,
      );
    }
    if (area != '') {
      query = query.where(
        'area',
        isEqualTo: area,
      );
    }

    if (numberBedrooms != null) {
      query = query.where(
        'numberBedrooms',
        isEqualTo: numberBedrooms,
      );
    }
    if (numberBathrooms != null) {
      query = query.where(
        'numberBathrooms',
        isEqualTo: numberBathrooms,
      );
    }
    if (status != '') {
      query = query.where(
        'status',
        isEqualTo: status,
      );
    }

    if (agentId != '') {
      query = query.where(
        'userId',
        isEqualTo: agentId,
      );
    }

    if (priceMin != null) {
      query = query.where(
        'price',
        isGreaterThanOrEqualTo: priceMin,
      );
    }
    if (priceMax != null) {
      query = query.where(
        'area',
        isLessThanOrEqualTo: priceMax,
      );
    }

    if (sizeMin != null) {
      query = query.where(
        'size',
        isGreaterThanOrEqualTo: sizeMin,
      );
    }
    if (sizeMax != null) {
      query = query.where(
        'size',
        isLessThanOrEqualTo: sizeMax,
      );
    }

    return limited != null && limited == true
        ? query.limit(10).snapshots().map(_propertiesListFromSnapshot)
        : query.snapshots().map(_propertiesListFromSnapshot);
  }

  Future updateRequestData({
    Property property,
    String date,
    UserData user,
    Compound compound,
  }) async {
    if (compound == null) {
      return await requestsCollection.doc().set({
        'additionalInfo': property.additionalInfo,
        'numberBedrooms': property.numBedrooms,
        'numberBathrooms': property.numBathrooms,
        'price': property.price,
        'type': property.propertyType,
        'pictures': property.images,
        'latitude': property.latitude,
        'longitude': property.longitude,
        'governate': property.governate,
        'district': property.district,
        'governateAr': property.governateAr,
        'districtAr': property.districtAr,
        'areaAr': property.areaAr,
        'area': property.area,
        'size': property.size,
        'listingType': property.listingType,
        'rentType': property.rentType,
        'dateTime': DateTime.now(),
        'agentName': property.agent.name,
        'agentPic': property.agent.picURL,
        'agentId': property.agent.uid,
        'agentNumber': property.agent.phoneNumber,
        'agentRole': property.agent.role,
        'agentEmail': property.agent.email,
        'agentGender': property.agent.gender,
        'userName': user.name,
        'userPic': user.picURL,
        'userId': user.uid,
        'userNumber': user.phoneNumber,
        'userEmail': user.email,
        'userGender': user.gender,
        'status': 'pending',
        'propertyId': property.uid,
        'propertyStatus': property.status,
        'finishingType': property.finishingType,
        'amenities': property.amenities,
        'description': property.description,
        'date': date,
      });
    } else {
      return await requestsCollection.doc().set({
        'compoundID': compound.uid,
        'logoURL': compound.logoURL,
        'agentName': compound.agentName,
        // 'finishingType': compound.finishingType,
        'dateTime': DateTime.now(),
        'name': compound.name,
        'nameAr': compound.nameAr,
        'description': compound.description,
        'descriptionAr': compound.descriptionAr,
        'startingPrice': compound.startingPrice,
        'meterPrice': compound.meterPrice,
        'paymentPlan': compound.paymentPlan,
        'paymentPlanAr': compound.paymentPlanAr,
        'deliveryDate': compound.deliveryDate,
        'propertyTypes': compound.propertyTypes,
        // 'areasAndUnits': compound.areasAndUnits,
        'pictures': compound.images,
        'latitude': compound.latitude,
        'longitude': compound.longitude,
        'governate': compound.locationLevel1,
        'district': compound.locationLevel2,
        'governateAr': compound.governateAr,
        'districtAr': compound.districtAr,
        'compoundStatus': compound.status,
        'highlighted': compound.highlighted,
        'facilities': compound.facilities,
        'userName': user.name,
        'userPic': user.picURL,
        'userId': user.uid,
        'userNumber': user.phoneNumber,
        'userEmail': user.email,
        'userGender': user.gender,
        'status': 'pending',
        'date': date,
      });
    }
  }

  List<Location> _areasListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Location(
        docId: doc.id,
        type: 2,
        nameAr: doc.get('nameAr') ?? '',
      );
    }).toList();
  }

  Stream<List<Location>> getAreas(String govName, districtName) {
    return FirebaseFirestore.instance
        .collection(
            "locations/" + govName + "/districts/" + districtName + '/areas')
        .snapshots()
        .map(_areasListFromSnapshot);
  }

  List<Location> _districtsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Location(
        docId: doc.id,
        type: 1,
        nameAr: doc.get('nameAr') ?? '',
      );
    }).toList();
  }

  Stream<List<Location>> getDistricts(String govName) {
    return FirebaseFirestore.instance
        .collection("locations/" + govName + "/districts")
        .snapshots()
        .map(_districtsListFromSnapshot);
  }

  List<Location> _governatesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Location(
        docId: doc.id,
        type: 0,
        nameAr: doc.get('nameAr') ?? '',
      );
    }).toList();
  }

  Stream<List<Location>> get governates {
    return locationsCollection.snapshots().map(_governatesListFromSnapshot);
  }

  List<Request> _appointmentRequestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      if (doc.get('propertyId') != null) {
      } else {}
      return Request(
        property: doc.get('propertyId') != null
            ? Property(
                uid: doc.get('propertyId') ?? '',
                area: doc.get('area') ?? '',
                district: doc.get('district') ?? '',
                governate: doc.get('governate') ?? '',
                governateAr: doc.get('governateAr') ?? '',
                districtAr: doc.get('districtAr') ?? '',
                areaAr: doc.get('areaAr') ?? '',
                latitude: doc.get('latitude') ?? 0,
                listingType: doc.get('listingType') ?? 0,
                rentType: doc.get('rentType') ?? 0,
                longitude: doc.get('longitude') ?? 0,
                numBathrooms: doc.get('numberBathrooms') ?? 0,
                numBedrooms: doc.get('numberBedrooms') ?? 0,
                finishingType: doc.get('finishingType') ?? '',
                amenities: doc.get('amenities') ?? [],
                additionalInfo: doc.get('additionalInfo') ?? '',
                description: doc.get('description') ?? '',
                images: doc.get('pictures') ?? [],
                price: doc.get('price') ?? 0,
                size: doc.get('size') ?? 0,
                propertyType: doc.get('type') ?? '',
                agent: UserData(
                  uid: doc.get('agentId') ?? '',
                  name: doc.get('agentName') ?? '',
                  phoneNumber: doc.get('agentNumber') ?? '',
                  picURL: doc.get('agentPic') ?? '',
                  role: doc.get('agentRole') ?? '',
                ),
                status: doc.get('propertyStatus') ?? '',
              )
            : null,
        compound: doc.get('compoundID') != null
            ? Compound(
                uid: doc.get('compoundID') ?? '',
                name: doc.get('name') ?? '',
                nameAr: doc.get('nameAr') ?? '',
                description: doc.get('description') ?? '',
                descriptionAr: doc.get('descriptionAr') ?? '',
                locationLevel2: doc.get('district') ?? '',
                locationLevel1: doc.get('governate') ?? '',
                governateAr: doc.get('governateAr') ?? '',
                districtAr: doc.get('districtAr') ?? '',
                facilities: doc.get('facilities') ?? [],
                agentName: doc.get('agentName') ?? '',
                logoURL: doc.get('logoURL') ?? '',
                latitude: doc.get('latitude') ?? 0,
                propertyTypes: doc.get('propertyTypes') ?? [],
                longitude: doc.get('longitude') ?? 0,
                images: doc.get('pictures') ?? [],
                meterPrice: doc.get('meterPrice') ?? 0,
                areasAndUnits: doc.get('areasAndUnits') ?? '',
                status: doc.get('status') ?? '',
                highlighted: doc.get('highlighted') ?? false,
                paymentPlan: doc.get('paymentPlan') ?? '',
                paymentPlanAr: doc.get('paymentPlanAr') ?? '',
                deliveryDate: doc.get('deliveryDate') ?? '',
                startingPrice: doc.get('startingPrice') ?? 0,
                // finishingType: doc.data()['finishingType'] ?? '',
              )
            : null,
        uid: doc.id,
        userId: doc.get('userId') ?? '',
        userName: doc.get('userName') ?? '',
        userNumber: doc.get('userNumber') ?? '',
        userPic: doc.get('userPic') ?? '',
        status: doc.get('status') ?? '',
        date: doc.get('date') ?? '',
        dateTime: DateTime.parse(doc.get('dateTime').toDate().toString()) ?? '',
      );
    }).toList();
  }

  Stream<List<Request>> getAppointmentRequestsBySearch({String status}) {
    Query query = requestsCollection;
    if (status != '') {
      query = query.where(
        'status',
        isEqualTo: status,
      );
    }
    return query
        .orderBy('status')
        .snapshots()
        .map(_appointmentRequestsListFromSnapshot);
  }

  Future updateAppointmentRequestStatus({
    String status,
    String requestId,
  }) async {
    try {
      await requestsCollection.doc(requestId).update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updatePropertyStatus({
    String status,
    String propertyID,
  }) async {
    try {
      await propertiesCollection.doc(propertyID).update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateCompoundStatus({
    String status,
    String compoundId,
  }) async {
    try {
      await compoundsCollection.doc(compoundId).update({
        'status': status,
      });
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String> getUserRole() async {
    DocumentSnapshot s =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // FirebaseMessaging _messaging = FirebaseMessaging();
    // String deviceToken = await _messaging.getToken();
    // String role = s.data()['role'];
    return s.get('role');
  }
}
