import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';
import 'package:typecash_flutter_app/providers/home_provider.dart';
import 'package:typecash_flutter_app/widgets/app_logo_wide_widget.dart';
import 'package:typecash_flutter_app/widgets/home/hour_timer_widget.dart';
import 'package:typecash_flutter_app/widgets/home/mission_status_section_widget.dart';
import 'package:typecash_flutter_app/widgets/home/mission_unavailable_widget.dart';
import 'package:typecash_flutter_app/widgets/home/service_tips_slide_widget_2.dart';
import 'package:typecash_flutter_app/widgets/home/typing_mission_section_widget.dart';
import 'package:typecash_flutter_app/widgets/home/user_info_section_widget.dart';

class TypecashHomePage extends StatefulWidget {
  static const routeName = '/typecash-home';
  const TypecashHomePage({super.key});

  @override
  State<TypecashHomePage> createState() => _TypecashHomePageState();
}

class _TypecashHomePageState extends State<TypecashHomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final missionProvider = Provider.of<MissionProvider>(
        context,
        listen: false,
      );
      if (missionProvider.missionSummary == null) {
        missionProvider.fetchDailyMissionSummary();
      } else {
        debugPrint('이미 미션 데이터가 로드되어 있습니다.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppLogoWideWidget(imageHeight: 120),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.grey[200],
      body: Consumer<MissionProvider>(
        builder: (context, missionProvider, _) {
          if (missionProvider.isLoading &&
              missionProvider.missionSummary == null) {
            missionProvider.fetchDailyMissionSummary();
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh:
                () => Provider.of<HomeProvider>(
                  context,
                  listen: false,
                ).refreshHomeData(context),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserInfoSectionWidget(),
                      MissionStatusSectionWidget(),
                      ...(missionProvider.missionSummary != null && missionProvider.missionSummary!.currentMission.available
                          ? [
                            TypingMissionSectionWidget(),
                            SizedBox(height: 15),
                            HourTimerWidget(),
                          ]
                          : [
                            SizedBox(height: 15),
                            MissionUnavailableWidget(alreadyCompleted: false),
                          ]),
                      SizedBox(height: 15),
                      // ServiceTipsSlideWidget(),
                      ServiceTipsSlideWidget2(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
