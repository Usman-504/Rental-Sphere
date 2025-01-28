import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/signup_view_model.dart';

import '../res/components/navigation_helper.dart';
import '../utils/routes/routes_name.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {




  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ChangeNotifierProvider(
      create: (_)=>SignupViewModel(),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          return   Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: Padding(
              padding:  EdgeInsets.all(SizeConfig.scaleHeight(30)),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rental Sphere', style: primaryTextStyle,),
                      Padding(
                        padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(30),
                            bottom: SizeConfig.scaleHeight(10)
                        ),
                        child: Text('Create An Account', style: secondaryTextStyle.copyWith( fontWeight: FontWeight.normal),),
                      ),
                      Text('We would love to have you on board. Join over 500+ customers around the globe and enhance productivity', style: smallTextStyle,),
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(30)),
                        child: const Divider(
                          thickness: 1,
                          color: AppColors.blackColor,

                        ),
                      ),
                      Text('Name*', style: mediumTextStyle,),
                      CustomTextField(focusNode: viewModel.nameFocusNode, controller:
                      viewModel.nameController, keyboardType: TextInputType.text,  hintText: 'Enter Your Name', current: viewModel.nameFocusNode, next: viewModel.emailFocusNode),
                      Text('Email*', style: mediumTextStyle,),
                      CustomTextField(focusNode: viewModel.emailFocusNode, controller:
                      viewModel.emailController, keyboardType: TextInputType.emailAddress,  hintText: 'Enter Your Email', current: viewModel.emailFocusNode, next: viewModel.passwordFocusNode),
                      Text('Password*', style: mediumTextStyle,),
                      ValueListenableBuilder(
                        valueListenable: viewModel.obscurePassword,
                        builder: (context, vm, child) {
                          return CustomTextField(
                              bottom: 50,
                              isPassword: true,
                              obscurePassword: viewModel.obscurePassword,
                              focusNode: viewModel.passwordFocusNode, controller:
                          viewModel.passwordController, keyboardType: TextInputType.text,  hintText: 'Enter Your Password', current:viewModel.passwordFocusNode, next: null);
                        },

                      ),
                      CustomButton(
                          loading: viewModel.loading,
                          text: 'Sign Up', onPress: (){
                        viewModel.signUp(context);
                      }),
                      Padding(
                        padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(15),
                        ),
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Already have an account ? ',
                              style: mediumTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0), // Default text style
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: mediumTextStyle.copyWith(
                                      fontSize: 12,
                                      color: AppColors.blackColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login, replace: true);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
