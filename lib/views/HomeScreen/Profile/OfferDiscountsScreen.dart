import 'package:brahmanshtalk/controllers/Authentication/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/colorConst.dart';
import '../../../controllers/commissionController.dart';

class CommissionScreen extends StatefulWidget {
  const CommissionScreen({super.key});
  @override
  State<CommissionScreen> createState() => _CommissionScreenState();
}

class _CommissionScreenState extends State<CommissionScreen> {
  final commissionController = Get.put(CommissionController());
  final singnupcontroller = Get.find<SignupController>();

  @override
  void initState() {
    super.initState();
    _getDiscoutedPrice();
  }

  void _getDiscoutedPrice() {
    final chatRate = singnupcontroller.astrologerList[0]?.chatDiscoutRate;
    final audioRate = singnupcontroller.astrologerList[0]?.audioDiscoutRate;
    final videoRate = singnupcontroller.astrologerList[0]?.videoDiscoutRate;
    debugPrint(
        "My Discouted Rate chat_rate-> $chatRate video_rate-> $videoRate audio_rate-> $audioRate");
    commissionController.selectedChat.value =
        chatRate is String ? int.parse(chatRate) : chatRate ?? 0;
    commissionController.selectedAudio.value =
        audioRate is String ? int.parse(audioRate) : audioRate ?? 0;
    commissionController.selectedVideo.value =
        videoRate is String ? int.parse(videoRate) : videoRate ?? 0;
    commissionController.chatCtrl.text = chatRate.toString();
    commissionController.videoCtrl.text = videoRate.toString();
    commissionController.audioCtrl.text = audioRate.toString();
    commissionController.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Set Commission",
      style: TextStyle(
        color: COLORS().textColor
      ),)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: GetX<CommissionController>(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: ToggleButtons(
                  isSelected: [
                    commissionController.isPreOffer.value,
                    !commissionController.isPreOffer.value
                  ],
                  borderRadius: BorderRadius.circular(30.w),
                  selectedColor: COLORS().textColor,
                  fillColor: Get.theme.primaryColor,
                  children:  [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("Pre-offer",
                     ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("Custom",
                     ),
                    ),
                  ],
                  onPressed: (index) {
                    setState(() =>
                        commissionController.isPreOffer.value = index == 0);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- Chat ----------------
              _buildCommissionSection(
                "Chat",
                Icons.chat,
                commissionController.chatEnabled.value,
                (val) => setState(
                    () => commissionController.chatEnabled.value = val),
                commissionController.isPreOffer.value
                    ? _buildPreOfferChips(
                        commissionController.selectedChat.value,
                        (val) => setState(() =>
                            commissionController.selectedChat.value = val))
                    : _buildInputCard("Chat Commission (%)", Icons.chat,
                        commissionController.chatCtrl),
              ),
              const SizedBox(height: 16),

              // ---------------- Audio ----------------
              _buildCommissionSection(
                "Audio",
                Icons.call,
                commissionController.audioEnabled.value,
                (val) => setState(
                    () => commissionController.audioEnabled.value = val),
                commissionController.isPreOffer.value
                    ? _buildPreOfferChips(
                        commissionController.selectedAudio.value,
                        (val) => setState(() =>
                            commissionController.selectedAudio.value = val))
                    : _buildInputCard("Audio Commission (%)", Icons.call,
                        commissionController.audioCtrl),
              ),
              const SizedBox(height: 16),

              // ---------------- Video ----------------
              _buildCommissionSection(
                "Video",
                Icons.videocam,
                commissionController.videoEnabled.value,
                (val) => setState(
                    () => commissionController.videoEnabled.value = val),
                commissionController.isPreOffer.value
                    ? _buildPreOfferChips(
                        commissionController.selectedVideo.value,
                        (val) => setState(() =>
                            commissionController.selectedVideo.value = val))
                    : _buildInputCard("Video Commission (%)", Icons.videocam,
                        commissionController.videoCtrl),
              ),

              const SizedBox(height: 50),

              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 90.w,
                  child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Get.theme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: commissionController.isLoading.value
                            ? null
                            : () => commissionController.saveCommission(),
                        child: commissionController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            :  Text(
                                "Save Commission",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600,
                                color: COLORS().textColor),
                              ),
                      )),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  // Section wrapper with toggle
  Widget _buildCommissionSection(
    String label,
    IconData icon,
    bool enabled,
    Function(bool) onToggle,
    Widget child,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Get.theme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$label Commission",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: enabled,
                    onChanged: onToggle,
                    activeColor: Get.theme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (enabled) child,
            if (!enabled)
              Text(
                "Disabled",
                style: TextStyle(color: Colors.grey.shade600),
              ),
          ],
        ),
      ),
    );
  }

  // Pre-offer chips widget
  Widget _buildPreOfferChips(int? selectedValue, Function(int?) onSelected) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: commissionController.preOfferOptions.map((value) {
        return ChoiceChip(
          label: Text("$value%"),
          selected: selectedValue == value,
          onSelected: (selected) {
            onSelected(selected ? value : null);
          },
        );
      }).toList(),
    );
  }

  // Custom input widget
  Widget _buildInputCard(
      String label, IconData icon, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
