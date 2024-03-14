import 'package:stackfood_multivendor_driver/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_driver/feature/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String icon;
  final double iconSize;
  final String? title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final bool hasCancel;
  const ConfirmationDialogWidget({super.key, required this.icon, this.iconSize = 50, this.title, required this.description, required this.onYesPressed,
    this.isLogOut = false, this.hasCancel = true});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Image.asset(icon, width: iconSize, height: iconSize),
          ),

          title != null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              title!, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).colorScheme.error),
            ),
          ) : const SizedBox(),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GetBuilder<AuthController>(builder: (authController) {
            return GetBuilder<OrderController>(builder: (orderController) {
              return (orderController.isLoading || authController.isLoading) ? const Center(child: CircularProgressIndicator()) : Row(children: [

                hasCancel ? Expanded(child: TextButton(
                  onPressed: () => isLogOut ? onYesPressed() : Get.back(),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  ),
                  child: Text(
                    isLogOut ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                )) : const SizedBox(),
                SizedBox(width: hasCancel ? Dimensions.paddingSizeLarge : 0),

                Expanded(child: CustomButtonWidget(
                  buttonText: isLogOut ? 'no'.tr : hasCancel ? 'yes'.tr : 'ok'.tr,
                  onPressed: () => isLogOut ? Get.back() : onYesPressed(),
                  height: 40,
                )),

              ]);
            });
          }),

        ]),
      ),
    );
  }
}