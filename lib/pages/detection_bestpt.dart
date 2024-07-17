import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UnrealtimeDetectionPage extends StatefulWidget {
  @override
  _UnrealtimeDetectionPageState createState() => _UnrealtimeDetectionPageState();
}

class _UnrealtimeDetectionPageState extends State<UnrealtimeDetectionPage> {
  final String url = 'http://192.168.139.47:5000/realtime';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detection Mode 2'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
      ),
    );
  }
}
