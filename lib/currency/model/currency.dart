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

  Map<String,dynamic> toJson() {
    return {
      if(name != null) 'name':name,
      if(code != null) 'code':code,
      if(symbol != null) 'symbol':symbol,
      if(flag != null) 'flag':flag,
    };
  }

}
