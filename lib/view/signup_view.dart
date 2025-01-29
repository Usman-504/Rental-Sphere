import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/utils/assets.dart';
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
      create: (_) => SignupViewModel(),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: LayoutBuilder(
              builder: (context, constraints) {
                // bool isWeb = constraints.maxWidth > 600;
                return Row(
                  children: [
                    if (kIsWeb)
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.backgroundImage), // Use your background image
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome to Rental Sphere',
                                  style: primaryTextStyle.copyWith(
                                      fontSize: 28, color: Colors.white),
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(30),
                                      horizontal: SizeConfig.scaleWidth(40),

                                  ),
                                  child: Text(
                                    'The best global marketplace for cars, homes, and cameras. Have a car, home, or camera? Earn money as a Host. Rent your dream ride, stay, or gear as a Guest.',
                                    textAlign: TextAlign.center,
                                    style: smallTextStyle.copyWith(
                                        color: AppColors.whiteColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kIsWeb ? 100 : 30, vertical:kIsWeb ? 10 : 30),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rental Sphere', style: primaryTextStyle),
                                Padding(
                                  padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(30),
                                      bottom: SizeConfig.scaleHeight(10)
                                  ),
                                  child: Text('Create An Account', style: secondaryTextStyle.copyWith(fontWeight: FontWeight.normal)),
                                ),
                                Text(
                                  'Join over 500+ customers around the globe and enhance productivity.',
                                  style: smallTextStyle,
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(30)),
                                  child: const Divider(
                                    thickness: 1,
                                    color: AppColors.blackColor,

                                  ),
                                ),

                                Text('Name*', style: mediumTextStyle),
                                CustomTextField(
                                  focusNode: viewModel.nameFocusNode,
                                  controller: viewModel.nameController,
                                  keyboardType: TextInputType.text,
                                  hintText: 'Enter Your Name',
                                  current: viewModel.nameFocusNode,
                                  next: viewModel.emailFocusNode,
                                ),
                                Text('Email*', style: mediumTextStyle),
                                CustomTextField(
                                  focusNode: viewModel.emailFocusNode,
                                  controller: viewModel.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: 'Enter Your Email',
                                  current: viewModel.emailFocusNode,
                                  next: viewModel.passwordFocusNode,
                                ),
                                Text('Password*', style: mediumTextStyle),
                                ValueListenableBuilder(
                                  valueListenable: viewModel.obscurePassword,
                                  builder: (context, vm, child) {
                                    return CustomTextField(
                                      bottom: 50,
                                      isPassword: true,
                                      obscurePassword: viewModel.obscurePassword,
                                      focusNode: viewModel.passwordFocusNode,
                                      controller: viewModel.passwordController,
                                      keyboardType: TextInputType.text,
                                      hintText: 'Enter Your Password',
                                      current: viewModel.passwordFocusNode,
                                      next: null,
                                    );
                                  },
                                ),

                                CustomButton(
                                  loading: viewModel.loading,
                                  text: 'Sign Up',
                                  onPress: () => viewModel.signUp(context),
                                ),
                                Center(
                                  child: Padding(
                                    padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(15),
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Already have an account? ',
                                        style: mediumTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                        children: [
                                          TextSpan(
                                            text: 'Sign In',
                                            style: mediumTextStyle.copyWith(
                                                fontSize: 12,
                                                color: AppColors.blackColor,
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w700),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                NavigationHelper.navigateWithSlideTransition(
                                                    context: context,
                                                    routeName: RoutesName.login,
                                                    replace: true);
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
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
