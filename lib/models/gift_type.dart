enum GiftType {
  naverPoint,
  starbucks,
  amazon,
  googlePlay,
  appleStore,
  paypal,
  giftCard,
  coupon,
  cash,
}

// GiftType을 숫자로 매핑
const Map<GiftType, int> giftTypeToNumber = {
  GiftType.naverPoint: 1,
  GiftType.starbucks: 2,
  GiftType.amazon: 3,
  GiftType.googlePlay: 4,
  GiftType.appleStore: 5,
  GiftType.paypal: 6,
  GiftType.giftCard: 7,
  GiftType.coupon: 8,
  GiftType.cash: 9,
};

// GiftType을 한국어로 매핑
const Map<GiftType, String> giftTypeToKorean = {
  GiftType.naverPoint: '네이버 포인트',
  GiftType.starbucks: '스타벅스',
  GiftType.amazon: '아마존',
  GiftType.googlePlay: '구글 플레이',
  GiftType.appleStore: '애플 스토어',
  GiftType.paypal: '페이팔',
  GiftType.giftCard: '상품권',
  GiftType.coupon: '쿠폰',
  GiftType.cash: '현금',
};

// 서버에서 받은 문자열을 GiftType으로 변환
GiftType? stringToGiftType(String value) {
  switch (value) {
    case 'naver_point':
      return GiftType.naverPoint;
    case 'starbucks':
      return GiftType.starbucks;
    case 'amazon':
      return GiftType.amazon;
    case 'google_play':
      return GiftType.googlePlay;
    case 'apple_store':
      return GiftType.appleStore;
    case 'paypal':
      return GiftType.paypal;
    case 'gift_card':
      return GiftType.giftCard;
    case 'coupon':
      return GiftType.coupon;
    case 'cash':
      return GiftType.cash;
    default:
      return null;
  }
}

// GiftType을 서버에서 사용하는 문자열로 변환
String giftTypeToString(GiftType giftType) {
  switch (giftType) {
    case GiftType.naverPoint:
      return 'naver_point';
    case GiftType.starbucks:
      return 'starbucks';
    case GiftType.amazon:
      return 'amazon';
    case GiftType.googlePlay:
      return 'google_play';
    case GiftType.appleStore:
      return 'apple_store';
    case GiftType.paypal:
      return 'paypal';
    case GiftType.giftCard:
      return 'gift_card';
    case GiftType.coupon:
      return 'coupon';
    case GiftType.cash:
      return 'cash';
  }
}