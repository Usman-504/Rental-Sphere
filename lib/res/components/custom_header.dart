import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/assets.dart';
import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../../view_model/services_view_model.dart';
import '../colors.dart';
import 'custom_textfield.dart';

class Header extends StatefulWidget {
  final TextEditingController? controller;
  final bool home;
  final String? hintText;
  final Function(String?)? onChanged;
  const Header({
    super.key,  this.controller, this.hintText, this.onChanged,
    this. home = false,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ServicesViewModel>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final vm = Provider.of<ServicesViewModel>(context);
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
                                    image: vm.image.isNotEmpty
                                        ? NetworkImage(vm.image)
                                        : const AssetImage(
                                        Assets.dp)),
                                shape: BoxShape.circle),
                          )),
                    ),
                  ],
                ),
              ],
            ),
            if(widget.home == false)
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.scaleHeight(25),
              ),
              child: SizedBox(
                height: SizeConfig.scaleWidth(60),
                child: CustomTextField(
                  onChanged: widget.onChanged,
                    cursorColor: AppColors.whiteColor,
                    borderColor: AppColors.whiteColor,
                    textStyle:  mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.whiteColor),
                    hintStyle: mediumTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.hintTextColor),
                    bottom: 0,
                    focusNode: vm.searchFocusNode,
                    controller: widget.controller!,
                    keyboardType: TextInputType.text,
                    hintText: widget.hintText ?? 'Search & Filter listings...',
                    current: vm.searchFocusNode,
                    next: null),
              ),
            ),
            if(widget.home == true)
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.scaleHeight(25),
                ),
                child: Text('Welcome To Rental Sphere', style: primaryTextStyle.copyWith(color: AppColors.whiteColor, fontWeight: FontWeight.normal, fontSize: SizeConfig.scaleWidth(25)),),
              ),
          ],
        ),
      ),
    );
  }
}