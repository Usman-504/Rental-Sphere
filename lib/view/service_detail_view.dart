import 'package:flutter/material.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';


class ServiceDetailView extends StatelessWidget {
  final Map args;
  const ServiceDetailView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        centerTitle: true,
        title:  Text("${args['serviceType']} Rental", style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),),
      automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding:  EdgeInsets.all(SizeConfig.scaleHeight(15)),
        child: VehicleCard(
          imageUrl: args['imageUrl'],
          vehicleType: args['type'],
          model: args['model'],
          year: args['year'],
          transmission: args['transmission'],
          fuelType: args['fuelType'],
          pricePerDay: args['price'],
          location: args['location'],
          availableFrom: args['availableFrom'],
          availableTo: args['availableTo'], serviceType: args['serviceType'],
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String imageUrl;
  final String serviceType;
  final String vehicleType;
  final String model;
  final String year;
  final String transmission;
  final String fuelType;
  final String pricePerDay;
  final String location;
  final String availableFrom;
  final String availableTo;
  const VehicleCard({
    super.key,
    required this.imageUrl,
    required this.vehicleType,
    required this.model,
    required this.year,
    required this.transmission,
    required this.fuelType,
    required this.pricePerDay,
    required this.location,
    required this.availableFrom,
    required this.availableTo, required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding:  EdgeInsets.all(SizeConfig.scaleHeight(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                height: SizeConfig.scaleHeight(350),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Text(
                model,
                style:  secondaryTextStyle,
              ),
            ),
            VehicleDetailText(label: 'Type', value: vehicleType),
            VehicleDetailText(label: 'Fuel', value: fuelType),
            VehicleDetailText(label: 'Model', value: year),
            VehicleDetailText(label: 'Mode', value: transmission),
            VehicleDetailText(label: 'Availability', value: '$availableFrom - $availableTo'),
            VehicleDetailText(label: 'Location', value: location),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Per Day', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold),),
                    Text('$pricePerDay Pkr', style: secondaryTextStyle,),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.scaleWidth(50),
                ),
                Expanded(child: CustomButton(text: 'Rent $serviceType', onPress: (){}))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class VehicleDetailText extends StatelessWidget {
  final String label;
  final String value;

  const VehicleDetailText({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(10)),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: smallTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.scaleWidth(16),
          ),
          children: [
            TextSpan(
              text: value,
              style: smallTextStyle.copyWith(fontSize: SizeConfig.scaleWidth(16)),
            ),
          ],
        ),
      ),
    );
  }
}


