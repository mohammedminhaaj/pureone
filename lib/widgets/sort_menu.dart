import 'package:flutter/material.dart';
import 'package:pureone/data/menu.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
            itemCount: sortMenuList.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
              );
            },
            itemBuilder: (_, index) {
              return OutlinedButton(
                  onPressed: () {}, child: Text(sortMenuList[index]));
            }),
      ),
    );
  }
}
