import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bitcoin_ticker/utilities/constants.dart';

class ExchangeFetcher {
  static Future<double> getExchangeRate(String crypto, String currency) async {
    final String apiKey = DotEnv().env['API_KEY'];
    final String url = '$kApiUriBase/$crypto/$currency';
    final Map<String, String> headers = {
      'X-CoinAPI-Key': apiKey,
    };

    final http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final dynamic json = jsonDecode(response.body);
      final double result = json['rate'];
      return result;
    }

    return -1;
  }
}
