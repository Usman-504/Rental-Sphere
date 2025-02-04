import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_header.dart';
import 'package:rental_sphere/view_model/bottom_nav_view_model.dart';
import 'package:rental_sphere/view_model/services_view_model.dart';
import '../res/components/navigation_helper.dart';
import '../utils/routes/routes_name.dart';
import '../utils/size_config.dart';
import '../utils/styles.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: Column(
              children: [
                Header(home: true,),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.scaleHeight(25),
                      vertical: SizeConfig.scaleHeight(15),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cars:', style: secondaryTextStyle),
                              InkWell(
                                  onTap: (){
                                    final bottom = Provider.of<BottomNavViewModel>(context, listen: false);
                                    bottom.changeIndex(1);
                                  },
                                  child: Text('See All', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          _buildServiceList(vm.getCarServices(), 'No Car Service Found', 'Car'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Homes:', style: secondaryTextStyle),
                              InkWell(
                                  onTap: (){
                                    final bottom = Provider.of<BottomNavViewModel>(context, listen: false);
                                    bottom.changeIndex(1);
                                  },
                                  child: Text('See All', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          _buildServiceList(vm.getHomeServices(), 'No Home Service Found', 'Home'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Cameras:', style: secondaryTextStyle),
                              InkWell(
                                  onTap: (){
                                    final bottom = Provider.of<BottomNavViewModel>(context, listen: false);
                                    bottom.changeIndex(1);
                                  },
                                  child: Text('See All', style: smallTextStyle.copyWith(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          _buildServiceList(vm.getCameraServices(), 'No Camera Service Found', "Camera"),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(

                      onPressed: (){
                    vm.logout(context);
                  }, child: Text('Logout')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceList(Stream serviceStream, String emptyMessage, String category) {
    return StreamBuilder(
      stream: serviceStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading data ${snapshot.error.toString()}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: SizeConfig.scaleHeight(175),
              child: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox(
              height: SizeConfig.scaleHeight(175),
              child: Center(child: Text(emptyMessage, style: smallTextStyle)));
        }

        return SizedBox(
          height: SizeConfig.scaleHeight(300),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enables horizontal scrolling
            child: Row(
              children: List.generate(
                snapshot.data!.docs.length > 3 ? 3 : snapshot.data!.docs.length,
                    (index) {
                  var item = snapshot.data!.docs[index];
                  return InkWell(
                    onTap: () {
                      NavigationHelper
                          .navigateWithSlideTransition(
                          context: context,
                          routeName: RoutesName
                              .detailedServices,
                          arguments: {
                            'docId' : item.id,
                            'ownerId' : item['userId'],
                            'reviews' : item['reviews'],
                            'imageUrl': item['image_url'],
                            'serviceType': category,
                            'price': item['price'],
                            'location': item['location'],
                            'availableFrom': item['availableFrom'],
                            'availableTo': item['availableTo'],
                            'type': category ==
                                'Camera'
                                ? item['camera_model']
                                : category ==
                                'Car'
                                ? item['car_type']
                                : item['bedrooms'],
                            'model': category ==
                                'Home'
                                ? item['home_type'][0].toUpperCase() + item['home_type'].substring(1)
                                : category==
                                'Camera'
                                ? item['camera_brand'][0].toUpperCase() + item['camera_brand'].substring(1)
                                : item['car_model'][0].toUpperCase() + item['car_model'].substring(1),
                            'transmission': category ==
                                'Home'
                                ? item['furnished']
                                : category ==
                                'Camera'
                                ? item['resolution']
                                : item['transmission'],
                            'year': category ==
                                'Home'
                                ? item['size']
                                : category ==
                                'Camera'
                                ? item['sensor_type']
                                : item['year'],
                            'fuelType': category ==
                                'Home'
                                ? item['bathrooms']
                                : category ==
                                'Camera'
                                ? item['lens_type']
                                : item['fuel_type'],
                          });
                    },
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(10)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: SizeConfig.scaleHeight(250),
                            width: SizeConfig.scaleHeight(250),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(item['image_url']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Overlay with gradient effect
                          Container(
                            height: SizeConfig.scaleHeight(250),
                            width: SizeConfig.scaleHeight(250),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.2),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          // Text Overlay
                          Positioned(
                            bottom: SizeConfig.scaleHeight(15),
                            child: Container(
                              width: SizeConfig.scaleHeight(220),
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(15), vertical: SizeConfig.scaleHeight(10)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.white.withOpacity(0.9),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(category ==
                                      'Camera' ? '${item['camera_brand'][0].toUpperCase() + item['camera_brand'].substring(1)}' :
                                  category==
                                      'Home' ? '${item['home_type'][0].toUpperCase() + item['home_type'].substring(1)}' : '${item['car_model'][0].toUpperCase() + item['car_model'].substring(1)}',

                                    style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.whiteColor),
                                  ),
                                  Text(
                                    "${item['price'] } Pkr",
                                    style:  mediumTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16, ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }



}
