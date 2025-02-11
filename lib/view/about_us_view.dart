import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/utils/size_config.dart';
import '../utils/styles.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
      title: Text('About Us', style: secondaryTextStyle.copyWith(color: AppColors.whiteColor)),
    ),
      body: Padding(
        padding:  EdgeInsets.all(SizeConfig.scaleHeight(25)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About Us:', style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),),
              Padding(
                padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(10)),
                child: Text(
                    textAlign: TextAlign.justify,
                    'Welcome to Rental Sphere, your go-to platform for renting cars, houses, and cameras with ease! We bridge the gap between renters and owners, offering a seamless, secure, and hassle-free rental experience. Whether you\'re an individual looking for a temporary solution or a business in need of reliable rentals, we have you covered.\n\n'
                'Our platform is designed to make renting effortless. Need a car for a weekend getaway or a business trip? Looking for a comfortable house for a short-term stay? Or perhaps you need a professional camera for a special event or project? With Rental Sphere, you can browse a diverse range of options, compare prices, and secure your rental in just a few clicks.\n\n'
                'We prioritize security, affordability, and convenience. Our app ensures smooth browsing, verified listings, secure payments, and instant communication between renters and owners. Whether you are renting out your assets or searching for the perfect rental, Rental Sphere provides a trustworthy and efficient marketplace.\n\n'
                'At Rental Sphere, we are committed to making rentals simple, flexible, and accessible to everyone. No more long paperwork or unnecessary delays—just fast, reliable, and hassle-free renting. Find what you need, when you need it, and enjoy a seamless rental experience.\n\n'
                'Start renting smarter with Rental Sphere today!',
                    style: smallTextStyle.copyWith(fontSize: 16)
                ),
          
              ),
            ],
          ),
        ),
      ),
    
    );
  }
}
