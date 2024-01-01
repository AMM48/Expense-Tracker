// ignore: file_names
List<dynamic> extractAlahli(String message) {
  List<String> lines = message.split('\n');
  String? priceLine = lines[1];
  RegExp? priceRegex = RegExp(r'(\d+(\.\d+)?)');
  Match? priceMatch = priceRegex.firstMatch(priceLine) as Match;
  double? price = double.parse(priceMatch.group(1) ?? '0');
  const conversionRates = {
    'usd': 3.75,
    'eur': 4.01,
    'gbp': 4.58,
  };
  String merchantLine = lines[2];
  List<String> merchantWords = merchantLine.split(' ');
  String merchantName = "Null";

  if (message.contains("دولي")) {
    priceRegex = RegExp(r'(\d+(\.\d+)?)\s*(usd|sar|eur|gbp)?');
    priceMatch = priceRegex.firstMatch(lines[3]);
    if (priceMatch != null) {
      price = double.parse(priceMatch.group(1)!);
      String currency = priceMatch.group(3) ?? 'SAR';
      if (currency != 'SAR') {
        double? rate = conversionRates[currency];
        if (rate != null) {
          price *= rate;
        }
      }

      merchantName = lines[4].split(' ').sublist(1).join(' ');
    }
  } else if (message.contains("من") || message.contains("purchase")) {
    merchantName = merchantWords.sublist(1).join(' ');
  } else if (message.contains("اسم المتجر")) {
    merchantName = merchantWords.sublist(2).join(' ');
  } else if (message.contains("ل")) {
    int indexOfL = merchantLine.indexOf("ل");
    if (indexOfL != -1) {
      merchantName = merchantLine.substring(indexOfL + 1).trim();
    }
  }
  return [merchantName, price];
}
