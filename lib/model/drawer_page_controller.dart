import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawerPageController extends Model {
  final PageController pageController = PageController();

  static DrawerPageController of(BuildContext context) => ScopedModel.of<DrawerPageController>(context);
}