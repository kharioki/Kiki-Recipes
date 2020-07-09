import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeScreen extends StatefulWidget {
  final String postUrl;

  const RecipeScreen({@required this.postUrl});
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String finalUrl;

  @override
  void initState() {
    super.initState();
    finalUrl = widget.postUrl;
    if (widget.postUrl.contains('http://')) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
      print(finalUrl + "this is final url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 60, right: 24, left: 24, bottom: 16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF020024),
                  const Color(0xFF09796B),
                ],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Kikis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Recipes',
                  style: TextStyle(
                    color: Color(0xFF09796B),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 104,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              onPageFinished: (val) {
                print(val);
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: finalUrl,
              onWebViewCreated: (WebViewController webViewController) {
                setState(() {
                  _controller.complete(webViewController);
                });
              },
            ),
          ),
        ],
      ),
    ));
  }
}
