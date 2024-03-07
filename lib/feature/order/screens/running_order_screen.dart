import 'package:stackfood_multivendor_driver/feature/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_driver/feature/order/widgets/history_order_widget.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunningOrderScreen extends StatelessWidget {
  const RunningOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'running_orders'.tr),

      body: GetBuilder<OrderController>(builder: (orderController) {

        return orderController.currentOrderList != null ? orderController.currentOrderList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await orderController.getCurrentOrders();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: 1170,
              child: ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                itemCount: orderController.currentOrderList!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return HistoryOrderWidget(orderModel: orderController.currentOrderList![index], isRunning: true, index: index);
                },
              ),
            )),
          ),
        ) : Center(child: Text('no_order_found'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}