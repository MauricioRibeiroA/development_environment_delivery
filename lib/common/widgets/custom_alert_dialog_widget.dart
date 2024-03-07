import 'package:stackfood_multivendor_driver/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  final String description;
  final Function onOkPressed;
  const CustomAlertDialogWidget({super.key, required this.description, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Icon(Icons.info, size: 80, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(
              description, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),

          CustomButtonWidget(
            buttonText: 'ok'.tr,
            onPressed: onOkPressed,
            height: 40,
          ),

        ]),
      ),
    );
  }
}