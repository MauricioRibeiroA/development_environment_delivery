import 'package:stackfood_multivendor_driver/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/controllers/disbursement_controller.dart';
import 'package:stackfood_multivendor_driver/feature/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_driver/feature/disbursements/widgets/withdraw_method_attention_dialog_widget.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementHelper {

  Future<bool> enableDisbursementWarningMessage(bool fromDashboard, {bool canShowDialog = true}) async {

    bool showWarning = false;

    Get.find<SplashController>().configModel!.disbursementType == 'automated' && (Get.find<ProfileController>().profileModel!.type != 'restaurant_wise'
      && Get.find<ProfileController>().profileModel!.earnings != 0) ? showWarning = true : showWarning = false;

    if(Get.find<SplashController>().configModel!.disbursementType == 'automated' && Get.find<ProfileController>().profileModel!.type != 'restaurant_wise'
      && Get.find<ProfileController>().profileModel!.earnings != 0){
      await Get.find<DisbursementController>().getDisbursementMethodList().then((success) {
        if(success){
          if(Get.find<DisbursementController>().disbursementMethodBody!.methods!.isNotEmpty) {
            for (var method in Get.find<DisbursementController>().disbursementMethodBody!.methods!) {
              if (method.isDefault == 1) {
                showWarning = false;
                break;
              } else {
                showWarning = true;
              }
            }
          } else {
            showWarning = true;
          }
        }
      });
    } else {
      showWarning = false;
    }

    if(showWarning && canShowDialog) {
      Get.dialog(
        Dialog(
          alignment: Alignment.bottomCenter,
          backgroundColor: Get.find<ThemeController>().darkTheme ? const Color(0xff888686) : const Color(0xfffff1f1),
          insetPadding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)), //this right here
          child: WithdrawMethodAttentionDialogWidget(isFromDashboard: fromDashboard),
        ),
      );
    }

    return showWarning;
  }

}