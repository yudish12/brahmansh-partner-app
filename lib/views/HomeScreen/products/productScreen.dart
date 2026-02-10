// ignore_for_file: must_be_immutable, file_names

import 'dart:developer';
import 'package:brahmanshtalk/controllers/HomeController/productController.dart';
import 'package:brahmanshtalk/views/HomeScreen/poojaModule/AssignPujaScreen.dart';
import 'package:brahmanshtalk/views/HomeScreen/products/productDetailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:brahmanshtalk/utils/global.dart' as global;

import '../../../constants/colorConst.dart';

class Productscreen extends StatefulWidget {
  int astroId;
  int? userid;
  bool? isFromHomeScreen;
  Productscreen({
    super.key,
    required this.astroId,
    this.userid,
    this.isFromHomeScreen = false,
  });

  @override
  State<Productscreen> createState() => _ProductscreenState();
}

class _ProductscreenState extends State<Productscreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final productcontroller = Get.find<Productcontroller>();

  @override
  void initState() {
    super.initState();

    int tabcount = widget.isFromHomeScreen == true ? 2 : 3;
    log('show tab in list is $tabcount and ${widget.isFromHomeScreen}');
    tabController = TabController(
        length: widget.isFromHomeScreen == true ? 2 : 3, vsync: this);
    getListpuja();
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color:  COLORS().textColor),
        title:  Text("Recommend", style: TextStyle(color: COLORS().textColor)),
        bottom: TabBar(
          dividerColor: Colors.transparent,
          indicatorColor: Colors.green,
          unselectedLabelStyle: Get.theme.textTheme.bodyMedium,
          labelStyle: Get.theme.textTheme.bodyMedium,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          controller: tabController,
          tabs: widget.isFromHomeScreen == true
              ? const [Tab(text: "Products"), Tab(text: "Puja Services")]
              : const [
                  Tab(text: "Products"),
                  Tab(text: "Puja Services"),
                  Tab(text: "Suggest Puja"),
                ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: widget.isFromHomeScreen == true
            ? [
                _buildProductGrid(),
                _buildPujaGrid(),
              ]
            : [
                _buildProductGrid(),
                _buildPujaGrid(),
                AssignPujaScreen(userid: widget.userid),
              ],
      ),
      floatingActionButton: widget.astroId == 0
          ? const SizedBox()
          : GetBuilder<Productcontroller>(
              builder: (productcontroller) => productcontroller.suggestpuja ==
                          -1 &&
                      productcontroller.selectedProduct == -1 &&
                      productcontroller.selectpuja == -1
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        productcontroller.selectedProduct != -1
                            ? productcontroller.productRecommend(
                                productcontroller
                                    .productData[
                                        productcontroller.selectedProduct ?? 0]
                                    .id
                                    .toString(),
                                widget.astroId.toString(),
                              )
                            : () {
                                log('Please select product');
                              };

                        if (productcontroller.suggestpuja != -1) {
                          // log('clicked on assignedToUser userid ${widget.
                          productcontroller.assignedToUser(
                            widget.userid,
                            productcontroller
                                .custompoojalist![
                                    productcontroller.suggestpuja ?? 0]
                                .id,
                          );
                          productcontroller.suggestpuja = -1;
                          productcontroller.update();
                        }

                        productcontroller.selectpuja != -1
                            ? productcontroller.pujaRecommend(
                                productcontroller
                                    .poojalist![productcontroller.selectpuja ??
                                        0] //puja id
                                    .id
                                    .toString(),
                                widget.astroId.toString(),
                              )
                            : () {
                                log('Please select puja');
                              };
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        child: const Text(
                          "Recommend",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ),
    );
  }

  @override
  void dispose() {
    productcontroller.selectedProduct = -1;
    productcontroller.selectpuja = -1;
    productcontroller.update();
    super.dispose();
  }

  _buildProductGrid() {
    return GetBuilder<Productcontroller>(
      builder: (productController) {
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            mainAxisExtent: 29.5.h,
          ),
          itemCount: productController.productData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                log('price is ${productController.productData[index].amount}');
                widget.astroId == 0
                    ? Get.to(
                        () => Productdetailscreen(
                          image:
                              '${productController.productData[index].productImage}',
                          title: productController.productData[index].name
                              .toString(),
                          desc: productController.productData[index].features
                              .toString(),
                          price: productController.productData[index].amount
                              .toString(),
                        ),
                      )
                    : productController.selectProduct(index); //select product
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: productController.selectedProduct == index
                      ? Get.theme.primaryColor
                      : Colors.grey.withOpacity(0.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${productController.productData[index].productImage}",
                        height: 15.h,
                        width: 50.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "${productController.productData[index].name}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        if (global.isCoinWallet())
                          CachedNetworkImage(
                            imageUrl: global.getSystemFlagValue(
                                global.systemFlagNameList.coinIcon),
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                          )
                        else
                          Text(
                            global.getSystemFlagValue(
                                global.systemFlagNameList.currency),
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        const SizedBox(width: 4),
                        Text(
                          "${productController.productData[index].amount}",
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _buildPujaGrid() {
    return GetBuilder<Productcontroller>(
      builder: (pujacontroller) {
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            mainAxisExtent: 29.5.h,
          ),
          itemCount: pujacontroller.poojalist?.length,
          itemBuilder: (context, index) {
            log('puja length path is ${pujacontroller.poojalist?.length}');
            log('image path is ${pujacontroller.poojalist?[index].pujaImages?[0]}');
            return InkWell(
              onTap: () {
                widget.astroId == 0
                    ? Get.to(
                        () => Productdetailscreen(
                          image:
                              '${pujacontroller.poojalist?[index].pujaImages![0]}',
                          title: pujacontroller.poojalist![index].pujaTitle
                              .toString(),
                          desc: pujacontroller.poojalist![index].pujaSubtitle
                              .toString(),
                          price: pujacontroller
                              .poojalist?[index].packages?.first.packagePrice
                              .toString(),
                        ),
                      )
                    : productcontroller.selectPuja(index); //select product
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: productcontroller.selectpuja == index
                      ? Get.theme.primaryColor
                      : Colors.grey.withOpacity(0.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${pujacontroller.poojalist?[index].pujaImages![0]}",
                        height: 15.h,
                        width: 50.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "${pujacontroller.poojalist?[index].pujaTitle}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 1.h),
                    pujacontroller.poojalist?[index].packages?.isEmpty ?? true
                        ? Container()
                        : Row(
                            children: [
                              if (global.isCoinWallet())
                                CachedNetworkImage(
                                  imageUrl: global.getSystemFlagValue(
                                      global.systemFlagNameList.coinIcon),
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                )
                              else
                                Text(
                                  global.getSystemFlagValue(
                                      global.systemFlagNameList.currency),
                                  style:
                                      Get.theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              const SizedBox(width: 4),
                              Text(
                                "${pujacontroller.poojalist?[index].packages?.first.packagePrice}",
                                style: Get.theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void getListpuja() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await productcontroller.getPoojaList();
      await productcontroller.getProductList();
    });
  }
}
