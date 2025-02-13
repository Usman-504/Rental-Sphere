import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/booking_detail_view_model.dart';

class BookingDetailView extends StatelessWidget {
  final Map args;
  const BookingDetailView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingDetailViewModel(),
      child: Consumer<BookingDetailViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: AppColors.whiteColor,
                  )),
              backgroundColor: AppColors.blackColor,
              centerTitle: true,
              title: Text(
                "Booking Details",
                style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),
              ),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.scaleHeight(15)),
                child: BookingDetailCard(
                  imageUrl: args['imageUrl'],
                  type: args['type'],
                  model: args['model'],
                  year: args['year'],
                  transmission: args['transmission'],
                  fuelType: args['fuelType'],
                  pricePerDay: args['price'],
                  location: args['location'],
                  serviceType: args['serviceType'],
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
                  paymentStatus: vm.isPaymentSuccessful,
                  onPress1: () {
                    vm.paymentSheet(
                        args['price'] * args['duration'], 'PKR', context);
                  },
                  onPress2: () {
                    vm.confirmBooking({
                      'image_url': args['imageUrl'],
                      'customer_name': args['name'],
                      'customer_phone': args['phone'],
                      'customer_address': args['address'],
                      'location': args['location'],
                      'price_per_day': args['price'],
                      'no_of_days': args['duration'],
                      'status': 'Pending',
                      'reason': '',
                      'user_id': FirebaseAuth.instance.currentUser!.uid,
                      'owner_id': args['ownerId'],
                      'total_price': args['price'] * args['duration'],
                      '${args['start']}_date': args['startDate'],
                      '${args['end']}_date': args['endDate'],
                      '${args['start']}_time': args['startTime'],
                      '${args['end']}_time': args['endTime'],
                      args['serviceType'] == 'Home'
                          ? 'home_type'
                          : args['serviceType'] == 'Camera'
                              ? 'camera_brand'
                              : 'car_model': args['model'],
                      args['serviceType'] == 'Home'
                          ? 'bedrooms'
                          : args['serviceType'] == 'Camera'
                              ? 'camera_model'
                              : 'car_type': args['type'],
                      args['serviceType'] == 'Home'
                          ? 'bathrooms'
                          : args['serviceType'] == 'Camera'
                              ? 'lens_type'
                              : 'fuel_type': args['fuelType'],
                      args['serviceType'] == 'Home'
                          ? 'furnished'
                          : args['serviceType'] == 'Camera'
                              ? 'resolution'
                              : 'transmission': args['transmission'],
                      args['serviceType'] == 'Home'
                          ? 'size'
                          : args['serviceType'] == 'Camera'
                              ? 'sensor_type'
                              : 'year': args['year'],
                    }, context, args['serviceType']);
                  },
                  loading1: vm.paymentLoading,
                  loading2: vm.loading,
                  isBooking: args['isBooking'],
                  role: args['role'],
                  status: args['status'],
                  onPress3: () {
                    vm.updateBookingStatus(
                        args['collection'], args['docId'], true, context);
                  },
                  onPress4: () {
                    vm.updateBookingStatus(
                        args['collection'], args['docId'], false, context);
                  },
                  reason: vm.rejectReason,
                  reasonController: vm.reasonController,
                  reasonFocusNode: vm.reasonFocusNode, rejectReason: args['reason'],
                ),
              ),
            ),
          );
        },
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
  final bool isBooking;
  final String role;
  final bool paymentStatus;
  final VoidCallback onPress1;
  final VoidCallback onPress2;
  final VoidCallback onPress3;
  final VoidCallback onPress4;
  final bool loading1;
  final bool loading2;
  final bool reason;
  final String rejectReason;
  final String status;
  final TextEditingController reasonController;
  final FocusNode reasonFocusNode;

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
    required this.name,
    required this.phone,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.start,
    required this.end,
    required this.duration,
    required this.paymentStatus,
    required this.onPress1,
    required this.onPress2,
    required this.loading1,
    required this.loading2,
    required this.isBooking,
    required this.role,
    required this.status,
    required this.onPress3,
    required this.onPress4,
    required this.reason, required this.reasonController, required this.reasonFocusNode, required this.rejectReason,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleHeight(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: SizeConfig.scaleHeight(200),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(imageUrl), fit: BoxFit.cover)),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
              child: Center(
                  child: Text(
                'Customer Information:',
                style: mediumTextStyle.copyWith(
                    decoration: TextDecoration.underline),
              )),
            ),
            CustomerInfo(
              text1: "Name:",
              text2: name,
            ),
            CustomerInfo(
              text1: "Phone Number:",
              text2: phone,
            ),
            CustomerInfo(
              text1: "Address:",
              text2: address,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
              child: Center(
                  child: Text(
                '$serviceType Information:',
                style: mediumTextStyle.copyWith(
                    decoration: TextDecoration.underline),
              )),
            ),
            BookingDetailRow(
                label: serviceType == 'Home'
                    ? 'Type'
                    : serviceType == 'Camera'
                        ? 'Brand'
                        : 'Model',
                value: model),
            BookingDetailRow(
                label: serviceType == 'Home'
                    ? 'Bedrooms'
                    : serviceType == 'Camera'
                        ? 'Model'
                        : 'Type',
                value: type),
            BookingDetailRow(
                label: serviceType == 'Home'
                    ? 'Bathrooms'
                    : serviceType == 'Camera'
                        ? 'Lens Type'
                        : 'Fuel',
                value: fuelType),
            BookingDetailRow(
                label: serviceType == 'Home'
                    ? 'Size'
                    : serviceType == 'Camera'
                        ? 'Sensor Type'
                        : 'Year',
                value: serviceType == 'Home' ? '$year (Sqft)' : year),
            BookingDetailRow(
                label: serviceType == 'Home'
                    ? 'Furnished'
                    : serviceType == 'Camera'
                        ? 'Resolution'
                        : 'Transmission',
                value: transmission),
            BookingDetailRow(label: 'Location', value: location),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(20)),
              child: Center(
                  child: Text(
                'Booking Details:',
                style: mediumTextStyle.copyWith(
                    decoration: TextDecoration.underline),
              )),
            ),
            BookingDetailRow(label: '$start Date', value: startDate),
            BookingDetailRow(label: '$start Time', value: startTime),
            BookingDetailRow(label: '$end Date', value: endDate),
            BookingDetailRow(label: '$end Time', value: endTime),
            BookingDetailRow(
                label: 'Price Per Day', value: '${pricePerDay.toString()} Pkr'),
            BookingDetailRow(label: 'No Of Days', value: duration.toString()),
            BookingDetailRow(
                label: 'Total Price', value: '${pricePerDay * duration} Pkr'),
            if (!isBooking)
              Column(
                children: [
                  BookingDetailRow(
                      label: 'Payment Status',
                      value: paymentStatus == true ? 'Paid' : 'Pending'),
                  CustomButton(
                    text: 'Make Payment',
                    onPress: onPress1,
                    loading: loading1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.scaleHeight(20)),
                    child: CustomButton(
                      text: 'Confirm Booking',
                      onPress: onPress2,
                      loading: loading2,
                    ),
                  ),
                ],
              ),
            if (isBooking)
              BookingDetailRow(label: 'Booking Status', value: status),
              if(rejectReason.isNotEmpty && rejectReason != '')
                CustomerInfo(
                  style1: smallTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.scaleWidth(16),
                  ),
                  style2:smallTextStyle.copyWith(fontSize: SizeConfig.scaleWidth(16)),
                  text1: "Reason:",
                  text2: rejectReason,
                ),
            if (isBooking && role == 'admin')
              Column(
                children: [
                  CustomButton(
                    text: 'Accept Booking',
                    onPress: onPress3,
                    loading: loading2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.scaleHeight(20)),
                    child: CustomButton(
                      text: 'Reject Booking',
                      onPress: onPress4,
                      loading: loading1,
                    ),
                  ),
                  if (reason)
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.scaleHeight(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add Reason:', style: mediumTextStyle,),
                          CustomTextField(
                            maxLines: 5,
                              focusNode: reasonFocusNode,
                              controller: reasonController,
                              keyboardType: TextInputType.text,
                              hintText: 'Enter Reason',
                              current: reasonFocusNode,
                              next: null),
                        ],
                      ),
                    )
                ],
              )
          ],
        ),
      ),
    );
  }
}

class CustomerInfo extends StatelessWidget {
  final String text1;
  final String text2;
  final TextStyle? style1;
  final TextStyle? style2;
  const CustomerInfo({
    super.key,
    required this.text1,
    required this.text2, this.style1, this.style2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.scaleHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: style1 ?? mediumTextStyle.copyWith(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            text2,
            style: style2 ?? mediumTextStyle.copyWith(
                fontSize: 16, fontWeight: FontWeight.normal),
          ),
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
          Text(
            "$label: ",
            style: smallTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.scaleWidth(16),
            ),
          ),
          Text(
            value,
            style: smallTextStyle.copyWith(fontSize: SizeConfig.scaleWidth(16)),
          ),
        ],
      ),
    );
  }
}
