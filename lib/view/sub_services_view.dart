import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/services_view_model.dart';
import '../res/components/custom_header.dart';
import '../res/components/services_container.dart';

class SubServicesView extends StatefulWidget {

  final Map args;
  const SubServicesView({super.key,  required this.args});

  @override
  State<SubServicesView> createState() => _SubServicesViewState();
}

class _SubServicesViewState extends State<SubServicesView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, vm, child) {
          Stream<QuerySnapshot> serviceList = widget.args['serviceType'] == 'Car'
              ? vm.getCarServices()
              : widget.args['serviceType'] == 'Home'
              ? vm.getHomeServices()
              : vm.getCameraServices();
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: Column(
              children: [
                Header(
                  onChanged: vm.onChanged,
                  controller: vm.searchSubController,
                hintText: widget.args['serviceType'] == 'Car' ? 'Search & Filter Cars By Model...' : widget.args['serviceType'] == 'Home' ? 'Search & Filter Homes By Type...' : 'Filter Cameras By Brand...',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.scaleHeight(50),
                        left: SizeConfig.scaleHeight(25),
                        right: SizeConfig.scaleHeight(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(bottom: SizeConfig.scaleHeight(15)),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                    child: Icon(Icons.arrow_back, size: 30,)),
                                SizedBox(
                                  width: SizeConfig.scaleWidth(10),
                                ),
                                Text('${widget.args['serviceType']} Services:', style: secondaryTextStyle),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.65,
                            child: StreamBuilder(stream: serviceList,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print('error');
                                  }
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: Text('No ${widget.args['serviceType']} Service Found', style: smallTextStyle,),
                                    );
                                  }
                                  if (snapshot.data != null) {
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var item = snapshot.data!.docs[index];
                                        print(item['reviews']);
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
                                                    'serviceType': widget.args['serviceType'],
                                                    'price': item['price'],
                                                    'location': item['location'],
                                                    'availableFrom': item['availableFrom'],
                                                    'availableTo': item['availableTo'],
                                                    'type': widget.args['serviceType'] ==
                                                        'Camera'
                                                        ? item['camera_model']
                                                        : widget.args['serviceType'] ==
                                                        'Car'
                                                        ? item['car_type']
                                                        : item['bedrooms'],
                                                    'model': widget.args['serviceType'] ==
                                                        'Home'
                                                        ? item['home_type'][0].toUpperCase() + item['home_type'].substring(1)
                                                        : widget.args['serviceType'] ==
                                                        'Camera'
                                                        ? item['camera_brand'][0].toUpperCase() + item['camera_brand'].substring(1)
                                                        : item['car_model'][0].toUpperCase() + item['car_model'].substring(1),
                                                    'transmission': widget.args['serviceType'] ==
                                                        'Home'
                                                        ? item['furnished']
                                                        : widget.args['serviceType'] ==
                                                        'Camera'
                                                        ? item['resolution']
                                                        : item['transmission'],
                                                    'year': widget.args['serviceType'] ==
                                                        'Home'
                                                        ? item['size']
                                                        : widget.args['serviceType'] ==
                                                        'Camera'
                                                        ? item['sensor_type']
                                                        : item['year'],
                                                    'fuelType': widget.args['serviceType'] ==
                                                        'Home'
                                                        ? item['bathrooms']
                                                        : widget.args['serviceType'] ==
                                                        'Camera'
                                                        ? item['lens_type']
                                                        : item['fuel_type'],
                                                  });
                                            },
                                            child:
                                            ServiceContainer(
                                              subService: true,
                                              image: item['image_url'],
                                              title: widget.args['serviceType'] ==
                                                  'Camera'
                                                  ? 'Brand: ${item['camera_brand'][0].toUpperCase() + item['camera_brand'].substring(1)}'
                                                  : widget.args['serviceType'] ==
                                                  'Home' ? 'Type: ${item['home_type'][0].toUpperCase() + item['home_type'].substring(1)}' : 'Type: ${item['car_type']}',
                                              subTitle: widget.args['serviceType'] ==
                                                  'Home'
                                                  ? 'Bedrooms: ${item['bedrooms']}' : widget.args['serviceType'] ==
                                                  'Camera'
                                                  ? 'Model: ${item['camera_model']}'
                                                  : 'Model: ${item['car_model'][0].toUpperCase() + item['car_model'].substring(1)}',
                                              price: 'Price: ${item['price'].toString()} Pkr/day',
                                              location: 'Location: ${item['location']}',
                                              rating: item['averageRating'],
                                            ));
                                      },);
                                  }
                                  return const CircularProgressIndicator();
                                  },)


                            ,
                          )
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
}

