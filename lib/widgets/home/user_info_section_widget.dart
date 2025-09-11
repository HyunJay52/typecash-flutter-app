import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/user_provider.dart';
import 'package:typecash_flutter_app/providers/home_provider.dart';
import 'package:typecash_flutter_app/screens/reward/reward_store_page.dart';
import 'package:typecash_flutter_app/utils/number_format_util.dart';

class UserInfoSectionWidget extends StatelessWidget {
  const UserInfoSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset('assets/images/calendar.png', width: 40),
              const SizedBox(width: 5),
              Text(
                homeProvider.getCurrentFormattedDate(),
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/reward.png', width: 40),
                  const SizedBox(width: 5),
                  const Text('내가 모은 포인트:', style: TextStyle(fontSize: 17)),
                  Text(
                    ' ${NumberFormatUtil.formatNumber(userProvider.rewardBalance)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed:
                    () =>
                        Navigator.pushNamed(context, RewardStorePage.routeName),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 231, 240),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '신청하기',
                      style: TextStyle(fontSize: 17, color: Color(0xFFC97DA1)),
                    ),
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
