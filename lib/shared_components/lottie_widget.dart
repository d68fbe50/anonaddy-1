import 'package:anonaddy/shared_components/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  const LottieWidget({
    Key? key,
    this.label,
    this.iconData,
    this.buttonLabel,
    this.buttonOnPress,
    this.iconColor,
    this.scaffoldColor,
    this.lottie,
    this.lottieHeight,
    this.showLoading,
    this.repeat,
  }) : super(key: key);

  final String? label, buttonLabel, lottie;
  final IconData? iconData;
  final Function? buttonOnPress;
  final Color? iconColor, scaffoldColor;
  final double? lottieHeight;
  final bool? showLoading, repeat;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (showLoading ?? false)
          const LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            color: AppColors.accentColor,
          ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            if (lottie != null)
              Center(
                child: Lottie.asset(
                  lottie!,
                  height: lottieHeight,
                  fit: BoxFit.fitHeight,
                  repeat: repeat ?? false,
                ),
              ),
            if (label != null)
              Text(
                label!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
          ],
        ),
      ],
    );
  }
}
