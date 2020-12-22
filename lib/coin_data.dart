import 'package:bitcoin_ticker/utilities/exchange_fetcher.dart';
import 'package:bitcoin_ticker/utilities/constants.dart';

class ExchangeRate {
  ExchangeRate({this.crypto, this.currency, this.exchange})
      : _timestamp = DateTime.now().add(Duration(minutes: 5));

  final String crypto;
  final String currency;
  final double exchange;
  final DateTime _timestamp;
}

class CoinData {
  final List<String> cryptoCurrencies = cryptoList;
  final List<String> worldCurrencies = currenciesList;
  final List<ExchangeRate> exchangeRates = [];

  Future<double> getExchangeRate(String crypto, String currency) async {
    int index = exchangeRates
        .indexWhere((er) => er.crypto == crypto && er.currency == currency);

    if (index == -1 ||
        exchangeRates[index]._timestamp.isBefore(DateTime.now())) {
      final double exchangeRate =
          await ExchangeFetcher.getExchangeRate(crypto, currency);
      final ExchangeRate newRate = ExchangeRate(
        crypto: crypto,
        currency: currency,
        exchange: exchangeRate,
      );

      exchangeRates.add(newRate);
      index = exchangeRates.length - 1;
    }

    return exchangeRates[index].exchange;
  }

  Future getAllRatesForCurrency(String currency) async {
    for (String crypto in cryptoCurrencies) {
      await getExchangeRate(crypto, currency);
    }
  }
}
