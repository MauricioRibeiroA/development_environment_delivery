import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CountCardWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String? value;
  final double height;
  const CountCardWidget({super.key, required this.backgroundColor, required this.title, required this.value, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        value != null ? Text(
          value!, style: robotoBold.copyWith(fontSize: 40, color: Theme.of(context).cardColor), textAlign: TextAlign.center,
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ) : Shimmer(
          duration: const Duration(seconds: 2),
          enabled: value == null,
          color: Colors.grey[500]!,
          child: Container(height: 60, width: 50, decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5))),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          title,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
          textAlign: TextAlign.center,
        ),

      ]),
    );
  }
}