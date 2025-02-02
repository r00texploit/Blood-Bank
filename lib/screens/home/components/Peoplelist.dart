import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobileapp/components/product_card.dart';
import 'package:mobileapp/controllers/person_controller.dart';
import 'package:get/get.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key});

  @override
  State<StatefulWidget> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  PersonController person = Get.put(PersonController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    person.onInit();
    log('message: Person List Initialized Successfully => \n ${person.persons.toJson()}');
  }

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
          child: Obx(
            () {
              return Column(
                children: [
                  ...List.generate(
                    person.persons.length,
                    (index) {
                      if (person.persons.value[index].isPopular!) {
                        return ProductCard(product: person.persons.value[index]);
                      }
              
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
