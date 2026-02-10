// ignore_for_file: must_be_immutable, unused_field, file_names

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Poojaboardcasting extends StatefulWidget {
  String url;
  Poojaboardcasting({super.key, required this.url});

  @override
  State<Poojaboardcasting> createState() => _Poojaboardcasting();
}

class _Poojaboardcasting extends State<Poojaboardcasting> {
  late InAppWebViewController _controller;

  @override
  void initState() {
    debugPrint("pooja");
    debugPrint(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            title: const Text("Puja"),
          )),
      body: SizedBox(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: InAppWebViewSettings(
              cacheEnabled: true,
              javaScriptEnabled: true,
              javaScriptCanOpenWindowsAutomatically: true,
              useShouldOverrideUrlLoading: true,
              useShouldInterceptRequest: true),
          onReceivedError: (controller, request, error) {
            log('error: ${error.toString()}');
          },
          onLoadResource: (controller, resource) {
            log('onLoadResource : $resource');
          },
          onLoadStart: (controller, url) {
            log('start url: ${url.toString()}');
          },
          onReceivedHttpError: (controller, request, error) {
            log('http error: ${error.toString()} and req is $request');
          },
          onLoadStop: (controller, url) async {},
          onWebViewCreated: (webviewcontroller) {},
        ),
      ),
    );
  }
}
