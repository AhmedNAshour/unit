import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';

class PropertyImages extends StatelessWidget {
  const PropertyImages({
     Key key,
    this.images,
  }) : super(key: key);

  final List images;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      child: images.isNotEmpty
          ? Swiper(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => HeroPhotoViewRouteWrapper(
                    //         imageProvider: NetworkImage(images[index])),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              },
              itemCount: images.length,
              pagination:
                  SwiperPagination(margin: EdgeInsets.all(size.height * 0.12)),
            )
          : Image.asset(
              'assets/images/propertyPlaceholder.png',
              fit: BoxFit.cover,
            ),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatefulWidget {
  const HeroPhotoViewRouteWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  _HeroPhotoViewRouteWrapperState createState() =>
      _HeroPhotoViewRouteWrapperState();
}

class _HeroPhotoViewRouteWrapperState extends State<HeroPhotoViewRouteWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: widget.imageProvider,
        backgroundDecoration: widget.backgroundDecoration,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
