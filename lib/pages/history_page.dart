import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageViewState createState() => _HistoryPageViewState();
}

class _HistoryPageViewState extends State<HistoryPage> {
  final String url = 'http://192.168.139.47:8501';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url))
      ),
    );
  }  
}
