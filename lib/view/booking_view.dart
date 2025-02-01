import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/res/components/datetime_textfield.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/booking_view_model.dart';

import '../res/components/custom_textfield.dart';


class BookingView extends StatelessWidget {
  final Map args;
  const BookingView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>BookingViewModel(),
      child: Consumer<BookingViewModel>(
          builder: (context, vm, child) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldColor,
              appBar: AppBar(
                backgroundColor: AppColors.blackColor,
                centerTitle: true,
                title:  Text("${args['model']} Booking", style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),),
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.all(SizeConfig.scaleHeight(15)),
                  child: BookingCard(
                    imageUrl: args['imageUrl'],
                    addressFocusNode: vm.addressFocusNode,
                    pickUpDateFocusNode: vm.pickUpDateFocusNode,
                    dropOffDateController: vm.dropOffDateController,
                    dropOffDateFocusNode: vm.dropOffDateFocusNode,
                    dropOffTimeController: vm.dropOffTimeController,
                    dropOffTimeFocusNode: vm.dropOffTimeFocusNode,
                    addressController: vm.addressController,
                    pickUpDateController: vm.pickUpDateController,
                    pickUpTimeController: vm.pickUpTimeController,
                    pickUpTimeFocusNode: vm.pickUpTimeFocusNode,
                    nameController: vm.nameController,
                    phoneController: vm.phoneController,
                    nameFocusNode: vm.nameFocusNode,
                    phoneFocusNode: vm.phoneFocusNode,
                    price: args['price'],
                    pickUpDate: (){
                    vm.selectDate (context,  vm.pickUpDateController);
                  },
                    dropOffDate: (){
                    vm.selectDate (context,  vm.dropOffDateController);
                  },
                    pickUpTime: (){
                      vm.selectTime(context, vm.pickUpTimeController);
                    },
                    dropOffTime: (){
                      vm.selectTime(context, vm.dropOffTimeController);
                    },
                    duration: vm.duration,
                    serviceType: args['serviceType'],
                    model: args['model'],
                    location: args['location'],
                    fuelType: args['fuelType'],
                    transmission: args['transmission'],
                    type: args['type'],
                    year: args['year'],
                    bookNow: () {
                      vm.bookNow(context, {
                        'serviceType' : args['serviceType'],
                        'model' : args['model'],
                        'type' : args['type'],
                        'year' : args['year'],
                        'transmission' : args['transmission'],
                        'fuelType' : args['fuelType'],
                        'imageUrl' : args['imageUrl'],
                        'location' : args['location'],
                        'price' : args['price'],
                        'duration' : vm.duration,
                        'name' : vm.nameController.text.trim(),
                        'phone' : vm.phoneController.text.trim(),
                        'address' : vm.addressController.text.trim(),
                        'startDate' : vm.pickUpDateController.text.trim(),
                        'endDate' : vm.dropOffDateController.text.trim(),
                        'startTime' : vm.pickUpTimeController.text.trim(),
                        'start' : args['serviceType'] == 'Home'? 'Check-In' : 'Pick-Up',
                        'endTime' : vm.dropOffTimeController.text.trim(),
                        'end' : args['serviceType'] == 'Home' ? 'Check-Out' : args['serviceType'] == 'Camera' ? 'Return' : 'Drop-Off',
                      });
                  },
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String imageUrl;
  final String model;
  final String type;
  final String year;
  final String transmission;
  final String fuelType;
  final String location;
  final int price;
  final FocusNode nameFocusNode;
  final FocusNode phoneFocusNode;
  final FocusNode addressFocusNode;
  final FocusNode pickUpDateFocusNode;
  final FocusNode pickUpTimeFocusNode;
  final FocusNode dropOffDateFocusNode;
  final FocusNode dropOffTimeFocusNode;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController pickUpDateController;
  final TextEditingController pickUpTimeController;
  final TextEditingController dropOffDateController;
  final TextEditingController dropOffTimeController;
  final VoidCallback pickUpDate;
  final VoidCallback dropOffDate;
  final VoidCallback pickUpTime;
  final VoidCallback dropOffTime;
  final VoidCallback bookNow;
  final int duration;
  final String serviceType;
  const BookingCard({
    super.key,
    required this.imageUrl,
    required this.addressFocusNode,
    required this.pickUpDateFocusNode,
    required this.pickUpTimeFocusNode,
    required this.dropOffDateFocusNode,
    required this.dropOffTimeFocusNode,
    required this.addressController,
    required this.pickUpDateController,
    required this.pickUpTimeController,
    required this.dropOffDateController,
    required this.dropOffTimeController,
    required this.price,
    required this.pickUpDate,
    required this.dropOffDate,
    required this.pickUpTime,
    required this.dropOffTime,
    required this.duration,
    required this.serviceType,
    required this.nameFocusNode,
    required this.phoneFocusNode,
    required this.nameController,
    required this.phoneController, required this.model, required this.type, required this.year, required this.transmission, required this.fuelType, required this.location, required this.bookNow,
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
                height: SizeConfig.scaleHeight(200),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Text('Name*', style: mediumTextStyle),
            CustomTextField(
              focusNode: nameFocusNode,
              controller: nameController,
              keyboardType: TextInputType.text,
              hintText: 'Enter Your Name',
              current: nameFocusNode,
              next: phoneFocusNode,
            ),
            Text('Phone No*', style: mediumTextStyle),
            CustomTextField(
              focusNode: phoneFocusNode,
              controller: phoneController,
              keyboardType: TextInputType.text,
              hintText: 'Enter Your Phone Number',
              current: phoneFocusNode,
              next: addressFocusNode,
            ),
            Text('Address*', style: mediumTextStyle),
            CustomTextField(
              focusNode: addressFocusNode,
              controller: addressController,
              keyboardType: TextInputType.text,
              hintText: 'Enter Your Address',
              current: addressFocusNode,
              next: pickUpDateFocusNode,
            ),
            Text(serviceType == 'Home'? 'Check-In*' : 'Pick-Up*', style: mediumTextStyle),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: DateTimeTextField(
                    date: true,
                      controller: pickUpDateController,
                      hintText: 'DD/MM/YYYY',  onPress: pickUpDate)
                 ,
                ),
                SizedBox(
                  width: SizeConfig.scaleWidth(10),
                ),
                Expanded(
                  flex: 4,
                  child: DateTimeTextField(
                    date: false,
                      controller: pickUpTimeController,
                      hintText: '12:30 Am',
                       onPress: pickUpTime),
                ),
              ],
            ),
            Text( serviceType == 'Home' ? 'Check-Out*' : serviceType == 'Camera' ? 'Return*' : 'Drop-Off*', style: mediumTextStyle),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: DateTimeTextField(
                    date: true,
                      controller: dropOffDateController,
                      hintText: 'DD/MM/YYYY',
                       onPress: dropOffDate),
                ),
                SizedBox(
                  width: SizeConfig.scaleWidth(10),
                ),
                Expanded(
                  flex: 4,
                  child: DateTimeTextField(
                      controller: dropOffTimeController,
                      hintText: '12:30 Pm', onPress: dropOffTime, date: false),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Duration:', style: mediumTextStyle),
                      Text('${duration.toString()} Days', style: smallTextStyle),
                    ],
                  ),
                ),
                SizedBox(
                  width: SizeConfig.scaleWidth(10)
                ),
                Expanded(
                  flex: 4,
                    child:
                Container(
                  height: SizeConfig.scaleHeight(55),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.blackColor),
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor
                  ),
                  child: Center(child:Text('${price * duration} Pkr', style: smallTextStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.blackColor),)),
                )
                ),
              ],
            ),
            Padding(
              padding:  EdgeInsets.only(top: SizeConfig.scaleWidth(10)),
              child: CustomButton(text: 'Book Now', onPress: bookNow),
            )
          ],
        ),
      ),
    );
  }
}



