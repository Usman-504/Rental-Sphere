import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/view_model/change_password_view_model.dart';

import '../res/components/custom_button.dart';
import '../res/components/custom_textfield.dart';
import '../utils/styles.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ChangePasswordViewModel(),
      child: Consumer<ChangePasswordViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.whiteColor,
                  )),
              centerTitle: true,
              title: Text('Change Password',
                  style: secondaryTextStyle.copyWith(
                      color: AppColors.whiteColor)),
            ),
            body: Padding(
              padding:  EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(25)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Old Password*',
                    style: mediumTextStyle,
                  ),
                  ValueListenableBuilder(
                    valueListenable: viewModel.obscureOldPassword,
                    builder: (context, vm, child) {
                      return CustomTextField(
                        bottom: 20,
                        isPassword: true,
                        obscurePassword: viewModel.obscureOldPassword,
                        focusNode: viewModel.oldPasswordFocusNode,
                        controller: viewModel.oldPasswordController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter Old Password',
                        current: viewModel.oldPasswordFocusNode,
                        next: viewModel.newPasswordFocusNode,
                      );
                    },
                  ),
                  Text(
                    'New Password*',
                    style: mediumTextStyle,
                  ),
                  ValueListenableBuilder(
                    valueListenable: viewModel.obscureNewPassword,
                    builder: (context, vm, child) {
                      return CustomTextField(
                        bottom: 20,
                        isPassword: true,
                        obscurePassword: viewModel.obscureNewPassword,
                        focusNode: viewModel.newPasswordFocusNode,
                        controller: viewModel.newPasswordController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter New Password',
                        current: viewModel.newPasswordFocusNode,
                        next: viewModel.confirmPasswordFocusNode,
                      );
                    },
                  ),
                  Text(
                    'Confirm Password*',
                    style: mediumTextStyle,
                  ),
                  ValueListenableBuilder(
                    valueListenable: viewModel.obscureConfirmPassword,
                    builder: (context, vm, child) {
                      return CustomTextField(
                        bottom: 20,
                        isPassword: true,
                        obscurePassword: viewModel.obscureConfirmPassword,
                        focusNode: viewModel.confirmPasswordFocusNode,
                        controller: viewModel.confirmPasswordController,
                        keyboardType: TextInputType.text,
                        hintText: 'Enter Confirm Password',
                        current: viewModel.confirmPasswordFocusNode,
                        next:null,
                      );
                    },
                  ),
              
                  CustomButton(
                    loading: viewModel.loading,
                    text: 'Save',  onPress: (){
                   viewModel.changePassword(context);
                  }, )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}