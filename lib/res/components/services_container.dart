import 'package:flutter/material.dart';
import 'package:rental_sphere/utils/size_config.dart';

import '../../utils/styles.dart';
import '../colors.dart';

class ServiceContainer extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  const ServiceContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: SizeConfig.scaleHeight(175),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(15)),
              boxShadow: normalBoxShadow,
            ),
          ),
          Container(
            height: SizeConfig.scaleHeight(175),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(15)),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.scaleWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: SizeConfig.scaleHeight(100),
                        width: SizeConfig.scaleHeight(100),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: AppColors.whiteColor, width: 3),
                            shape: BoxShape.circle),
                      ),
                      Positioned(
                        top: SizeConfig.scaleHeight(5),
                        left: SizeConfig.scaleHeight(5),
                        child: Container(
                          height: SizeConfig.scaleHeight(90),
                          width: SizeConfig.scaleHeight(90),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: AssetImage(image)),
                              shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.scaleWidth(210),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: mediumTextStyle.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          subTitle,
                          style: smallTextStyle.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}