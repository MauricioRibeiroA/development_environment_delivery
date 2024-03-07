import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftDialogueWidget extends StatefulWidget {
  const ShiftDialogueWidget({super.key});

  @override
  State<ShiftDialogueWidget> createState() => _ShiftDialogueWidgetState();
}

class _ShiftDialogueWidgetState extends State<ShiftDialogueWidget> {
  @override
  void initState() {
    super.initState();

    Get.find<ProfileController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<ProfileController>(builder: (profileController) {
        return SizedBox(
          width: 500, height: MediaQuery.of(context).size.height * 0.6,
          child: Column(children: [

            Container(
              width: 500,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
              ),
              child: Column(children: [

                Text(
                  'select_shift'.tr,
                  style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
                ),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              ]),
            ),

            Expanded(
              child: profileController.shifts != null ? profileController.shifts!.isNotEmpty ? ListView.builder(
                itemCount: profileController.shifts!.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: ListTile(
                      onTap: () {
                        profileController.setShiftId(profileController.shifts![index].id);
                      },
                      title: Row(children: [

                        Icon(profileController.shifts![index].id == profileController.shiftId ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).primaryColor, size: 18),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(profileController.shifts![index].name!, style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),

                          Text(
                            '${DateConverter.onlyTimeShow(profileController.shifts![index].startTime!)} - ${DateConverter.onlyTimeShow(profileController.shifts![index].endTime!)}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),

                        ]),

                      ]),
                    ),
                  );
                },
              ) : Center(child: Text('no_reasons_available'.tr)) : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault, vertical: Dimensions.paddingSizeSmall),
              child: !profileController.shiftLoading ? Row(children: [

                Expanded(child: CustomButtonWidget(
                  buttonText: 'skip'.tr, backgroundColor: Theme.of(context).disabledColor, radius: 50,
                  onPressed: () {
                    profileController.updateActiveStatus(isUpdate: true).then((success) {
                      if(success){
                        Get.back();
                        Future.delayed(const Duration(seconds: 2), (){
                          Get.back();
                        });
                      }
                    });
                  },
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: CustomButtonWidget(
                  buttonText: 'submit'.tr,  radius: 50,
                  onPressed: (){
                    if(profileController.shiftId != null ){
                      profileController.updateActiveStatus(shiftId: profileController.shiftId, isUpdate: true).then((success) {
                        if(success){
                          Get.back();
                          Future.delayed(const Duration(seconds: 2), ()=> Get.back());
                        }
                      });
                    }else{
                      profileController.updateActiveStatus(isUpdate: true).then((success) {
                        if(success){

                          Get.back();

                          Future.delayed(const Duration(seconds: 2), (){
                              Get.back();
                          });

                        }
                      });
                    }
                  },
                )),
              ]) : const Center(child: CircularProgressIndicator()),
            ),
          ]),
        );
      }),
    );
  }
}