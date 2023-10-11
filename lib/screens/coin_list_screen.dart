import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_crypto/crypto.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({Key? key, this.CryptoList}) : super(key: key);
  List<Crypto>? CryptoList;

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? CryptoList;
  bool isSearchLoadingVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CryptoList = widget.CryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Crypto Currency',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    _filterList(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'اسم رمز ارز معتبر را وارد کنید',
                    hintStyle: TextStyle(
                      fontFamily: 'mr',
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    filled: true,
                    fillColor: Colors.green,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isSearchLoadingVisible,
              child: Text(
                '...در حال آپدیت اطلاعات رمز ارزها',
                style: TextStyle(color: Colors.green, fontFamily: 'mr'),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.green,
                color: Colors.black,
                onRefresh: () async {
                  List<Crypto> freshedData = await _getData();
                  setState(() {
                    CryptoList = freshedData;
                  });
                },
                child: ListView.builder(
                  itemCount: CryptoList!.length,
                  itemBuilder: (context, index) =>
                      _getListTileItem(CryptoList![index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> CryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return CryptoList;
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: Colors.green),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: Colors.grey),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          crypto.rank.toString(),
          style: TextStyle(color: Colors.grey),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  crypto.changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getPercentChangeColor(crypto.changePercent24Hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              child: _getChangeIcon(crypto.changePercent24Hr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChangeIcon(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 28,
            color: Colors.red,
          )
        : Icon(
            Icons.trending_up,
            size: 28,
            color: Colors.green,
          );
  }

  Color _getPercentChangeColor(double percentChange) {
    return percentChange <= 0 ? Colors.red : Colors.green;
  }

  Future<void> _filterList(String enteredKeyword) async {
    List<Crypto> cryptoResultList = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;
      });
      var result = await _getData();
      setState(() {
        CryptoList = result;
        isSearchLoadingVisible = false;
      });
      return;
    }

    cryptoResultList = CryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();
    setState(() {
      CryptoList = cryptoResultList;
    });
  }
}
