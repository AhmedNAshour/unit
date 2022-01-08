import 'package:flutter/material.dart';
import 'package:unit/screens/shared/properties_search.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PropertyTypesSlider extends StatelessWidget {
  PropertyTypesSlider({
    Key key,
  }) : super(key: key);

  final List categories = [
    {
      'name': 'Apartments',
      'nameAr': 'شقق',
      'img': 'assets/images/apartments.svg'
    },
    {'name': 'Villas', 'nameAr': 'فيلات', 'img': 'assets/images/villas.svg'},
    {
      'name': 'Commercial/Administrative/Medical',
      'nameAr': 'تجاري',
      'img': 'assets/images/commercial.svg'
    },
    {
      'name': 'Vacation',
      'nameAr': 'مصايف',
      'img': 'assets/images/vacation.svg'
    },
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      // height: size.height * 0.15,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PropertiesSearch.id, arguments: {
                    'propertyType': 0,
                  });
                },
                child: Container(
                  width: size.width * 0.45,
                  height: size.width * 0.35,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: size.width * 0.45,
                          height: size.width * 0.35,
                          child: SvgPicture.asset(
                            categories[0]['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PropertiesSearch.id, arguments: {
                    'propertyType': 1,
                  });
                },
                child: Container(
                  width: size.width * 0.45,
                  height: size.width * 0.35,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: size.width * 0.45,
                          height: size.width * 0.35,
                          child: SvgPicture.asset(
                            categories[1]['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PropertiesSearch.id, arguments: {
                    'propertyType': 2,
                  });
                },
                child: Container(
                  width: size.width * 0.45,
                  height: size.width * 0.35,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: size.width * 0.45,
                          height: size.width * 0.35,
                          child: SvgPicture.asset(
                            categories[2]['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PropertiesSearch.id, arguments: {
                    'propertyType': 3,
                  });
                },
                child: Container(
                  width: size.width * 0.45,
                  height: size.width * 0.35,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: size.width * 0.45,
                          height: size.width * 0.35,
                          child: SvgPicture.asset(
                            categories[3]['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
