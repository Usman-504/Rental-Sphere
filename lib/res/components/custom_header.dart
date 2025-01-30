import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/assets.dart';
import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../../view_model/services_view_model.dart';
import '../colors.dart';
import 'custom_textfield.dart';

class Header extends StatelessWidget {
  final TextEditingController controller;
  const Header({
    super.key, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final vm = Provider.of<ServicesViewModel>(context, listen: false);
    return Container(
      decoration:
      const BoxDecoration(color: AppColors.blackColor),
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
                      height: SizeConfig.scaleHeight(60),
                      width: SizeConfig.scaleHeight(60),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.whiteColor,
                              width: 3),
                          shape: BoxShape.circle),
                    ),
                    Positioned(
                      top: SizeConfig.scaleHeight(5),
                      left: SizeConfig.scaleHeight(5),
                      child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: SizeConfig.scaleHeight(50),
                            width: SizeConfig.scaleHeight(50),
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
              child: SizedBox(
                height: SizeConfig.scaleWidth(60),
                child: CustomTextField(
                    cursorColor: AppColors.whiteColor,
                    borderColor: AppColors.whiteColor,
                    textStyle:  mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.whiteColor),
                    hintStyle: mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.whiteColor),
                    bottom: 0,
                    focusNode: vm.searchFocusNode,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    hintText: 'Search & Filter listings...',
                    current: vm.searchFocusNode,
                    next: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}