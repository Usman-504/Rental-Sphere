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

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: Column(
              children: [
                Header(controller: vm.searchController,),
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
                         Text('All Services:', style: secondaryTextStyle),
                          SizedBox(
                             height: SizeConfig.screenHeight * 0.6,
                            child:  vm.filteredServices.isEmpty ? Center(
                              child: Text('No Service Found', style: smallTextStyle,),
                            ) : ListView.builder(
                               padding: EdgeInsets.zero,
                              itemCount: vm.filteredServices.length,
                              itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: (){
                                    if(index == 0){
                                    NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.carServices, arguments: {
                                      'serviceType' : 'Car',
                                    });
                                  }
                                    if(index == 1){
                                    NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.carServices, arguments: {
                                      'serviceType' : 'Home',
                                    });
                                  }
                                    if(index == 2){
                                    NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.carServices, arguments: {
                                      'serviceType' : 'Camera',
                                    });
                                  }

                                    },
                                  child: ServiceContainer(image: vm.filteredServices[index]['image'], title: vm.filteredServices[index]['title'], subTitle: vm.filteredServices[index]['subTitle'],));
                            },),
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

