// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/utils/config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'package:brahmanshtalk/utils/global.dart' as global;
import '../../../report/open_file.dart';

class PdfViewerCoursespage extends StatefulWidget {
  final String url;
  const PdfViewerCoursespage({super.key, required this.url});

  @override
  State<PdfViewerCoursespage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerCoursespage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String downloadedUrlpdf = '';

  @override
  void initState() {
    super.initState();
    log("url is ${pdfBaseurl + widget.url}");
    downloadedUrlpdf = pdfBaseurl + widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: downloadedUrlpdf.isNotEmpty
          ? SfPdfViewer.network(
              downloadedUrlpdf,
              onDocumentLoadFailed: (details) {
                log('Document load failed: ${details.error}');
                log('Error description: ${details.description}');
              },
              onDocumentLoaded: (e) {
                // Document loaded successfully
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(downloadedUrlpdf));
      final fileName =
          'downloaded_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        await Permission.storage.request();
      }

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = Platform.isIOS
            ? await getApplicationDocumentsDirectory()
            : await getDownloadsDirectory();
        final filePath = '${directory!.path}/$fileName';
        log('save path is $filePath');

        await File(filePath).writeAsBytes(bytes);
        _initializeNotifications(filePath);
        // Show a notification after the PDF is downloaded
        showDownloadCompleteNotification();
        global.showToast(message: 'PDF downloaded successfully!');
      } else {
        global.showToast(message: 'Error downloading PDF');
      }
    } catch (e) {
      log('Error downloading PDF: $e');
      global.showToast(message: 'Error downloading PDF $e');
    }
  }

  void showDownloadCompleteNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'channel.id',
      'channel.name',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
      playSound: true,
    );
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      tr('Download Complete'),
      tr('Your PDF has been downloaded successfully!'),
      platformChannelSpecifics,
    );
  }

  void _initializeNotifications(String locationpath) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
    );
    final InitializationSettings initialSetting = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    flutterLocalNotificationsPlugin.initialize(initialSetting,
        onDidReceiveNotificationResponse: (_) {
      onSelectNotification(locationpath);
    });
  }

  void onSelectNotification(String filePath) async {
    log('location to open is $filePath');
    final result = await OpenFile.open(filePath);
    log("eroror result pdf open file is ${result.message}");
  }
}
