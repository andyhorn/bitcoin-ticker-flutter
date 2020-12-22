import 'package:bitcoin_ticker/currency_card.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'USD';
  final CoinData coinData = CoinData();
  final List<CurrencyCard> _cardList = [];

  @override
  void initState() {
    super.initState();
    updateCurrencyCards();
  }

  Future updateCurrencyCards() async {
    for (String crypto in coinData.cryptoCurrencies) {
      await updateCard(crypto);
    }
  }

  Future updateCard(String crypto) async {
    final double exchangeRate =
        await coinData.getExchangeRate(crypto, _selectedCurrency);
    final CurrencyCard newCard = CurrencyCard(
      exchangeRate: exchangeRate.toStringAsFixed(2),
      currency: _selectedCurrency,
      cryptoName: crypto,
    );

    placeCard(newCard);
  }

  void placeCard(CurrencyCard card) {
    final int index =
        _cardList.indexWhere((c) => c.cryptoName == card.cryptoName);

    setState(() {
      if (index == -1) {
        _cardList.add(card);
      } else {
        _cardList[index] = card;
      }
    });
  }

  DropdownButton<String> getAndroidPicker() {
    final List<DropdownMenuItem<String>> menuItemList = [];

    for (String currency in coinData.worldCurrencies) {
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

    for (String currency in coinData.worldCurrencies) {
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
        _selectedCurrency = coinData.worldCurrencies[selectedIndex];
        updateCurrencyCards();
      },
      children: menuItemList,
    );
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
