class Currency {
  String? name;
  String? code;
  String? symbol;
  String? flag;

  Currency({required this.code,
    required this.name,
    required this.flag,
    required this.symbol});

  factory Currency.fromJson({required Map<String, dynamic> json}){
    return Currency(
        code: json['code'],
        name: json['name'],
        flag: json['flag'],
        symbol: json['symbol']
    );
  }

}
