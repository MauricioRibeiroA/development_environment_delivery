import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_alert_dialog_widget.dart';
import 'package:stackfood_multivendor_driver/feature/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor_driver/feature/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_driver/feature/home/widgets/count_card_widget.dart';
import 'package:stackfood_multivendor_driver/feature/home/widgets/earning_widget.dart';
import 'package:stackfood_multivendor_driver/feature/home/widgets/shift_dialogue_widget.dart';
import 'package:stackfood_multivendor_driver/feature/order/screens/running_order_screen.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/images.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:stackfood_multivendor_driver/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/order_shimmer_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/order_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _loadData() async {
    Get.find<OrderController>().getIgnoreList();
    Get.find<OrderController>().removeFromIgnoreList();
    Get.find<ProfileController>().getShiftList();
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
    bool isBatteryOptimizationDisabled = (await DisableBatteryOptimization.isBatteryOptimizationDisabled)!;
    if(!isBatteryOptimizationDisabled) {
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  }

  @override
  Widget build(BuildContext context) {

    _loadData();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0, elevation: 0,
        title: Image.asset(Images.logoName, width: 120),
        actions: [

          IconButton(
            icon: GetBuilder<NotificationController>(builder: (notificationController) {
              bool hasNewNotification = false;
              if(notificationController.notificationList != null) {
                hasNewNotification = notificationController.notificationList!.length != notificationController.getSeenNotificationCount();
              }
              return Stack(children: [

                Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),

                hasNewNotification ? Positioned(top: 0, right: 0, child: Container(
                  height: 10, width: 10, decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Theme.of(context).cardColor),
                ),
                )) : const SizedBox(),

              ]);
            }),
            onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),

          GetBuilder<ProfileController>(builder: (profileController) {
            return GetBuilder<OrderController>(builder: (orderController) {
              return (profileController.profileModel != null && orderController.currentOrderList != null) ? FlutterSwitch(
                width: 75, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
                activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
                value: profileController.profileModel!.active == 1, onToggle: (bool isActive) async {
                  if(!isActive && orderController.currentOrderList!.isNotEmpty) {
                    showCustomSnackBar('you_can_not_go_offline_now'.tr);
                  }else {
                    if(!isActive) {
                      Get.dialog(ConfirmationDialogWidget(
                        icon: Images.warning, description: 'are_you_sure_to_offline'.tr,
                        onYesPressed: () {
                          Get.back();
                          profileController.updateActiveStatus();
                        },
                      ));
                    }else {
                      LocationPermission permission = await Geolocator.checkPermission();
                      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
                          || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
                        if(GetPlatform.isAndroid) {
                          Get.dialog(ConfirmationDialogWidget(
                            icon: Images.locationPermission,
                            iconSize: 200,
                            hasCancel: false,
                            description: 'this_app_collects_location_data'.tr,
                            onYesPressed: () {

                              Get.back();

                              _checkPermission(() {
                                if(profileController.shifts != null && profileController.shifts!.isNotEmpty) {
                                  Get.dialog(const ShiftDialogueWidget());
                                }else{
                                  profileController.updateActiveStatus();
                                }
                              });

                            },
                          ), barrierDismissible: false);
                        }else {
                          _checkPermission(() {
                            if(profileController.shifts != null && profileController.shifts!.isNotEmpty) {
                              Get.dialog(const ShiftDialogueWidget());
                            }else{
                              profileController.updateActiveStatus();
                            }
                          });
                        }
                      }else {
                        if(profileController.shifts != null && profileController.shifts!.isNotEmpty) {
                          Get.dialog(const ShiftDialogueWidget());
                        }else{
                          profileController.updateActiveStatus();
                        }
                      }
                    }
                  }
                },
              ) : const SizedBox();
            });
          }),
          const SizedBox(width: Dimensions.paddingSizeSmall),

        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          return await _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: GetBuilder<ProfileController>(builder: (profileController) {

            return Column(children: [

              GetBuilder<OrderController>(builder: (orderController) {
                bool hasActiveOrder = orderController.currentOrderList == null || orderController.currentOrderList!.isNotEmpty;
                bool hasMoreOrder = orderController.currentOrderList != null && orderController.currentOrderList!.length > 1;
                return Column(children: [

                  hasActiveOrder ? TitleWidget(
                    title: 'active_order'.tr, onTap: hasMoreOrder ? () {
                      Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: const RunningOrderScreen());
                    } : null,
                  ) : const SizedBox(),
                  SizedBox(height: hasActiveOrder ? Dimensions.paddingSizeExtraSmall : 0),

                  orderController.currentOrderList == null ? OrderShimmerWidget(
                    isEnabled: orderController.currentOrderList == null,
                  ) : orderController.currentOrderList!.isNotEmpty ? OrderWidget(
                    orderModel: orderController.currentOrderList![0], isRunningOrder: true, orderIndex: 0,
                  ) : const SizedBox(),
                  SizedBox(height: hasActiveOrder ? Dimensions.paddingSizeDefault : 0),

                ]);
              }),

              (profileController.profileModel != null && profileController.profileModel!.earnings == 1) ? Column(children: [

                TitleWidget(title: 'earnings'.tr),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Image.asset(Images.wallet, width: 60, height: 60),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(
                          'balance'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        profileController.profileModel != null ? Text(
                          PriceConverter.convertPrice(profileController.profileModel!.balance),
                          style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) : Container(height: 30, width: 60, color: Colors.white),

                      ]),
                    ]),
                    const SizedBox(height: 30),

                    Row(children: [

                      EarningWidget(
                        title: 'today'.tr,
                        amount: profileController.profileModel?.todaysEarning,
                      ),
                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      EarningWidget(
                        title: 'this_week'.tr,
                        amount: profileController.profileModel?.thisWeekEarning,
                      ),
                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      EarningWidget(
                        title: 'this_month'.tr,
                        amount: profileController.profileModel?.thisMonthEarning,
                      ),

                    ]),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
              ]) : const SizedBox(),

              TitleWidget(title: 'orders'.tr),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(children: [

                Expanded(child: CountCardWidget(
                  title: 'todays_orders'.tr, backgroundColor: Theme.of(context).secondaryHeaderColor, height: 180,
                  value: profileController.profileModel?.todaysOrderCount.toString(),
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: CountCardWidget(
                  title: 'this_week_orders'.tr, backgroundColor: Theme.of(context).colorScheme.error, height: 180,
                  value: profileController.profileModel?.thisWeekOrderCount.toString(),
                )),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              CountCardWidget(
                title: 'total_orders'.tr, backgroundColor: Theme.of(context).primaryColor, height: 140,
                value: profileController.profileModel?.orderCount.toString(),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              profileController.profileModel != null ? Container(
                height: 120, width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [

                  Row(mainAxisAlignment: profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center, children: [

                    Text(PriceConverter.convertPrice(profileController.profileModel!.cashInHands), style: robotoBold.copyWith(fontSize: 30)),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    (profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1) ? CustomButtonWidget(
                      width: 110, height: 40,
                      buttonText: 'view_details'.tr,
                      backgroundColor: Colors.blue,
                      onPressed: () => Get.toNamed(RouteHelper.getCashInHandRoute()),
                    ) : const SizedBox(),

                  ]),

                  Text('cash_in_your_hand'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                  ],
                ),
              ) : Shimmer(
                duration: const Duration(seconds: 2),
                enabled: true,
                child: Container(
                  height: 120, width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.grey[300],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Container(height: 20, width: 150, color: Colors.white),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Container(height: 40, width: 100, color: Colors.white),

                    ]),

                    Row(children: [

                      Container(height: 15, width: 200, color: Colors.white),

                    ]),

                  ]),
                ),
              ),

            ]);
          }),
        ),
      ),
    );
  }

  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(CustomAlertDialogWidget(description: 'you_denied'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(CustomAlertDialogWidget(description: 'you_denied_forever'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else {
      callback();
    }
  }

}