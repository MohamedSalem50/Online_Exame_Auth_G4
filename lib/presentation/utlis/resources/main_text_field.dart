  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/presentation/utlis/resources/color_manager.dart';
import 'package:online_exam/presentation/utlis/resources/font_manager.dart';
import 'package:online_exam/presentation/utlis/resources/styles_manager.dart';
import 'package:online_exam/presentation/utlis/resources/values_manager.dart';


  class CustomTextFormField extends StatefulWidget {
    const CustomTextFormField({
      super.key,
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.label,
      this.hint,
      this.isObscured = false,
      this.iconData,
      this.textInputType = TextInputType.text,
      this.backgroundColor,
      this.hintTextStyle,
      this.labelTextStyle,
      this.cursorColor,
      this.readOnly = false,
      this.validation,
      this.onTap,
      this.maxLines,
      this.prefixIcon,
      this.borderBackgroundColor,
      this.suffixIcon,
    });

    final TextEditingController? controller;
    final FocusNode? focusNode;
    final FocusNode? nextFocus;
    final bool isObscured;
    final String? label;
    final String? hint;
    final TextInputType textInputType;
    final IconData? iconData;
    final Color? backgroundColor;
    final Color? borderBackgroundColor;
    final TextStyle? hintTextStyle;
    final TextStyle? labelTextStyle;
    final Color? cursorColor;
    final bool readOnly;
    final int? maxLines;
    final Widget? prefixIcon;
    final Widget? suffixIcon;
    final String? Function(String?)? validation;
    final void Function()? onTap;

    @override
    State<CustomTextFormField> createState() => _CustomTextFormFieldState();
  }

  class _CustomTextFormFieldState extends State<CustomTextFormField> {
    late bool hidden = widget.isObscured;
    String? errorText;

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label != null
              ? Padding(
                  padding: const EdgeInsets.only(top: PaddingManager.p2),
                  child: Text(
                    widget.label!,
                    style: widget.labelTextStyle ??
                        getMediumStyle(color: ColorManager.grey1)
                            .copyWith(fontSize: FontSize.s12.sp),
                  ),
                )
              : const SizedBox(),
          Container(
            margin: const EdgeInsets.only(top: MarginManager.m5),
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  ColorManager.darkGrey.withOpacity(.15),
              borderRadius: BorderRadius.circular(SizeManager.s4),
              border: Border.all(
                  color:
                      widget.borderBackgroundColor ?? ColorManager.lightPrimary),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: TextFormField(
              maxLines: widget.maxLines ?? 1,
              controller: widget.controller,
              focusNode: widget.focusNode,
              readOnly: widget.readOnly,
              style: getMediumStyle(color: ColorManager.black)
                  .copyWith(fontSize: FontSize.s18.sp),
              obscureText: hidden,
              keyboardType: widget.textInputType,
              obscuringCharacter: '*',
              cursorColor: widget.cursorColor ?? ColorManager.black,
              onTap: widget.onTap,
              onEditingComplete: () {
                widget.focusNode?.unfocus();
                if (widget.nextFocus != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocus);
                }
              },
              textInputAction: widget.nextFocus == null
                  ? TextInputAction.done
                  : TextInputAction.next,
              validator: (value) {
                if (widget.validation == null) {
                  setState(() {
                    errorText = null;
                  });
                } else {
                  setState(() {
                    errorText = widget.validation!(value);
                  });
                }
                return errorText;
              },
              decoration: InputDecoration(
    contentPadding: const EdgeInsets.all(PaddingManager.p8),
    hintText: widget.hint,
    prefixIcon: widget.prefixIcon,
    suffixIcon: widget.isObscured
        ? IconButton(
            onPressed: () {
              setState(() {
                hidden = !hidden;
              });
            },
            iconSize: SizeManager.s24,
            splashRadius: SizeManager.s1,
            color: ColorManager.grey,
            icon: Icon(
              hidden ? Icons.visibility_off : Icons.visibility, // التبديل بين الأيقونتين
              color: ColorManager.grey,
            ),
          )
        : widget.suffixIcon,
        hintStyle: widget.hintTextStyle ??
        getRegularStyle(color: ColorManager.black).copyWith(fontSize: 18.sp),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorStyle: TextStyle(
       fontSize: SizeManager.s0,
       color: ColorManager.black,
    ),
  ),

            ),
          ),
          errorText == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(
                    top: PaddingManager.p8,
                    left: PaddingManager.p8,
                  ),
                  child: Text(
                    errorText!,
                    style: getMediumStyle(color: ColorManager.black)
                        .copyWith(fontSize: 18.sp),
                  ),
                ),
        ],
      );
    }
  }
