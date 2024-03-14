import 'package:stackfood_multivendor_driver/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_driver/feature/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_driver/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/feature/profile/widgets/profile_bg_widget.dart';
import 'package:stackfood_multivendor_driver/feature/profile/widgets/profile_button_widget.dart';
import 'package:stackfood_multivendor_driver/feature/profile/widgets/profile_card_widget.dart';
import 'package:stackfood_multivendor_driver/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/images.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:stackfood_multivendor_driver/common/widgets/confirmation_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<ProfileController>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return profileController.profileModel == null ? const Center(child: CircularProgressIndicator()) : ProfileBgWidget(
          backButton: false,
          circularImage: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).cardColor),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(child: CustomImageWidget(
              image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}'
                  '/${profileController.profileModel != null ? profileController.profileModel!.image : ''}',
              height: 100, width: 100, fit: BoxFit.cover,
            )),
          ),
          mainWidget: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Center(child: Container(
            width: 1170, color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              Text(
                '${profileController.profileModel!.fName} ${profileController.profileModel!.lName}',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),

              profileController.profileModel!.shiftName != null ? RichText(text: TextSpan(children: [
                TextSpan(text: '${'shift'.tr}: ', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeSmall)),
                TextSpan(text: ' ${profileController.profileModel!.shiftName}', style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                TextSpan(text: ' (${DateConverter.onlyTimeShow(profileController.profileModel!.shiftStartTime!)} - ${DateConverter.onlyTimeShow(profileController.profileModel!.shiftEndTime!)})',
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
              ])) : const SizedBox(),
              const SizedBox(height: 30),

              Row(children: [

                ProfileCardWidget(title: 'since_joining'.tr, data: '${profileController.profileModel!.memberSinceDays} ${'days'.tr}'),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                ProfileCardWidget(title: 'total_order'.tr, data: profileController.profileModel!.orderCount.toString()),

              ]),
              const SizedBox(height: 30),

              ProfileButtonWidget(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(
                icon: Icons.notifications, title: 'notification'.tr,
                isButtonActive: profileController.notification, onTap: () {
                profileController.setNotificationActive(!profileController.notification);
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(icon: Icons.chat_bubble, title: 'conversation'.tr, onTap: () {
                Get.toNamed(RouteHelper.getConversationListRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(icon: Icons.language, title: 'language'.tr, onTap: () {
                Get.toNamed(RouteHelper.getLanguageRoute('profile'));
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              (profileController.profileModel != null && profileController.profileModel!.earnings == 1) ? Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: ProfileButtonWidget(icon: Icons.account_balance, title: 'my_account'.tr, onTap: () {
                  Get.toNamed(RouteHelper.getCashInHandRoute());
                }),
              ) : const SizedBox(),

              (profileController.profileModel!.type != 'restaurant_wise' && profileController.profileModel!.earnings != 0) ? ProfileButtonWidget(icon: Icons.local_offer_rounded, title: 'incentive_offers'.tr, onTap: () {
                Get.toNamed(RouteHelper.getIncentiveRoute());
              }) : const SizedBox(),
              SizedBox(height: (profileController.profileModel!.type != 'restaurant_wise' && profileController.profileModel!.earnings != 0) ? Dimensions.paddingSizeSmall : 0),

              if(Get.find<SplashController>().configModel!.disbursementType == 'automated' && profileController.profileModel!.type != 'restaurant_wise' && profileController.profileModel!.earnings != 0)
              Column(children: [

                 Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: ProfileButtonWidget(icon: Icons.payments, title: 'disbursement'.tr, onTap: () {
                    Get.toNamed(RouteHelper.getDisbursementRoute());
                  }),
                ),

                ProfileButtonWidget(icon: Icons.money, title: 'disbursement_methods'.tr, onTap: () {
                  Get.toNamed(RouteHelper.getWithdrawMethodRoute());
                }),
                const SizedBox(height: Dimensions.paddingSizeSmall),

              ]),

              ProfileButtonWidget(icon: Icons.list, title: 'terms_condition'.tr, onTap: () {
                Get.toNamed(RouteHelper.getTermsRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(icon: Icons.privacy_tip, title: 'privacy_policy'.tr, onTap: () {
                Get.toNamed(RouteHelper.getPrivacyRoute());
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(
                icon: Icons.delete, title: 'delete_account'.tr,
                onTap: () {
                  Get.dialog(
                    ConfirmationDialogWidget(
                      icon: Images.warning, title: 'are_you_sure_to_delete_account'.tr,
                      description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                      onYesPressed: () => profileController.removeDriver(),
                    ),
                    useSafeArea: false,
                  );
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ProfileButtonWidget(icon: Icons.logout, title: 'logout'.tr, onTap: () {
                Get.back();
                Get.dialog(ConfirmationDialogWidget(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                  Get.find<AuthController>().clearSharedData();
                  profileController.stopLocationRecord();
                  Get.offAllNamed(RouteHelper.getSignInRoute());
                }));
              }),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(AppConstants.appVersion.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),

              ]),

            ]),
          ))),
        );
      }),
    );
  }
}