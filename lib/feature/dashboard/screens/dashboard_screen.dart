import 'dart:async';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/helper/disbursement_helper.dart';
import 'package:stackfood_multivendor_driver/feature/home/screens/home_screen.dart';
import 'package:stackfood_multivendor_driver/feature/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_driver/feature/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:stackfood_multivendor_driver/feature/dashboard/widgets/new_request_dialog_widget.dart';
import 'package:stackfood_multivendor_driver/feature/order/screens/order_screen.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/feature/profile/screens/profile_screen.dart';
import 'package:stackfood_multivendor_driver/feature/order/screens/order_request_screen.dart';
import 'package:stackfood_multivendor_driver/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_driver/helper/notification_helper.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/main.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_alert_dialog_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {

  DisbursementHelper disbursementHelper = DisbursementHelper();

  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final _channel = const MethodChannel('com.sixamtech/app_retain');
  late StreamSubscription _stream;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      OrderRequestScreen(onTap: () => _setPage(0)),
      const OrderScreen(),
      const ProfileScreen(),
    ];

    showDisbursementWarningMessage();

    customPrint('dashboard call');
      _stream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        customPrint("dashboard onMessage: ${message.data}/ ${message.data['type']}");
      String? type = message.notification!.bodyLocKey;
      String? orderID = message.notification!.titleLocKey;
      if(type != 'assign' && type != 'new_order' && type != 'message' && type != 'order_request'&& type != 'order_status') {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
      }
      if(type == 'new_order' || type == 'order_request') {
        Get.find<OrderController>().getCurrentOrders();
        Get.find<OrderController>().getLatestOrders();
        Get.dialog(NewRequestDialogWidget(isRequest: true, onTap: () => _navigateRequestPage(), orderId: int.parse(orderID!)));
      }else if(type == 'assign' && orderID != null && orderID.isNotEmpty) {
        Get.find<OrderController>().getCurrentOrders();
        Get.find<OrderController>().getLatestOrders();
        Get.dialog(NewRequestDialogWidget(isRequest: false, onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(orderID))), orderId: int.parse(orderID)));
      }else if(type == 'block') {
        Get.find<AuthController>().clearSharedData();
        Get.find<ProfileController>().stopLocationRecord();
        Get.offAllNamed(RouteHelper.getSignInRoute());
      }
    });
  }

  void _navigateRequestPage() {
    if(Get.find<ProfileController>().profileModel != null && Get.find<ProfileController>().profileModel!.active == 1
        && Get.find<OrderController>().currentOrderList != null && Get.find<OrderController>().currentOrderList!.isEmpty) {
      _setPage(1);
    }else {
      if(Get.find<ProfileController>().profileModel == null || Get.find<ProfileController>().profileModel!.active == 0) {
        Get.dialog(CustomAlertDialogWidget(description: 'you_are_offline_now'.tr, onOkPressed: () => Get.back()));
      }else {
        _setPage(1);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _stream.cancel();
  }

  showDisbursementWarningMessage() async {
    disbursementHelper.enableDisbursementWarningMessage(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if(_pageIndex != 0) {
          _setPage(0);
        }else {
          if (GetPlatform.isAndroid && Get.find<ProfileController>().profileModel!.active == 1) {
            _channel.invokeMethod('sendToBackground');
          } else {
            return;
          }
        }
      },
      child: Scaffold(

        bottomNavigationBar: GetPlatform.isDesktop ? const SizedBox() : BottomAppBar(
          elevation: 5,
          notchMargin: 5,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Row(children: [

              BottomNavItemWidget(iconData: Icons.home, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),

              BottomNavItemWidget(iconData: Icons.list_alt_rounded, isSelected: _pageIndex == 1, onTap: () {
                _navigateRequestPage();
              }),

              BottomNavItemWidget(iconData: Icons.shopping_bag, isSelected: _pageIndex == 2, onTap: () => _setPage(2)),

              BottomNavItemWidget(iconData: Icons.person, isSelected: _pageIndex == 3, onTap: () => _setPage(3)),

            ]),
          ),
        ),

        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}