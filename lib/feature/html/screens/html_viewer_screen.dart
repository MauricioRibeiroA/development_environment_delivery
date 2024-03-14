import 'package:stackfood_multivendor_driver/feature/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_app_bar_widget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatelessWidget {
  final bool isPrivacyPolicy;
  const HtmlViewerScreen({super.key, required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {

    String? data = isPrivacyPolicy ? Get.find<SplashController>().configModel!.privacyPolicy : Get.find<SplashController>().configModel!.termsAndConditions;

    return Scaffold(

      appBar: CustomAppBarWidget(title: isPrivacyPolicy ? 'privacy_policy'.tr : 'terms_condition'.tr),

      body: Container(
        height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics: const BouncingScrollPhysics(),
          child: HtmlWidget(
            data ?? '',
            key: Key(isPrivacyPolicy ? 'privacy_policy' : 'terms_condition'),
            onTapUrl: (String url) {
              return launchUrlString(url, mode: LaunchMode.externalApplication);
            },
          ),
        ),
      ),
    );
  }
}