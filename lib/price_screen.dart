import 'package:bitcoin_ticker/currency_card.dart';
import 'package:bitcoin_ticker/utilities/exchange_fetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'USD';
  final List<CurrencyCard> _cardList = [];

  @override
  void initState() {
    super.initState();
    updateCurrencyCards();
  }

  Future updateCurrencyCards() async {
    for (String crypto in cryptoList) {
      final String exchange = await getExchangeRate(crypto);
      final CurrencyCard newCard = CurrencyCard(
        cryptoName: crypto,
        currency: _selectedCurrency,
        exchangeRate: exchange,
      );
      final int index =
          _cardList.indexWhere((card) => card.cryptoName == crypto);

      if (index == -1) {
        setState(() {
          _cardList.add(newCard);
        });
      } else {
        setState(() {
          _cardList[index] = newCard;
        });
      }
    }
  }

  DropdownButton<String> getAndroidPicker() {
    final List<DropdownMenuItem<String>> menuItemList = [];

    for (String currency in currenciesList) {
      final newMenuItem = DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      );

      menuItemList.add(newMenuItem);
    }

    return DropdownButton<String>(
      value: _selectedCurrency,
      onChanged: (value) {
        _selectedCurrency = value;
        updateCurrencyCards();
      },
      items: menuItemList,
    );
  }

  CupertinoPicker getIOSPicker() {
    final List<Text> menuItemList = [];

    for (String currency in currenciesList) {
      final newMenuItem = Text(
        currency,
        style: TextStyle(
          color: Colors.white,
        ),
      );

      menuItemList.add(newMenuItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 38.0,
      onSelectedItemChanged: (selectedIndex) {
        _selectedCurrency = currenciesList[selectedIndex];
        updateCurrencyCards();
      },
      children: menuItemList,
    );
  }

  Future<String> getExchangeRate(String crypto) async {
    final double exchangeRate =
        await ExchangeFetcher.getExchangeRate(crypto, _selectedCurrency);
    return exchangeRate.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _cardList,
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}
