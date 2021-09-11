import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenWebView extends StatefulWidget {
  final String webLink;
  final String tabName;
  const OpenWebView(this.webLink,this.tabName);
  @override
  OpenWebViewState createState() => OpenWebViewState();
}

class OpenWebViewState extends State<OpenWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.arrow_back)),title: Text(widget.tabName),backgroundColor: CustomColors().grey,),
      body: WebView(
        initialUrl: widget.webLink,
      ),
    );
  }
}