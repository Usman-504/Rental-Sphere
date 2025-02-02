import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/service_detail_view_model.dart';


class BookingDetailView extends StatelessWidget {
  final Map args;
  const BookingDetailView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ServiceDetailViewModel(),
      child: Consumer<ServiceDetailViewModel>(
          builder: (context, vm, child) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldColor,
              appBar: AppBar(
                backgroundColor: AppColors.blackColor,
                centerTitle: true,
                title:  Text("Booking Details", style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),),
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.all(SizeConfig.scaleHeight(15)),
                  child: BookingDetailCard(
                    rating: vm.rating,
                    controller: vm.reviewController,
                    imageUrl: args['imageUrl'],
                    type: args['type'],
                    model: args['model'],
                    year: args['year'],
                    transmission: args['transmission'],
                    fuelType: args['fuelType'],
                    pricePerDay: args['price'],
                    location: args['location'],
                    serviceType: args['serviceType'],
                    updateRatting: (rating){
                    vm.updateRating(rating);
                  }, focusNode: vm.reviewFocusNode,
                    name: args['name'],
                    phone: args['phone'],
                    address: args['address'],
                    startDate: args['startDate'],
                    endDate: args['endDate'],
                    startTime: args['startTime'],
                    start: args['start'],
                    endTime: args['endTime'],
                    end: args['end'],
                    duration: args['duration'],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}

class BookingDetailCard extends StatelessWidget {
  final String imageUrl;
  final String startDate;
  final int duration;
  final String start;
  final String endDate;
  final String end;
  final String startTime;
  final String endTime;
  final String serviceType;
  final String name;
  final String phone;
  final String address;
  final String type;
  final String model;
  final String year;
  final String transmission;
  final String fuelType;
  final int pricePerDay;
  final String location;
  final double rating;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(double) updateRatting;
  const BookingDetailCard({
    super.key,
    required this.imageUrl,
    required this.type,
    required this.model,
    required this.year,
    required this.transmission,
    required this.fuelType,
    required this.pricePerDay,
    required this.location,
    required this.serviceType,
    required this.rating,
    required this.controller, required this.updateRatting, required this.focusNode, required this.name, required this.phone, required this.address, required this.startDate, required this.endDate, required this.startTime, required this.endTime, required this.start, required this.end, required this.duration,
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
              child: Image.network(
                imageUrl,
                height: SizeConfig.scaleHeight(200),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
              child: Center(child: Text('Customer Information:', style: mediumTextStyle.copyWith(decoration: TextDecoration.underline), )),
            ),
            CustomerInfo(text1: "Name:", text2: name,),
            CustomerInfo(text1: "Phone Number:", text2: phone,),
            CustomerInfo(text1: "Address:", text2: address,),
            Padding(
              padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
              child: Center(child: Text('$serviceType Information:', style: mediumTextStyle.copyWith(decoration: TextDecoration.underline), )),
            ),
            BookingDetailRow(label: serviceType == 'Home' ? 'Type' : serviceType == 'Camera' ? 'Brand' : 'Model', value: model),
            BookingDetailRow(label: serviceType == 'Home' ? 'Bedrooms' : serviceType == 'Camera' ? 'Model' : 'Type', value: type),
            BookingDetailRow(label: serviceType == 'Home' ? 'Bathrooms' :serviceType == 'Camera' ? 'Lens Type' : 'Fuel', value: fuelType),
            BookingDetailRow(label: serviceType == 'Home' ? 'Size' :serviceType == 'Camera' ? 'Sensor Type' : 'Year', value: year),
            BookingDetailRow(label: serviceType == 'Home' ? 'Furnished' :serviceType == 'Camera' ? 'Resolution' :'Transmission', value: transmission),
            BookingDetailRow(label: 'Location', value: location),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
              child: Center(child: Text('Booking Details:', style: mediumTextStyle.copyWith(decoration: TextDecoration.underline), )),
            ),
            BookingDetailRow(label: '$start Date', value: startDate),
            BookingDetailRow(label: '$start Time', value: startTime),
            BookingDetailRow(label: '$end Date', value: endDate),
            BookingDetailRow(label: '$end Time', value: endTime),
            BookingDetailRow(label: 'Price Per Day', value: '${pricePerDay.toString()} Pkr'),
            BookingDetailRow(label: 'No Of Days', value: duration.toString()),
            BookingDetailRow(label: 'Total Price', value: '${pricePerDay * duration} Pkr'),
CustomButton(text: 'Confirm Booking', onPress: (){})
          ],
        ),
      ),
    );
  }
}

class CustomerInfo extends StatelessWidget {
  final String text1;
  final String text2;
  const CustomerInfo({
    super.key, required this.text1, required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: mediumTextStyle.copyWith(
          fontSize: 16,
              fontWeight: FontWeight.bold),),
          Text(text2, style: mediumTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.normal),),
        ],
      ),
    );
  }
}

class BookingDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const BookingDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label: ",   style: smallTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.scaleWidth(16),
          ),),
          Text(value,
            style: smallTextStyle.copyWith(fontSize: SizeConfig.scaleWidth(16)),
          ),
        ],
      ),
    );
  }
}


