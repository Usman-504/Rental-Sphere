import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/services_view_model.dart';

import '../res/components/custom_header.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Header(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.scaleHeight(50),
                      left: SizeConfig.scaleHeight(25),
                      right: SizeConfig.scaleHeight(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All Services:', style: secondaryTextStyle),
                       Column(
                         children: vm.filteredServices,
                       )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

