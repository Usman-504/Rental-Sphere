import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/utils/utils.dart';
import 'package:rental_sphere/view_model/service_detail_view_model.dart';


class ServiceDetailView extends StatelessWidget {
  final Map args;
  const ServiceDetailView({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('MM/dd/yyyy');
    DateTime availableStartDate = format.parse(args['availableFrom']);
    DateTime availableEndDate = format.parse(args['availableTo']);
    return ChangeNotifierProvider(
      create: (_)=>ServiceDetailViewModel()..setAvailableDates(availableStartDate, availableEndDate),
      child: Consumer<ServiceDetailViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              leading: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, size: 30, color: AppColors.whiteColor,)),
              backgroundColor: AppColors.blackColor,
              centerTitle: true,
              title:  Text("${args['serviceType']} Rental", style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(SizeConfig.scaleHeight(15)),
                child: ServiceDetailCard(
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
                  availableFrom: args['availableFrom'],
                  availableTo: args['availableTo'], serviceType: args['serviceType'], updateRatting: (rating){
                    vm.updateRating(rating);
                }, focusNode: vm.reviewFocusNode,
                  submitReview: () {
                    vm.submitReview(args['serviceType'].toString().toLowerCase(), args['docId'], context);
                },
                  loading: vm.loading,
                  reviews: args['reviews'],
                  ownerId: args['ownerId'],
                  available: vm.isDateAvailable(DateTime.now()),
                  images: args['images'],
                  ownerImage: args['ownerImage'],
                  ownerName: args['ownerName'],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class ServiceDetailCard extends StatelessWidget {
  final String imageUrl;
  final String ownerImage;
  final String ownerName;
  final List<dynamic> images;
  final String serviceType;
  final String ownerId;
  final String type;
  final String model;
  final String year;
  final String transmission;
  final String fuelType;
  final int pricePerDay;
  final String location;
  final String availableFrom;
  final bool available;
  final String availableTo;
  final double rating;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(double) updateRatting;
  final VoidCallback submitReview;
  final bool loading;
  final List<dynamic> reviews;
  const ServiceDetailCard({
    super.key,
    required this.imageUrl,
    required this.type,
    required this.model,
    required this.year,
    required this.transmission,
    required this.fuelType,
    required this.pricePerDay,
    required this.location,
    required this.availableFrom,
    required this.availableTo,
    required this.serviceType,
    required this.rating,
    required this.controller,
    required this.updateRatting,
    required this.focusNode,
    required this.submitReview,
    required this.loading,
    required this.reviews,
    required this.ownerId,
    required this.available,
    required this.images, required this.ownerImage, required this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    String getFormattedName(String fullName) {
      List<String> nameParts = fullName.split(' '); 
      String firstName = nameParts.first; 
      return firstName.length > 8 ? firstName.substring(0, 8) : firstName;
    }
    
    final vm = Provider.of<ServiceDetailViewModel>(context, listen: false);
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
            Container(
              height: SizeConfig.scaleHeight(200),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: NetworkImage(imageUrl), fit: BoxFit.cover)
              ),
            ),
           images.isNotEmpty ? Padding(
              padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(20)),
              child: Text(
                'Photo Gallery:',
                style:  mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ) : SizedBox.shrink(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(images.length, (index) {
                  return  Container(
                    margin: EdgeInsets.all(5),
                    width: SizeConfig.scaleHeight(130),
                    height: SizeConfig.scaleHeight(130),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(images[index]), fit: BoxFit.cover),
                      border: Border.all(color: AppColors.blackColor, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),

                  );
                }),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Container(
                height: SizeConfig.scaleHeight(100),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                  boxShadow: normalBoxShadow
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: SizeConfig.scaleHeight(10)),
                  child: Row(
                    children: [
                      Container(
                        height: SizeConfig.scaleHeight(80),
                        width: SizeConfig.scaleHeight(80),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage(ownerImage), fit: BoxFit.cover)
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.scaleWidth(15),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ownerName, style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),),
                          Text('Owner', style: smallTextStyle,)
                        ],
                      ),
                      SizedBox(
                        width: SizeConfig.scaleWidth(50),
                      ),
                      Expanded(
                        child: CustomButton(
                            text: 'Chat', onPress: (){
                              NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.specificChat, arguments: {
                                'senderId' : FirebaseAuth.instance.currentUser!.uid,
                                'receiverId' : ownerId,
                                'name' : ownerName,
                                'image' : ownerImage,
                              });
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(10)),
              child: Text(
                model,
                style:  secondaryTextStyle,
              ),
            ),
            ServiceDetailText(label: serviceType == 'Home' ? 'Bedrooms' : serviceType == 'Camera' ? 'Model' : 'Type', value: type),
            ServiceDetailText(label: serviceType == 'Home' ? 'Bathrooms' :serviceType == 'Camera' ? 'Lens Type' : 'Fuel', value: fuelType),
            ServiceDetailText(label: serviceType == 'Home' ? 'Size' :serviceType == 'Camera' ? 'Sensor Type' : 'Year', value: serviceType == 'Home' ? '$year (Sqft)' : year),
            ServiceDetailText(label: serviceType == 'Home' ? 'Furnished' :serviceType == 'Camera' ? 'Resolution' :'Transmission', value: transmission),
            ServiceDetailText(label: 'Availability', value: '$availableFrom - $availableTo'),
            ServiceDetailText(label: 'Location', value: location),
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
                Expanded(child: CustomButton(text: 'Rent $serviceType', onPress: (){
                  if(available){
                  NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.booking, arguments: {
                    'serviceType' : serviceType,
                    'model' : model,
                    'type' : type,
                    'year' : year,
                    'transmission' : transmission,
                    'fuelType' : fuelType,
                    'imageUrl' : imageUrl,
                    'location' : location,
                    'price' : pricePerDay,
                    'ownerId' : ownerId,
                    'startDate' : availableFrom,
                    'endDate' : availableTo,
                  });
                }
                else{
                  Utils.flushBarMessage('Service Not Available Right Now', context, true);
                  }
                }))
              ],
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rate This Service:", style: smallTextStyle.copyWith( fontWeight: FontWeight.bold)),
                RatingBar.builder(
                  initialRating: rating,
                    minRating: 1,
                    maxRating: 5,
                    allowHalfRating: true,
                    tapOnlyMode: true,
                    itemSize: 20,
                    itemBuilder: (BuildContext context, int index) {
                      if (index + 1 <= rating) {
                        return const Icon(Icons.star, color: Colors.amber); // Fully filled star
                      } else if (index + 0.5 == rating) {
                        return const Icon(Icons.star_half, color: Colors.amber); // Half-filled star
                      } else {
                        return const Icon(Icons.star_border, color: Colors.amber); // Empty star
                      }
                    },
                    onRatingUpdate: updateRatting),
                rating == 0 ? SizedBox.shrink() :
                Text('(${rating.toString()})', style: smallTextStyle,),
              ],
            ),
            if(rating >0)
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(10)),
                    child: CustomTextField(
                      maxLines: 5,
                        focusNode: focusNode,
                        controller: controller,
                        keyboardType: TextInputType.text,
                        hintText: 'Leave a Review',
                        current: focusNode,
                        next: null),
                  ),
                  CustomButton(
                    loading: loading,
                      text: 'Submit Review', onPress: submitReview)
                ],
              ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
              child: Divider(
                thickness: 1,
                color: AppColors.blackColor,
              ),
            ),
            if(reviews.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reviews:', style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16),),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                            flex: 1,
                            child: Container(
                                height: SizeConfig.scaleHeight(80),
                                width: SizeConfig.scaleHeight(80),
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                  boxShadow: normalBoxShadow,
                                    shape: BoxShape.rectangle,
                                  image: DecorationImage(image: NetworkImage(reviews[index]['image']),fit: BoxFit.cover)
                                ),
                              ),
                          ),
                                SizedBox(
                                  width: SizeConfig.scaleWidth(15),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getFormattedName(reviews[index]['name'].toString()), style: mediumTextStyle,),
                                          Text(vm.formatedDate(reviews[index]['date']), style: smallTextStyle,),
                        
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            ignoreGestures: true,
                                            initialRating: reviews[index]['rating'].toDouble(), // Ensure it's a double
                                            allowHalfRating: true,
                                            tapOnlyMode: true,
                                            itemCount: 5,
                                            itemSize: 20,
                        
                                            itemBuilder: (BuildContext context, int starIndex) {
                                              double rating = reviews[index]['rating'].toDouble();
                        
                                              if (starIndex + 1 <= rating) {
                                                return const Icon(Icons.star, color: Colors.amber); // Fully filled star
                                              } else if (starIndex + 0.5 <= rating) {
                                                return const Icon(Icons.star_half, color: Colors.amber); // Half-filled star
                                              } else {
                                                return const Icon(Icons.star_border, color: Colors.grey);
                                              }
                                            },
                                            onRatingUpdate: (_) {},
                                          ),
                                          Text('(${reviews[index]['rating']})', style: smallTextStyle,),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top: SizeConfig.scaleHeight(10)),
                              child: Text(
                                textAlign: TextAlign.justify,
                                reviews[index]['review'], style: smallTextStyle,),
                            ),
                          ],
                        ),
                      );
                    },)
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class ServiceDetailText extends StatelessWidget {
  final String label;
  final String value;

  const ServiceDetailText({
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


