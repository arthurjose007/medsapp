import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor = const Color.fromARGB(255, 158, 158, 158);

  bool isSelected;

  CategoryModel({
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Capsule',
        iconPath: 'assets/icons/tablet.gif',
      ),
    );

    categories.add(CategoryModel(
      name: 'Tablet',
      iconPath: 'assets/icons/pills.gif',
    ));

    categories.add(CategoryModel(
      name: 'Liquid',
      iconPath: 'assets/icons/liquid.gif',
    ));

    categories.add(CategoryModel(
      name: 'Topical',
      iconPath: 'assets/icons/tube.gif',
    ));

    categories.add(CategoryModel(
      name: 'Cream',
      iconPath: 'assets/icons/cream.gif',
    ));

    categories.add(CategoryModel(
      name: 'Drops',
      iconPath: 'assets/icons/drops.gif',
    ));

    categories.add(CategoryModel(
      name: 'Foam',
      iconPath: 'assets/icons/foam.gif',
    ));

    categories.add(CategoryModel(
      name: 'Gel',
      iconPath: 'assets/icons/tube.gif',
    ));

    categories.add(CategoryModel(
      name: 'Herbal',
      iconPath: 'assets/icons/herbal.gif',
    ));

    categories.add(CategoryModel(
      name: 'Inhaler',
      iconPath: 'assets/icons/inhalator.gif',
    ));

    categories.add(CategoryModel(
      name: 'Injection',
      iconPath: 'assets/icons/syringe.gif',
    ));

    categories.add(CategoryModel(
      name: 'Lotion',
      iconPath: 'assets/icons/lotion.gif',
    ));

    categories.add(CategoryModel(
      name: 'Nasal Spray',
      iconPath: 'assets/icons/nasalspray.gif',
    ));

    categories.add(CategoryModel(
      name: 'Ointment',
      iconPath: 'assets/icons/tube.gif',
    ));

    categories.add(CategoryModel(
      name: 'Patch',
      iconPath: 'assets/icons/patch.gif',
    ));

    categories.add(CategoryModel(
      name: 'Powder',
      iconPath: 'assets/icons/powder.gif',
    ));

    categories.add(CategoryModel(
      name: 'Spray',
      iconPath: 'assets/icons/spray.gif',
    ));

    categories.add(CategoryModel(
      name: 'Suppository',
      iconPath: 'assets/icons/suppository.gif',
    ));

    return categories;
  }
}

//names: Capsule, Tablet, Liquid, Topical, Cream, Drops, Foam, Gel, Inhaler, Injection, Lotion, Ointment, Patch, Powder, Spray, Suppository.