//textfield
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uber/core/extension.dart';

class SearchField extends StatefulWidget {
  final String hint, asset;
  final TextEditingController textEditingController;
  const SearchField({
    super.key,
    required this.hint,
    required this.textEditingController,
    required this.asset,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.done,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: SvgPicture.asset(
            widget.asset,
            fit: BoxFit.none,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: context.borderColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        hintText: widget.hint,
        hintStyle: context.textStyle.copyWith(
          fontSize: 18,
          color: context.greyColor,
        ),
        filled: true,
        fillColor: context.insideGrey,
      ),
      onEditingComplete: () {
        if (FocusScope.of(context).canRequestFocus) {
          FocusScope.of(context).nextFocus();
        }
      },
    );
  }
}
