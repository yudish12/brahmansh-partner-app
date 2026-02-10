import 'dart:developer';
import 'dart:io';
import 'package:brahmanshtalk/constants/colorConst.dart';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/controllers/custompujaModel.dart';
import 'package:brahmanshtalk/controllers/free_kundli_controller.dart';
import 'package:brahmanshtalk/views/HomeScreen/FloatingButton/KundliMatching/place_of_birth_screen.dart';
import 'package:brahmanshtalk/views/HomeScreen/Profile/mediapickerDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controllers/custompujaController.dart';

class AddPujaForm extends StatefulWidget {
  final bool isEdit;
  final CustomPujaModel? puja;

  const AddPujaForm({super.key, this.isEdit = false, this.puja});

  @override
  State<AddPujaForm> createState() => _AddPujaFormState();
}

class _AddPujaFormState extends State<AddPujaForm> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final startDateTimeController = TextEditingController();
  final durationController = TextEditingController();
  final placeTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final poojacontroller = Get.find<Productcontroller>();
  String baseurl = "https://arthjyoti.com/";

  @override
  void initState() {
    super.initState();

    // Initialize form if editing
    if (widget.isEdit && widget.puja != null) {
      titleController.text = widget.puja!.pujaTitle ?? '';
      descController.text = widget.puja!.longDescription ?? '';
      startDateTimeController.text = widget.puja!.pujaStartDatetime.toString();
      durationController.text = widget.puja!.pujaDuration.toString();
      placeTextController.text = widget.puja!.pujaPlace!.length > 12
          ? '${widget.puja!.pujaPlace!.substring(0, 12)}..'
          : widget.puja!.pujaPlace ?? '';
      priceController.text = widget.puja!.pujaPrice ?? '';
      log('puja length is ${widget.puja!.pujaImages?.length}');
      final List<String> images =
          widget.puja!.pujaImages?.map((img) => '$baseurl$img').toList() ?? [];
      Get.find<CustomPujaController>().imageList.addAll(images);
      Get.find<CustomPujaController>().update();
      log(
        'image length is ${Get.find<CustomPujaController>().imageList.length}',
      );
    }
  }

  @override
  void dispose() {
    Get.find<CustomPujaController>().pickerController.clearImages();
    Get.find<CustomPujaController>().imageList.clear();
    Get.find<CustomPujaController>().update();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: COLORS().textColor,
            ),
            onPressed: () => Get.back(),
          ),
          title: widget.isEdit
              ? Text(
                  'Edit Puja',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: COLORS().textColor,
                      ),
                ).tr()
              : Text(
                  'Add New Puja',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: COLORS().textColor,
                      ),
                ).tr(),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Puja Title Field
                  _buildTextField(
                    context,
                    controller: titleController,
                    label: tr('Puja Title'),
                    hintText: tr('Enter puja title'),
                    maxLines: 1,
                    maxLength: 40,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return tr('Please enter a title');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Description Field
                  _buildTextField(
                    context,
                    controller: descController,
                    label: tr('Description'),
                    hintText: tr('Enter description'),
                    maxLines: 5,
                    minline: 5,
                    maxLength: 150,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return tr('Please enter a description');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 1.w),
                  // Add this new image upload section
                  Text(
                    'Puja Image',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Get.theme.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ).tr(),
                  const SizedBox(height: 8),
                  GetBuilder<CustomPujaController>(
                    builder: (custompujacontroller) {
                      return Container(
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: custompujacontroller.imageList.length + 1,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // First box to add new image
                              return GestureDetector(
                                onTap: () async {
                                  Get.find<CustomPujaController>()
                                      .pickerController
                                      .clearImages();
                                  Get.find<CustomPujaController>()
                                      .imageList
                                      .clear();
                                  Get.find<CustomPujaController>().update();
                                  await Get.find<CustomPujaController>()
                                      .pickMedia(context, MediaTypes.image);
                                },
                                child: custompujacontroller.imageList.isNotEmpty
                                    ? Container()
                                    : Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              size: 40,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tap to add\nimage',
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ).tr(),
                                          ],
                                        ),
                                      ),
                              );
                            } else {
                              String imageFile =
                                  custompujacontroller.imageList[index - 1];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imageFile.startsWith('http')
                                        ? CachedNetworkImage(
                                            imageUrl: imageFile,
                                            width: 100,
                                            height: 130,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                GetBuilder<
                                                    CustomPujaController>(
                                              builder: (
                                                custompujacontroller,
                                              ) =>
                                                  Center(
                                                child: Skeletonizer(
                                                  enabled: custompujacontroller
                                                          .isLoading ??
                                                      false,
                                                  child: const SizedBox(
                                                    width: 100,
                                                    height: 130,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                        : Image.file(
                                            File(imageFile),
                                            width: 100,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        custompujacontroller.removeImageAt(
                                          index - 1,
                                        );
                                        // Because index 0 is add-button
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 4.w),

                  // Date & Time Fields
                  Text(
                    'Puja Schedule',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Get.theme.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ).tr(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateTimeField(
                          context,
                          controller: startDateTimeController,
                          label: tr('Start Date & Time'),
                          onTap: () => _selectDateTime(context, isStart: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          context,
                          controller: durationController,
                          label: tr('Duration'),
                          hintText: tr('Enter in minutes'),
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return tr('Please enter duration');
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Location & Price Fields
                  Row(
                    children: [
                      Expanded(
                        child: GetBuilder<KundliController>(
                          builder: (kundliController) => _buildTextField(
                            context,
                            readonly: true,
                            controller: placeTextController,
                            label: tr('Location'),
                            hintText: tr('Enter venue'),
                            icon: Icons.location_on,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return tr('Please enter a location');
                              }
                              return null;
                            },
                            onFormtap: () {
                              log('ontap');
                              Get.to(
                                () => PlaceOfBirthSearchScreen(
                                  placeController: placeTextController,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          context,
                          controller: priceController,
                          label: tr('Price'),
                          hintText: tr('Enter amount'),
                          icon: Icons.currency_rupee,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return tr('Please enter price');
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  0,
                ), // 👈 0 for rectangular sharp edges
              ),
              elevation: 0,
            ),
            onPressed: _submitForm,
            child: Text(
              widget.isEdit ? 'Update Puja' : 'Create Puja',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400,
               color:    COLORS().textColor),
            ).tr(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hintText,
    IconData? icon,
    int? maxLines = 1,
    int? maxLength,
    int? minline = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool? readonly = false,
    Function()? onFormtap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.grey.shade700,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          readOnly: readonly ?? false,
          controller: controller,
          maxLines: maxLines,
          minLines: minline,
          maxLength: maxLength,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          textAlignVertical: TextAlignVertical.center, // Center vertically

          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            contentPadding: EdgeInsets.all(2.w),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Get.theme.primaryColor, width: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Get.theme.primaryColor, width: 0.4),
            ),
          ),
          onTap: () {
            onFormtap?.call();
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.grey.shade700,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: IgnorePointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: tr('Select date & time'),
                prefixIcon: const Icon(Icons.calendar_today, size: 20),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(
    BuildContext context, {
    required bool isStart,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.surface,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Get.theme.primaryColor,
                onPrimary: Colors.white,
                surface: Theme.of(context).colorScheme.surface,
                onSurface: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        String formattedDate = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(combinedDateTime);
        if (isStart) {
          startDateTimeController.text = formattedDate;
        } else {
          // durationController.text = formattedDate;
        }
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.isEdit) {
        poojacontroller.editCustomPuja(
          Get.find<CustomPujaController>().imageList,
          pujaId: widget.puja!.id,
          pujaName: titleController.text,
          pujaDescription: descController.text,
          pujaStartDateTime: startDateTimeController.text,
          pujaduration: durationController.text,
          pujaPlace: Get.find<KundliController>().editBirthPlaceController.text,
          pujaPrice: priceController.text,
        );
      } else {
        log('share iamge clicked');
        log('image list is ${Get.find<CustomPujaController>().imageList}');

        Get.find<CustomPujaController>().addpujaServer(
          Get.find<CustomPujaController>().imageList,
          pujaName: titleController.text,
          pujaDescription: descController.text,
          pujaStartDateTime: startDateTimeController.text,
          pujaduration: durationController.text,
          pujaPlace: Get.find<KundliController>().editBirthPlaceController.text,
          pujaPrice: priceController.text,
        );
      }
    }
  }
}
