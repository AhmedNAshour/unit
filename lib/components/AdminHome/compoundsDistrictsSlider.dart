import 'package:flutter/material.dart';
import 'package:unit/screens/shared/compounds_search.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompoundsDistrictsSlider extends StatelessWidget {
  CompoundsDistrictsSlider({
    Key key,
  }) : super(key: key);

  final List districts = [
    {
      'name': 'Offers',
      'nameAr': 'Offers',
      'img': 'assets/images/offers.svg',
      'gov': 'Cairo',
    },
    {
      'name': 'New Cairo',
      'nameAr': 'التجمع',
      'img': 'assets/images/tagamo3.svg',
      'gov': 'Cairo',
    },
    {
      'name': 'El-Alamen',
      'nameAr': 'العلامين',
      'img': 'assets/images/3alamen.svg',
      'gov': 'Marsa Matrouh',
    },
    {
      'name': 'El-Galala',
      'nameAr': 'الجلالة',
      'img': 'assets/images/galala.svg',
      'gov': 'Suez',
    },
    {
      'name': 'North Coast',
      'nameAr': 'الساحل الشمالي',
      'img': 'assets/images/coast.svg',
      'gov': 'Marsa Matrouh',
    },
    {
      'name': 'Sokhna',
      'nameAr': 'العين السخنة',
      'img': 'assets/images/sokhna.svg',
      'gov': 'Suez',
    },
    {
      'name': 'Zayed',
      'nameAr': 'زايد',
      'img': 'assets/images/zayed.svg',
      'gov': '6th October',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: districts.length,
        itemBuilder: (context, index) {
          return districts[index]['name'] == 'Offers'
              ? Container(
                  width: size.height * 0.18,
                  height: size.height * 0.175,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CompoundsSearch.id,
                          arguments: {
                            'offer': true,
                          });
                    },
                    child: Container(
                      // width: size.width,
                      height: size.height * 0.25,
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        clipBehavior: Clip.antiAlias,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: size.height * 0.18,
                              height: size.height * 0.175,
                              child: SvgPicture.asset(
                                'assets/images/offers.svg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, CompoundsSearch.id,
                        arguments: {
                          'district': districts[index]['name'],
                          'governate': districts[index]['gov'],
                          'offer': false,
                        });
                  },
                  child: Container(
                    width: size.width * 0.73,
                    height: size.height * 0.175,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: size.width * 0.73,
                            height: size.height * 0.175,
                            child: SvgPicture.asset(
                              districts[index]['img'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
