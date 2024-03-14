import 'package:stackfood_multivendor_driver/feature/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_driver/feature/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_driver/feature/language/widgets/language_widget.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/images.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromProfile;
  const ChooseLanguageScreen({super.key, required this.fromProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: fromProfile ? CustomAppBarWidget(title: 'language'.tr) : null,

      body: SafeArea(
        child: GetBuilder<LocalizationController>(builder: (localizationController) {
          return Column(children: [

            Expanded(child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Center(child: SizedBox(
                  width: 1170,
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Center(child: Image.asset(Images.logo, width: 100)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Center(child: Image.asset(Images.logoName, width: 100)),
                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text('select_language'.tr, style: robotoMedium),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (1/1),
                        ),
                        itemCount: localizationController.languages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => LanguageWidget(
                          languageModel: localizationController.languages[index],
                          localizationController: localizationController, index: index,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                  ]),
                )),
              ),
            )),

            Column(children: [

              Center(
                child: Text('you_can_change_language'.tr, style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                )),
              ),

              CustomButtonWidget(
                buttonText: 'save'.tr,
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                onPressed: () {
                  if(localizationController.languages.isNotEmpty && localizationController.selectedIndex != -1) {
                    localizationController.setLanguage(Locale(
                      AppConstants.languages[localizationController.selectedIndex].languageCode!,
                      AppConstants.languages[localizationController.selectedIndex].countryCode,
                    ));
                    if (fromProfile) {
                      Navigator.pop(context);
                    } else {
                      Get.find<SplashController>().setLanguageIntro(false);
                      Get.offNamed(RouteHelper.getSignInRoute());
                    }
                  }else {
                    showCustomSnackBar('select_a_language'.tr);
                  }
                },
              ),

            ]),

          ]);
        }),
      ),
    );
  }
}