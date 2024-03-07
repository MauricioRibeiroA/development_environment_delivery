import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/forgot_password_controller.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordScreen extends StatefulWidget {
  final String? resetToken;
  final String? number;
  final bool fromPasswordChange;
  const NewPasswordScreen({super.key, required this.resetToken, required this.number, required this.fromPasswordChange});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: widget.fromPasswordChange ? 'change_password'.tr : 'reset_password'.tr),

      body: SafeArea(child: Center(child: Scrollbar(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(child: SizedBox(width: 1170, child: Column(children: [

          Text('enter_new_password'.tr, style: robotoRegular, textAlign: TextAlign.center),
          const SizedBox(height: 50),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
            ),
            child: Column(children: [

              CustomTextFieldWidget(
                hintText: 'new_password'.tr,
                controller: _newPasswordController,
                focusNode: _newPasswordFocus,
                nextFocus: _confirmPasswordFocus,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                isPassword: true,
                divider: true,
              ),

              CustomTextFieldWidget(
                hintText: 'confirm_password'.tr,
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                isPassword: true,
                onSubmit: (text) => GetPlatform.isWeb ? _resetPassword() : null,
              ),

            ]),
          ),
          const SizedBox(height: 30),

          GetBuilder<AuthController>(builder: (authController) {
            return !authController.isLoading ? CustomButtonWidget(
              buttonText: 'done'.tr,
              onPressed: () => _resetPassword(),
            ) : const Center(child: CircularProgressIndicator());
          }),

        ]))),
      )))),
    );
  }

  void _resetPassword() {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else if(password != confirmPassword) {
      showCustomSnackBar('password_does_not_matched'.tr);
    }else {
      if(widget.fromPasswordChange) {
        ProfileModel user = Get.find<ProfileController>().profileModel!;
        Get.find<ForgotPasswordController>().changePassword(user, password);
      }else {
        Get.find<ForgotPasswordController>().resetPassword(widget.resetToken, '+${widget.number!.trim()}', password, confirmPassword).then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>().login('+${widget.number!.trim()}', password).then((value) async {
              Get.offAllNamed(RouteHelper.getInitialRoute());
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }

}