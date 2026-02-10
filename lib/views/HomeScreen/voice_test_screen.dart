// ignore_for_file: avoid_print
// Test screen for voice recording and playback (no backend / FCM).

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

class VoiceTestScreen extends StatefulWidget {
  const VoiceTestScreen({super.key});

  @override
  State<VoiceTestScreen> createState() => _VoiceTestScreenState();
}

class _VoiceTestScreenState extends State<VoiceTestScreen> {
  static const int _maxVoiceDurationSeconds = 60;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _voicePlayer = AudioPlayer();

  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;
  String? _currentRecordPath;

  final List<String> _recordings = [];
  String? _playingPath;

  @override
  void initState() {
    super.initState();
    _voicePlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingPath = null);
    });
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    if (_isRecording) _audioRecorder.stop().ignore();
    _audioRecorder.dispose();
    _voicePlayer.dispose();
    super.dispose();
  }

  Future<bool> _requestMicPermission() async {
    if (await Permission.microphone.isGranted) return true;
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;
    final hasPermission = await _requestMicPermission();
    if (!hasPermission) {
      _showSnack('Microphone permission required');
      return;
    }
    try {
      final canRecord = await _audioRecorder.hasPermission();
      if (!canRecord) {
        _showSnack('Microphone access denied');
        return;
      }
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/voice_test_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
      _currentRecordPath = path;
      _isRecording = true;
      _recordSeconds = 0;
      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (t.tick >= _maxVoiceDurationSeconds) {
          t.cancel();
          _recordTimer = null;
          if (mounted) setState(() => _recordSeconds = _maxVoiceDurationSeconds);
          _stopRecordingAndAdd();
          return;
        }
        if (mounted) setState(() => _recordSeconds = t.tick);
      });
      setState(() {});
    } catch (e) {
      log('Start recording error: $e');
      _showSnack('Could not start recording');
    }
  }

  Future<void> _stopRecordingAndAdd() async {
    if (!_isRecording) return;
    _recordTimer?.cancel();
    _recordTimer = null;
    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;
      final filePath = path ?? _currentRecordPath;
      _currentRecordPath = null;
      setState(() {});
      if (filePath != null && File(filePath).existsSync()) {
        setState(() => _recordings.insert(0, filePath));
        _showSnack('Recording saved');
      }
    } catch (e) {
      log('Stop recording error: $e');
      _isRecording = false;
      _currentRecordPath = null;
      setState(() {});
    }
  }

  Future<void> _cancelRecording() async {
    if (!_isRecording) return;
    _recordTimer?.cancel();
    _recordTimer = null;
    try {
      await _audioRecorder.stop();
    } catch (_) {}
    _isRecording = false;
    _currentRecordPath = null;
    setState(() {});
  }

  Future<void> _togglePlay(String path) async {
    if (_playingPath == path) {
      await _voicePlayer.pause();
      setState(() => _playingPath = null);
    } else {
      await _voicePlayer.play(DeviceFileSource(path));
      setState(() => _playingPath = path);
    }
  }

  void _removeRecording(int index) {
    final path = _recordings[index];
    if (_playingPath == path) {
      _voicePlayer.stop();
      _playingPath = null;
    }
    setState(() => _recordings.removeAt(index));
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice recording test'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (_isRecording) _buildRecordingStrip(),
          Expanded(
            child: _recordings.isEmpty && !_isRecording
                ? Center(
                    child: Text(
                      'No recordings yet.\nTap the mic to record (max $_maxVoiceDurationSeconds sec).',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: _recordings.length,
                    itemBuilder: (context, index) {
                      final path = _recordings[index];
                      final name = path.split('/').last;
                      final isPlaying = _playingPath == path;
                      return Card(
                        margin: EdgeInsets.only(bottom: 2.h),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              color: Colors.deepPurple,
                              size: 36,
                            ),
                            onPressed: () => _togglePlay(path),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(fontSize: 12.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'Recording ${index + 1}',
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeRecording(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _isRecording
          ? null
          : FloatingActionButton.large(
              onPressed: _startRecording,
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.mic, size: 32, color: Colors.white),
            ),
    );
  }

  Widget _buildRecordingStrip() {
    final minutes = _recordSeconds ~/ 60;
    final secs = _recordSeconds % 60;
    final timeStr = '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    final nearLimit = _recordSeconds >= _maxVoiceDurationSeconds - 10;
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.mic, color: Colors.red, size: 28.sp),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recording...',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$timeStr / ${_maxVoiceDurationSeconds ~/ 60}:${(_maxVoiceDurationSeconds % 60).toString().padLeft(2, '0')} max',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: nearLimit ? Colors.orange.shade800 : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _cancelRecording,
            child: const Text('Cancel'),
          ),
          SizedBox(width: 2.w),
          ElevatedButton.icon(
            onPressed: _stopRecordingAndAdd,
            icon: const Icon(Icons.send_rounded, size: 20),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
