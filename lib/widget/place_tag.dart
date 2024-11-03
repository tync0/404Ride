import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uber/core/extension.dart';

class PlaceTag extends StatelessWidget {
  final bool selected;
  final String title;
  const PlaceTag({super.key, this.selected = false, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 118),
      decoration: BoxDecoration(
        color: selected ? context.mainColor : Colors.white,
        border: Border.all(
          color: selected ? Colors.transparent : context.borderColor,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/save.svg',
            colorFilter: ColorFilter.mode(
              selected ? Colors.white : context.greyColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: context.textStyle.copyWith(
              color: selected ? Colors.white : context.greyColor,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
