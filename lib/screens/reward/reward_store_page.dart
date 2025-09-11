import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typecash_flutter_app/providers/reward_provider.dart';
import 'package:typecash_flutter_app/providers/user_provider.dart';
import 'package:typecash_flutter_app/utils/number_format_util.dart';

// enum ExchangeStep {
//   initial, // 초기 확인 단계
//   phoneInput, // 휴대폰 번호 입력 단계
//   completed, // 신청 완료 단계
// }

class RewardStorePage extends StatefulWidget {
  static const routeName = '/reward-store';

  const RewardStorePage({super.key});

  @override
  State<RewardStorePage> createState() => _RewardStorePageState();
}

class _RewardStorePageState extends State<RewardStorePage> {
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final rewardProvider = Provider.of<RewardProvider>(context);
    // 사용자의 현재 포인트 표시

    return Scaffold(
      appBar: AppBar(
        title: const Text('모바일 교환권', style: TextStyle(fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
                    Image.asset('assets/images/reward.png', width: 30),
                    const SizedBox(width: 10),
                    Text('내가 모은 포인트:', style: TextStyle(fontSize: 18)),
                    Text(
                      ' ${NumberFormatUtil.formatNumber(userProvider.rewardBalance)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 교환 가능한 상품권 목록
            const Text(
              '교환 가능한 상품권',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 상품권 목록을 표시할 Expanded 위젯
            Expanded(
              child: ListView.builder(
                itemCount: rewardProvider.rewardItems.length,
                itemBuilder: (context, index) {
                  final item = rewardProvider.rewardItems[index];
                  return _buildGiftCardItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftCardItem(RewardItem item) {
    final rewardProvider = Provider.of<RewardProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        // leading: const Icon(Icons.card_giftcard, size: 20),
        leading: Image.asset(
          'assets/images/reward.png',
          width: 30,
          fit: BoxFit.cover,
        ),
        title: Text(item.name),
        subtitle: Text('${NumberFormatUtil.formatNumber(item.points)} 포인트'),
        trailing: ElevatedButton(
          onPressed: () {
            // 교환 로직 구현
            rewardProvider.selectRewardItem(item);
            _showExchangeDialog();
          },
          child: const Text('교환하기'),
        ),
      ),
    );
  }

  void _showExchangeDialog() {
    // showDialog 대신 showGeneralDialog 사용
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Consumer<RewardProvider>(
          builder: (context, rewardProvider, child) {
            return SafeArea(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildExchangeContent(rewardProvider),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return FadeTransition(
          opacity: animation1,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation1,
              curve: Curves.easeOutQuad,
            ),
            child: child,
          ),
        );
      },
    );
  }

  // 현재 단계에 따른 컨텐츠 위젯 반환
  Widget _buildExchangeContent(RewardProvider rewardProvider) {
    switch (rewardProvider.currentStep) {
      case ExchangeStep.initial:
        return _buildInitialStep(rewardProvider);
      case ExchangeStep.phoneInput:
        return _buildPhoneInputContent(rewardProvider);
      case ExchangeStep.completed:
        return _buildCompletedContent(rewardProvider);
    }
  }

  Widget _buildInitialStep(RewardProvider rewardProvider) {
    final item = rewardProvider.selectedItem;

    return item != null ? Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "상품권 신청",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          "${item.value}원 ${item.name}를 신청하시겠어요? ${item.points} 포인트가 차감되어 신청이 완료됩니다. 영업일 3일 내 휴대폰 문자로 발송됩니다",
          textAlign: TextAlign.center,
          style: const TextStyle(height: 1.7, fontSize: 17),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소", style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                // 다음 단계(휴대폰 번호 입력)로 이동
                rewardProvider.setStep(ExchangeStep.phoneInput);
              },
              child: const Text("확인", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ],
    ) 
    : const Center(
        child: Text(
          "교환할 상품권을 선택해 주세요.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
  }

  // * 휴대폰 번호 입력 위젯
  Widget _buildPhoneInputContent(RewardProvider rewardProvider) {
    // 모달 내용물의 최대 높이 설정
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      width: double.maxFinite,
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    "휴대폰 번호 입력",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "포인트를 받을 휴대폰 번호를 입력해 주세요.",
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "휴대폰 번호 입력",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rewardProvider.phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '01012345678',
                hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "휴대폰 번호 재입력",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rewardProvider.phoneConfirmController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '01012345678',
                hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                border: const OutlineInputBorder(),
                errorText:
                    rewardProvider.hasPhoneError
                        ? rewardProvider.phoneErrorMessage
                        : null,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "⚠️  주의 사항",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "- 숫자만 입력해 주세요 (예: 01012345678)",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "- 정확한 번호로 입력하지 않으면 발송이 실패할 수 있습니다.",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "- 번호 입력 오류로 인한 상품권 미수령 시 재발송은 어렵습니다.",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.grey[350],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed:
                      rewardProvider.isProcessing
                          ? null
                          : () => rewardProvider.setStep(ExchangeStep.initial),
                  child: const Text("뒤로", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed:
                      rewardProvider.isProcessing
                          ? null
                          : () async {
                            final userProvider = Provider.of<UserProvider>(
                              context,
                              listen: false,
                            );
                            
                            await rewardProvider.processExchange(userProvider);
                          },
                  child:
                      rewardProvider.isProcessing
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            "다음",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // * 완료 단계 위젯
  Widget _buildCompletedContent(RewardProvider rewardProvider) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "신청이 완료되었습니다!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "영업일 3일 내 입력한 휴대폰 번호로\n포인트가 지급됩니다.",
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5, fontSize: 17),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 0),
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                // 다이얼로그 닫기
                Navigator.pop(context);

                // 완료 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${rewardProvider.selectedItem!.name} 교환이 완료되었습니다.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                // 리워드 프로바이더 초기화
                rewardProvider.resetAfterExchange();
              },
              child: const Text("확인", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
