import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ServiceTipsSlideWidget extends StatelessWidget {
  const ServiceTipsSlideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 130, // Reduced height
            child: CarouselSlider(
              options: CarouselOptions(
                height: 130, // Reduced height
                aspectRatio: 16 / 9,
                viewportFraction: 0.85,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: [
                _buildTipCard(
                  gradient: LinearGradient(
                    colors: [
                    const Color.fromARGB(255, 117, 235, 248),
                    const Color.fromARGB(255, 112, 107, 254),
                  ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.keyboard,
                  title: '정답은 정확히\n입력해야 인정돼요',
                  description: '한 글자라도 틀리면 입력 완료가 안 돼요',
                ),
                _buildTipCard(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 117, 235, 248), const Color.fromARGB(255, 112, 107, 254)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.store,
                  title: '입력은\n1시간마다 가능해요',
                  description: '다음 문장까지 남은 시간을 확인해주세요',
                ),
                _buildTipCard(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 117, 235, 248), const Color.fromARGB(255, 112, 107, 254)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.emoji_events,
                  title: '하루 13문장 모두\n입력하면 최대 보상!',
                  description: '꾸준히 참여하고 많은 포인트를 받으세요',
                ),
                _buildTipCard(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 117, 235, 248), const Color.fromARGB(255, 112, 107, 254)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.emoji_events,
                  title: '광고 시청 후\n포인트를 수령하세요',
                  description: '입력만으로는 보상이 안 들어가요',
                ),
                _buildTipCard(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 117, 235, 248), const Color.fromARGB(255, 112, 107, 254)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.emoji_events,
                  title: '곧 알림 기능이\n생겨요!',
                  description: '새 문장이 열릴 때 바로 알려드릴게요',
                ),
              ],
            ),
          ),
        ],
      );
  }

  // Helper method to build tip cards for the carousel
  Widget _buildTipCard({
    required LinearGradient gradient,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tip',
                    style: TextStyle(
                      color: Colors.black.withAlpha(80),
                      fontSize: 14, // Smaller font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Smaller font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5), // Less spacing
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10, // Smaller font size
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            const SizedBox(width: 10), // Less spacing
            Container(
              width: 70, // Smaller icon container
              height: 70, // Smaller icon container
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24), // Smaller icon
            ),
          ],
        ),
      ),
    );
  }
}
