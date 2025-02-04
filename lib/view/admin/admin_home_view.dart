import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_header.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import '../../res/components/services_container.dart';
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
                          _buildServiceList(vm.getCarServices(), 'No Car Service Found', 'Car'),
                          Text('Homes:', style: secondaryTextStyle),
                          _buildServiceList(vm.getHomeServices(), 'No Home Service Found', 'Home'),
                          Text('Cameras:', style: secondaryTextStyle),
                          _buildServiceList(vm.getCameraServices(), 'No Camera Service Found', "Camera"),
                         ElevatedButton(onPressed: (){
                           vm.logout(context);
                         }, child: Text('Logout'))
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

        return Column(
          children: List.generate(snapshot.data!.docs.length, (index){
            var item = snapshot.data!.docs[index];
            return ServiceContainer(
              subService: true,
              image: item['image_url'],
              title: category ==
                  'Camera'
                  ? 'Brand: ${item['camera_brand'][0].toUpperCase() + item['camera_brand'].substring(1)}'
                  : category==
                  'Home' ? 'Type: ${item['home_type'][0].toUpperCase() + item['home_type'].substring(1)}' : 'Type: ${item['car_type']}',
              subTitle:category ==
                  'Home'
                  ? 'Bedrooms: ${item['bedrooms']}' : category ==
                  'Camera'
                  ? 'Model: ${item['camera_model']}'
                  : 'Model: ${item['car_model'][0].toUpperCase() + item['car_model'].substring(1)}',
              price: 'Price: ${item['price'].toString()} Pkr/day',
              location: 'Location: ${item['location']}',
              rating: item['averageRating'],
            );
          }

            ),

        );
      },
    );
  }
}
