import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import '../res/components/services_container.dart';
import '../utils/size_config.dart';
import '../utils/styles.dart';
import '../view_model/all_bookings_view_model.dart';

class AllBookingView extends StatefulWidget {
  const AllBookingView({super.key});

  @override
  State<AllBookingView> createState() => _AllBookingViewState();
}

class _AllBookingViewState extends State<AllBookingView> {
  @override
  void initState() {
    super.initState();
    Provider.of<AllBookingViewModel>(context, listen: false).fetchRole();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllBookingViewModel>(
      builder: (context, viewModel, child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'All Bookings',
                style: secondaryTextStyle.copyWith(color: AppColors.whiteColor,
                ),
              ),
              bottom: TabBar(
                labelColor: AppColors.whiteColor,
                unselectedLabelColor: Colors.grey.withOpacity(0.7),
                indicatorColor: AppColors.whiteColor,
                onTap: viewModel.changeTab,
                tabs: const [
                  Tab(text: 'Car',),
                  Tab(text: 'Home'),
                  Tab(text: 'Camera'),
                ],
              ),
            ),
            body: Padding(
              padding:  EdgeInsets.only(
                  top: SizeConfig.scaleHeight(25),
              ),
              child: TabBarView(
                children: [
                  if(viewModel.role == 'client')...[
                    buildStream(context, viewModel.getCarBookings(), 'Car', viewModel.role.toString()),
                    buildStream(context, viewModel.getHomeBookings(), 'Home',viewModel.role.toString()),
                    buildStream(context, viewModel.getCameraBookings(), 'Camera',viewModel.role.toString()),
                  ]
                  else...[
                    buildStream(context, viewModel.getOwnerCarBookings(), 'Car', viewModel.role.toString()),
                    buildStream(context, viewModel.getOwnerHomeBookings(), 'Home', viewModel.role.toString()),
                    buildStream(context, viewModel.getOwnerCameraBookings(), 'Camera',viewModel.role.toString()),
                  ]

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}




  Widget buildStream(BuildContext context, Stream bookingStream, String serviceType, String role, ) {
    return StreamBuilder(stream: bookingStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(role == 'client' ? 'No $serviceType Booking Found' : 'No $serviceType Order Found', style: smallTextStyle,),
          );
        }
        if (snapshot.data != null) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var item = snapshot.data!.docs[index];
              return InkWell(
                  onTap: () {
                    NavigationHelper
                        .navigateWithSlideTransition(
                        context: context,
                        routeName: RoutesName
                            .bookingDetail,
                        arguments: {
                          'isBooking' : true,
                          'role' : role,
                          'status' : item['status'],
                          'reason' : item['reason'],
                          'collection' : '${serviceType}_bookings',
                          'docId' : item.id,
                          'ownerId' : item['owner_id'],
                          'imageUrl': item['image_url'],
                          'serviceType': serviceType,
                          'price': item['price_per_day'],
                          'location': item['location'],
                          'duration' : item['no_of_days'],
                          'name': item['customer_name'],
                          'phone': item['customer_phone'],
                          'address' :  item['customer_address'],
                          'startDate' :serviceType == 'Home' ? item['Check-In_date'] : item['Pick-Up_date'],
                          'endDate' :serviceType == 'Home' ?  item['Check-Out_date'] : serviceType == 'Camera' ? item['Return_date'] : item['Drop-Off_date'],
                          'startTime' : serviceType == 'Home' ? item['Check-In_time'] : item['Pick-Up_time'],
                          'start' : serviceType == 'Home'? 'Check-In' : 'Pick-Up',
                          'endTime' : serviceType == 'Home' ?  item['Check-Out_time'] : serviceType == 'Camera' ? item['Return_time'] :item['Drop-Off_time'],
                          'end' : serviceType == 'Home' ? 'Check-Out' : serviceType == 'Camera' ? 'Return' : 'Drop-Off',
                          'type': serviceType ==
                              'Camera'
                              ? item['camera_model']
                              : serviceType ==
                              'Car'
                              ? item['car_type']
                              : item['bedrooms'],
                          'model': serviceType ==
                              'Home'
                              ? item['home_type'][0].toUpperCase() + item['home_type'].substring(1)
                              : serviceType ==
                              'Camera'
                              ? item['camera_brand'][0].toUpperCase() + item['camera_brand'].substring(1)
                              : item['car_model'][0].toUpperCase() + item['car_model'].substring(1),
                          'transmission': serviceType ==
                              'Home'
                              ? item['furnished']
                              :serviceType ==
                              'Camera'
                              ? item['resolution']
                              : item['transmission'],
                          'year': serviceType ==
                              'Home'
                              ? item['size']
                              : serviceType ==
                              'Camera'
                              ? item['sensor_type']
                              : item['year'],
                          'fuelType': serviceType ==
                              'Home'
                              ? item['bathrooms']
                              : serviceType ==
                              'Camera'
                              ? item['lens_type']
                              : item['fuel_type'],
                        });
                  },
                  child:
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: SizeConfig.scaleHeight(25)),
                    child: ServiceContainer(
                      booking: true,
                      subService: true,
                      image: item['image_url'],
                      title:'Name: ${item['customer_name'][0].toUpperCase() + item['customer_name'].substring(1)}',
                      subTitle: 'Phone: ${item['customer_phone']}',
                      price: 'Price: ${item['total_price'].toString()} Pkr',
                      location: 'Address: ${item['customer_address']}',
                      status: 'Status: ${item['status']}',
                    ),
                  ));
            },);
        }
        return const CircularProgressIndicator();
      },);
  
}


