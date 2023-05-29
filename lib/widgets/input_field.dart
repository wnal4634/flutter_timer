import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomo_app/screens/theme.dart';

class MyInputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({
    super.key,
    required this.hint,
    this.controller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 0.8,
              left: 270,
              right: 18,
            ),
            padding: const EdgeInsets.only(
              left: 14,
            ),
            height: 52,
            decoration: BoxDecoration(
              // color:
              //     Get.isDarkMode ? Colors.black.withOpacity(0.0) : Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.3),
              //     blurRadius: 10.0,
              //     spreadRadius: 1.0,
              //     blurStyle: BlurStyle.normal,
              //     offset: const Offset(0, 2),
              //   )
              // ],
            ),
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      autofocus: false,
                      cursorColor:
                          Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                      controller: controller,
                      style: subTitleStyle,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.background,
                            width: 0,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.background,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget == null
                      ? Container()
                      : Container(
                          child: widget,
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
