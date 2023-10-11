class Crypto {
  String id;
  String name;
  String symbol;
  double priceUsd;
  double changePercent24Hr;
  int rank;

  Crypto(this.id, this.name, this.symbol, this.priceUsd, this.changePercent24Hr,
      this.rank);

  factory Crypto.fromMapJson(Map<String, dynamic> jsonMapObject) {
    return Crypto(
      jsonMapObject['id'],
      jsonMapObject['name'],
      jsonMapObject['symbol'],
      double.parse(jsonMapObject['priceUsd']),
      double.parse(jsonMapObject['changePercent24Hr']),
      int.parse(jsonMapObject['rank']),
    );
  }
}
