import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/location.dart';
import 'package:unit/screens/admin/admin_addCompound_screen.dart';
import 'package:unit/screens/admin/admin_addLocation_area.dart';
import 'package:unit/screens/admin/admin_addLocation_district.dart';
import 'package:unit/screens/admin/admin_addLocation_governate.dart';
import 'package:unit/screens/admin/addResale_screen.dart';
import 'package:unit/screens/admin/admin_addSalesman_screen.dart';
import 'package:unit/screens/shared/clients.dart';
import 'package:unit/screens/shared/compound_info.dart';
import 'package:unit/screens/shared/compounds_search.dart';
import 'package:unit/screens/shared/listings.dart';
import 'package:unit/screens/shared/map.dart';
import 'package:unit/screens/shared/openMap.dart';
import 'package:unit/screens/shared/otherProfile.dart';
import 'package:unit/screens/shared/property_info.dart';
import 'package:unit/screens/shared/properties_search.dart';
import 'package:unit/screens/admin/selectLocation_area.dart';
import 'package:unit/screens/admin/selectLocation_district.dart';
import 'package:unit/screens/admin/selectLocation_governate.dart';
import 'package:unit/screens/shared/salesmen.dart';
import 'package:unit/screens/shared/wrapper.dart';
import 'package:unit/services/auth.dart';
import 'package:unit/services/database.dart';
import 'package:unit/translations/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
// import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      path: 'assets/langs',
      startLocale: Locale('ar'),
      supportedLocales: [
        Locale('ar'),
        Locale('en'),
      ],
      assetLoader: const CodegenLoader(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser>.value(value: AuthService().user),
        StreamProvider<List<Location>>.value(
            value: DatabaseService().governates),
      ],
      child: MaterialApp(
        // locale: DevicePreview.locale(context), // Add the locale here
        // builder: DevicePreview.appBuilder,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(fontFamily: 'Roboto', backgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          AdminAddSalesman.id: (context) => AdminAddSalesman(),
          AdminAddCompound.id: (context) => AdminAddCompound(),
          AddResale.id: (context) => AddResale(),
          AdminAddGovernate.id: (context) => AdminAddGovernate(),
          AdminAddDistrict.id: (context) => AdminAddDistrict(),
          AdminAddArea.id: (context) => AdminAddArea(),
          SelectArea.id: (context) => SelectArea(),
          SelectDistrict.id: (context) => SelectDistrict(),
          SelectGovernate.id: (context) => SelectGovernate(),
          PropertyInfo.id: (context) => PropertyInfo(),
          CompoundInfo.id: (context) => CompoundInfo(),
          PropertiesSearch.id: (context) => PropertiesSearch(),
          Listings.id: (context) => Listings(),
          Clients.id: (context) => Clients(),
          Salesmen.id: (context) => Salesmen(),
          OtherProfile.id: (context) => OtherProfile(),
          MapSelect.id: (context) => MapSelect(),
          MapOpen.id: (context) => MapOpen(),
          CompoundsSearch.id: (context) => CompoundsSearch(),
        },
      ),
    );
  }
}
