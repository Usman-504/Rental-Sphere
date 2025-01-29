import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes.dart';
import '../res/colors.dart';
import '../res/components/custom_button.dart';
import '../res/components/custom_textfield.dart';
import '../utils/assets.dart';
import '../utils/routes/routes_name.dart';
import '../utils/size_config.dart';
import '../utils/styles.dart';
import '../view_model/forgot_pass_view_model.dart';

class ForgotPassView extends StatelessWidget {
  const ForgotPassView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ChangeNotifierProvider(
      create: (_)=>ForgotPassViewModel(),
      child: Consumer<ForgotPassViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: LayoutBuilder(
              builder: (context, constraints) {
                double logoSize = kIsWeb ? constraints.maxWidth * 0.15 : SizeConfig.scaleWidth(307);
                return Row(
                  children: [
                    if (kIsWeb)
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.backgroundImage),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: logoSize,
                                  width: logoSize,
                                  decoration:const  BoxDecoration(
                                    image: DecorationImage(image: AssetImage(Assets.logo,), fit: BoxFit.cover)
                                  ),
                                ),

                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: SizeConfig.scaleHeight(20),
                                          top: SizeConfig.scaleHeight(50),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  kIsWeb ? NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.login, replace: true) :
                                                  Navigator.of(context).maybePop();
                                                },
                                                child: const Icon(
                                                  Icons.arrow_back,
                                                  color: AppColors.blackColor,
                                                )),
                                            Text(
                                              'Forgot Password',
                                              textAlign: TextAlign.center,
                                              style: secondaryTextStyle.copyWith(fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          CustomTextField(
                                            controller: viewModel.emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            hintText: 'Email',
                                            focusNode: viewModel.emailFocusNode,
                                            current: viewModel.emailFocusNode,
                                            next: null,
                                          ),

                                        ],
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(20)),
                                        child: CustomButton(
                                          loading: viewModel.loading,
                                          text: 'Reset Password',
                                          onPress: () {
                                            viewModel.forgotPassword(context);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: SizeConfig.scaleHeight(15),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: 'I Remember My Password ? ',
                                            style: mediumTextStyle.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0), // Default text style
                                            children: [
                                              TextSpan(
                                                text: 'Sign In',
                                                style: mediumTextStyle.copyWith(
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 12,
                                                    color: AppColors.blackColor,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    Navigator.pushNamed(
                                                        context, RoutesName.login);
                                                  },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
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
