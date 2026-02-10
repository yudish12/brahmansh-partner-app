// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:brahmanshtalk/views/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../controllers/HomeController/home_controller.dart';
import '../../../../../utils/config.dart';

class PaymentScreen extends StatefulWidget {
  String url;
  PaymentScreen({super.key, required this.url});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    log('Loading URL: ${widget.url}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBar(
              leading: const SizedBox(),
              title: const Text("Payment"),
              actions: [
                InkWell(
                  onTap: () async {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Cancel Payment?"),
                        content:
                            const Text("Do you want to cancel the payment?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                              Navigator.pop(context, false);
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Cancel Payment",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            )),
        body: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(const Color(0x00000000))
              ..setNavigationDelegate(
                NavigationDelegate(onProgress: (int progress) {
                  const CircularProgressIndicator();
                }, onPageStarted: (url) {
                  log('WebView page started loading: $url');
                }, onWebResourceError: (WebResourceError error) {
                  log('WebView error: $error');
                }, onPageFinished: (finish) {
                  log('WebView finish: $finish');
                  if (finish.toString().split("?").first ==
                      "${imgBaseurl}payment-success") {
                    Get.find<HomeController>().homeTabIndex = 0;
                    Get.find<HomeController>().update();
                    Get.offAll(() => HomeScreen());
                    global.showToast(message: "Payment Success!");
                  } else if (finish.toString().split("?").first ==
                      "${imgBaseurl}payment-failed") {
                    Get.find<HomeController>().homeTabIndex = 0;
                    Get.find<HomeController>().update();
                    Get.offAll(() => HomeScreen());

                    global.showToast(message: "Payment Failed!");
                  }
                }),
              )
              ..loadRequest(Uri.parse(widget.url))),
      ),
    );
  }
}
