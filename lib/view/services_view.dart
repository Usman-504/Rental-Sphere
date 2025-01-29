import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/utils/assets.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/services_view_model.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration:
                        const BoxDecoration(color: AppColors.primaryColor),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.scaleHeight(50),
                        bottom: SizeConfig.scaleHeight(25),
                        left: SizeConfig.scaleWidth(25),
                        right: SizeConfig.scaleWidth(25),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hi There',
                                style: primaryTextStyle.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: SizeConfig.scaleWidth(60),
                                    width: SizeConfig.scaleWidth(60),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.secondaryColor,
                                            width: 3),
                                        shape: BoxShape.circle),
                                  ),
                                  Positioned(
                                    top: SizeConfig.scaleHeight(5),
                                    left: SizeConfig.scaleWidth(5),
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: SizeConfig.scaleWidth(50),
                                          width: SizeConfig.scaleWidth(50),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: vm.image!.isNotEmpty
                                                      ? NetworkImage(vm.image!)
                                                      : const AssetImage(
                                                          Assets.dp)),
                                              shape: BoxShape.circle),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.scaleHeight(25),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: SizeConfig.scaleWidth(60),
                                  width: SizeConfig.scaleWidth(280),
                                  child: CustomTextField(
                                      borderColor: AppColors.whiteColor,
                                      hintStyle: mediumTextStyle.copyWith(
                                          fontSize: 16,
                                          color: AppColors.whiteColor),
                                      bottom: 0,
                                      focusNode: vm.searchFocusNode,
                                      controller: vm.searchController,
                                      keyboardType: TextInputType.text,
                                      hintText: 'Search listings...',
                                      current: vm.searchFocusNode,
                                      next: null),
                                ),
                                Container(
                                  height: SizeConfig.scaleWidth(60),
                                  width: SizeConfig.scaleWidth(60),
                                  decoration: const BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.tune,
                                    color: AppColors.whiteColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.scaleHeight(50),
                      horizontal: SizeConfig.scaleHeight(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Services:', style: secondaryTextStyle),
                        const ServiceContainer(
                          image: Assets.car,
                          title: 'Car Rentals',
                          subTitle: 'Find the perfect car for your next trip.',
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(20)),
                          child: const ServiceContainer(
                            image: Assets.home,
                            title: 'Home Rentals',
                            subTitle: 'Book cozy apartments and luxury stays.',
                          ),
                        ),
                        const ServiceContainer(
                          image: Assets.camera,
                          title: 'Camera Rentals',
                          subTitle: 'Rent professional cameras for stunning shots.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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
    return Stack(
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
    );
  }
}
