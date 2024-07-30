import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UnrealtimeDetectionPage extends StatefulWidget {
  @override
  _UnrealtimeDetectionPageState createState() => _UnrealtimeDetectionPageState();
}

class _UnrealtimeDetectionPageState extends State<UnrealtimeDetectionPage> {
  final String url = 'http://192.168.29.47:5000/realtime'; // IP Address Local (cmd/ipconfig/IPv4 Address. . . . . . . . . . . : 192.168.29.47)

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
