import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crypto/screens/coin_list_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../crypto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Crypto>? CryptoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/logo.png'),
            ),
            SizedBox(height: 15),
            SpinKitCircle(
              size: 28,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }

  void _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> CryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(
          CryptoList: CryptoList,
        ),
      ),
    );
  }
}
