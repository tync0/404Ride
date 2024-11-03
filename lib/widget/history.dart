import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uber/core/extension.dart';

class HistoryWidget extends StatelessWidget {
  final String title, subtitle;
  const HistoryWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/clock.svg'),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyle.copyWith(
                  fontSize: 17,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: context.textStyle.copyWith(
                  color: context.greyColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
