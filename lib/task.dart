import 'package:flutter/material.dart';
import 'package:sqlite_flutter_crud/constants/colors.dart';

class Task {
  final IconData? iconData;
  final String? title;
  final Color? bgColor;
  final Color? iconColor;
  final Color? btnColor;
  final  num? left;
  final num? done;
  final bool isLast;
  Task(
      {this.iconData,
      this.title,
      this.bgColor,
      this.iconColor,
      this.btnColor,
      this.left,
      this.done,
      this.isLast = false});
      static List<Task> generateTasks() {
        return [
          Task(iconData: Icons.person_rounded,
          title: 'Personal',
          bgColor: kYellowLight,
          iconColor: kYellowDark,
          btnColor: kYellow,
          left: 3,
          done: 1,
          ),
           Task(iconData: Icons.cases_rounded,
          title: 'Work',
          bgColor: kRedLight,
          iconColor: kRedDark,
          btnColor: kRed,
          left: 0,
          done: 0,
          ),
           Task(iconData: Icons.favorite_rounded,
          title: 'Health',
          bgColor: kBlueLight,
          iconColor: kBlueDark,
          btnColor: kBlue,
          left: 0,
          done: 0,
          ),
          Task(isLast: true)
        ];
      }
}
