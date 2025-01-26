import 'package:flutter/material.dart';
import 'package:mobileapp/components/product_card.dart';
import 'package:mobileapp/controllers/person_controller.dart';
import 'package:mobileapp/models/personlist.dart';
import 'package:get/get.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class PeopleList extends StatelessWidget {
  PersonController person = Get.put(PersonController());
  PeopleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Donars Near You!", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ...List.generate(
                person.persons!.length,
                (index) {
                  if (person.persons![index].isPopular!) {
                    return ProductCard(product: person.persons![index]);
                  }

                  return SizedBox.shrink();
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
