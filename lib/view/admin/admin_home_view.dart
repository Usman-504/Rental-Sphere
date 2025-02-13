import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_header.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import '../../utils/size_config.dart';
import '../../utils/styles.dart';
import '../../view_model/admin/admin_home_view_model.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminHomeViewModel(),
      child: Consumer<AdminHomeViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.blackColor,
              child: Icon(Icons.add, color: AppColors.whiteColor),
              onPressed: () {
                NavigationHelper.navigateWithSlideTransition(
                  context: context,
                  routeName: RoutesName.addService,
                );
              },
            ),
            backgroundColor: AppColors.scaffoldColor,
            body: Column(
              children: [
                Header(
                  hintText: 'Filter By Model, Type Or Brand',
                  controller: vm.searchController, onChanged: vm.onChanged,),
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
                          Text('Cars:', style: secondaryTextStyle),
                          _buildServiceList(vm.getCarServices(), 'No Car Service Added', 'Car'),
                          Text('Homes:', style: secondaryTextStyle),
                          _buildServiceList(vm.getHomeServices(), 'No Home Service Added', 'Home'),
                          Text('Cameras:', style: secondaryTextStyle),
                          _buildServiceList(vm.getCameraServices(), 'No Camera Service Added', "Camera"),
                        ],
                      ),
                    ),
                  ),
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
          return  SizedBox(
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
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                 snapshot.data!.docs.length,
                    (index) {
                  var item = snapshot.data!.docs[index];
                  return Padding(
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
                        Positioned(
                          top: SizeConfig.scaleHeight(15),
                            left: SizeConfig.scaleHeight(10),
                            child: InkWell(
                              onTap: (){
                                NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.updateService, arguments: {
                                  'category' : item['category'],
                                  'image_url' : item['image_url'],
                                  'images' : item['image_urls'],
                                  'imagePaths' : item['image_paths'],
                                  'docId' : item.id,
                                  'model': item['category'] ==
                                      'home'
                                      ? item['home_type'][0].toUpperCase() + item['home_type'].substring(1)
                                      : item['category'] ==
                                      'camera'
                                      ? item['camera_brand'][0].toUpperCase() + item['camera_brand'].substring(1)
                                      : item['car_model'][0].toUpperCase() + item['car_model'].substring(1),
                                  'type': item['category'] ==
                                      'camera'
                                      ? item['camera_model']
                                      : item['category'] ==
                                      'car'
                                      ? item['car_type']
                                      : item['bedrooms'],
                                  'fuelType': item['category'] ==
                                      'home'
                                      ? item['bathrooms']
                                      : item['category'] ==
                                      'camera'
                                      ? item['lens_type']
                                      : item['fuel_type'],
                                  'transmission': item['category'] ==
                                      'home'
                                      ? item['furnished']
                                      : item['category'] ==
                                      'camera'
                                      ? item['sensor_type']
                                      : item['transmission'],
                                  'year': item['category'] ==
                                      'home'
                                      ? item['size']
                                      : item['category'] ==
                                      'camera'
                                      ? item['resolution']
                                      : item['year'],
                                  'price': item['price'],
                                  'location': item['location'],
                                  'availableFrom': item['availableFrom'],
                                  'availableTo': item['availableTo'],
                                });
                              },
                              child: Container(
                                  height: SizeConfig.scaleHeight(40),
                                  width: SizeConfig.scaleHeight(40),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Icon(Icons.edit, color: AppColors.blackColor,)),
                            )
                        ),
                        Positioned(
                          top: SizeConfig.scaleHeight(15),
                            right: SizeConfig.scaleHeight(10),
                            child: Container(
                                height: SizeConfig.scaleHeight(40),
                                width: SizeConfig.scaleHeight(40),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: InkWell(
                                    onTap: (){
                                      final vm = Provider.of<AdminHomeViewModel>(context, listen: false);
                                      vm.deleteService(
                                        item['category'],
                                        item.id,
                                        item['image_path'],
                                        item['image_paths'],
                                        context
                                      );
                                    },
                                    child: Icon(Icons.delete, color: AppColors.blackColor,)))),
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
