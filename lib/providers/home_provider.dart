import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/models/user_model.dart';
import 'package:typecash_flutter_app/providers/mission_provider.dart';
import 'package:typecash_flutter_app/providers/user_provider.dart';

class HomeProvider with ChangeNotifier {
  bool _isRefreshing = false;

  bool get isRefreshing => _isRefreshing;

  HomeProvider() {
    debugPrint('HomeProvider 생성됨');
  }

  Future<void> refreshHomeData(BuildContext context) async  {
    if(_isRefreshing) return;

    _isRefreshing = true;
    notifyListeners();

    try {
      await Future.wait([
        Provider.of<MissionProvider>(context, listen: false).fetchDailyMissionSummary(),
        Provider.of<UserProvider>(context, listen: false).fetchUserProfile(),
      ]);
    } catch (error) {
      debugPrint('Error occurred while refreshing home data: $error');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  String getCurrentFormattedDate() {
    final now = DateTime.now();
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    debugPrint('HomeProvider 제거됨');
    super.dispose();
  }
}
