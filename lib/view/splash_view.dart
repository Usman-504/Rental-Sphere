import 'package:flutter/material.dart';
import 'package:rental_sphere/utils/assets.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';

import '../res/colors.dart';
import '../view_model/services/splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});


  @override
  State<SplashView> createState() => _SplashViewState();
}


class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    splashServices.checkAuthentication(context);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return  Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
          color: AppColors.whiteColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: SizeConfig.scaleHeight(300),
                  width: SizeConfig.scaleWidth(300),
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(Assets.logo))
                  ),
                ),
                Text('Rental Sphere', style: secondaryTextStyle,),
              ],
            ),
          )),
    );
  }
}
