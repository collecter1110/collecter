import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTextFormField extends StatefulWidget {
  final TextInputType keyboardType;
  final String hintText;
  final TextInputFormatter? formatter;
  final bool isMultipleLine;
  final FormFieldSetter<String> onSaved;

  const AddTextFormField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    this.formatter,
    required this.isMultipleLine,
    required this.onSaved,
  });

  @override
  State<AddTextFormField> createState() => _AddTextFormFieldState();
}

class _AddTextFormFieldState extends State<AddTextFormField> {
  TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late VoidCallback _listener;

  final TextStyle _hintTextStyle = TextStyle(
    color: Color(0xffADB5BD),
    fontSize: 14.0.sp,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  final TextStyle _fieldTextStyle = TextStyle(
    decorationThickness: 0,
    color: Color(0xFF212529),
    fontSize: 15.sp,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  @override
  void initState() {
    super.initState();
    _listener = () {
      if (!_focusNode.hasFocus) {
        widget.onSaved(_controller.text);
      }
    };
    _focusNode.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.clear();
    _focusNode.unfocus();
    _focusNode.removeListener(_listener);
    _controller.dispose();
    _focusNode.dispose();
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: _controller,
        focusNode: _focusNode,
        textAlignVertical: widget.isMultipleLine
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        textInputAction: widget.isMultipleLine ? TextInputAction.newline : null,
        maxLines: widget.isMultipleLine ? null : 1,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 12.0.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Color(0xffF5F6F7),
          hintText: widget.hintText,
          hintStyle: _hintTextStyle,
        ),
        inputFormatters: widget.formatter != null ? [widget.formatter!] : [],
        style: _fieldTextStyle,
        onSaved: widget.onSaved,
        expands: widget.isMultipleLine,
      ),
    );
  }
}
