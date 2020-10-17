class MoneyFormat {
  String price;

  String moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      return value;
    }
  }

  String moneyVNDFormat(int price) {
    String str_price;

    if (price == 0) return "0";

    int _bilion = (price / 1000000000).toInt();
    int _million = ((price % 1000000000) / 1000000).toInt();
    int _thousand = ((price % 1000000) / 1000).toInt();
    int _unit = (price % 1000).toInt();

    str_price = ((_bilion == 0) ? "" : (_bilion.toString() + ".")) +
        ((_million == 0) ? "" : (_million.toString() + ".")) +
        ((_thousand == 0) ? "" : (_thousand.toString() + ".")) +
        ((_unit == 0) ? "000" : (_unit).toString());
    return str_price;
  }
}

final moneyFormat = new MoneyFormat();
