import 'package:intl/intl.dart';

const hostUrl = 'https://trongnv.me';

String formatImageUrl(String url) {
  if (url.contains("http")) {
    return url;
  }
  return hostUrl + url;
}

final currencyFormat = new NumberFormat("#,##0", "vi_VN");

String formatCurrencyD(double m) {
  return currencyFormat.format(m) + "đ";
}
