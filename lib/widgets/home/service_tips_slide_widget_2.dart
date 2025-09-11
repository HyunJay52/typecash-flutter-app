import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ServiceTipsSlideWidget2 extends StatelessWidget {
  final List<String> images = [
    'assets/images/rounded_tip1_image.png',
    'assets/images/rounded_tip2_image.png',
    'assets/images/rounded_tip3_image.png',
    'assets/images/rounded_tip4_image.png',
    'assets/images/rounded_tip5_image.png',
  ];

  ServiceTipsSlideWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 130,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 150,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: [
              ...images.map((image) => Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ))
            ],
          )
        ),
      ],
    );
  }
}
