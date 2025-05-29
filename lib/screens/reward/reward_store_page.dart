import 'package:flutter/material.dart';
import 'package:typecash_flutter_app/utils/number_format_util.dart';

class RewardStorePage extends StatefulWidget {
  static const routeName = '/reward-store';

  const RewardStorePage({super.key});

  @override
  State<RewardStorePage> createState() => _RewardStorePageState();
}

class _RewardStorePageState extends State<RewardStorePage> {
  @override
  Widget build(BuildContext context) {
    // 사용자의 현재 포인트 표시
    final userPoints = NumberFormatUtil.formatNumber(9999000);

    return Scaffold(
      appBar: AppBar(title: const Text('포인트 교환')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 포인트 표시
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '현재 보유 포인트: $userPoints',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 교환 가능한 상품권 목록
            const Text(
              '교환 가능한 상품권',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 상품권 목록을 표시할 Expanded 위젯
            Expanded(
              child: ListView(
                children: [
                  // 여기에 상품권 아이템들을 추가
                  _buildGiftCardItem('Google Play 기프트 카드', 10000, 10000),
                  _buildGiftCardItem('아마존 기프트 카드', 30000, 30000),
                  _buildGiftCardItem('스타벅스 기프트 카드', 5000, 5000),
                  // 추가 상품권...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftCardItem(String name, int points, int value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.card_giftcard, size: 40),
        title: Text(name),
        subtitle: Text('${NumberFormatUtil.formatNumber(points)} 포인트'),
        trailing: ElevatedButton(
          onPressed: () {
            // 교환 로직 구현
            _showExchangeDialog(name, points, value);
          },
          child: const Text('교환하기'),
        ),
      ),
    );
  }

  void _showExchangeDialog(String name, int points, int value) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('상품권 교환'),
            content: Text(
              '$name (${NumberFormatUtil.formatNumber(value)}원)을 교환하시겠습니까?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  // 실제 교환 처리 로직
                  Navigator.pop(context);
                  // 성공 메시지 표시
                },
                child: const Text('교환'),
              ),
            ],
          ),
    );
  }
}
