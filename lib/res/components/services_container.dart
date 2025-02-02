import 'package:flutter/material.dart';
import 'package:rental_sphere/utils/size_config.dart';

import '../../utils/styles.dart';
import '../colors.dart';

class ServiceContainer extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final bool? subService;
  // final String? type;
  // final String? model;
  final String? location;
  final double? rating;
  final String? price;
  const ServiceContainer({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    this.subService,
    // this.type,
    // this.model,
    this.location,
    this.price, this.rating,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: SizeConfig.scaleHeight(175),
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: subService == true ? NetworkImage(image) : AssetImage(image), fit: BoxFit.cover),
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
                            border: Border.all(
                                color: AppColors.whiteColor, width: 3),
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
                                  fit: BoxFit.cover, image: subService == true ? NetworkImage(image) : AssetImage(image)),
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
                          style: subService == true
                              ? smallTextStyle.copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w500)
                              : mediumTextStyle.copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold),
                        ),
                        Text(
                          subTitle,
                          style: smallTextStyle.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500),
                        ),
                        subService == true
                            ? Text(
                                price!,
                                style: smallTextStyle.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w500),
                              )
                            : SizedBox.shrink(),
                        subService == true
                            ? Text(
                                location!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: smallTextStyle.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w500),
                              )
                            : SizedBox.shrink(),
                        subService == true
                            ?  Row(
                          children: [
                            Text(
                              'Ratting: ${rating!.toStringAsFixed(2)}',
                              style: smallTextStyle.copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.star, color: Colors.amber, size: 20,)
                          ],
                        )

                            : SizedBox.shrink(),
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
