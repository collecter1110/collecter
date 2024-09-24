import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLine;
  final TextStyle textStyle;

  const ExpandableText({
    super.key,
    required this.text,
    required this.maxLine,
    required this.textStyle,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: widget.textStyle,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLine,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
        );

        final bool isTextOverflowing = textPainter.didExceedMaxLines;

        String displayedText = widget.text;

        // 마지막 줄에 "더보기"를 위한 공간 확보하기
        if (!isExpanded && isTextOverflowing) {
          final endPosition = textPainter.getPositionForOffset(
            Offset(textPainter.width - 60.0.w, textPainter.height),
          );
          final endOffset = endPosition.offset;
          displayedText = widget.text.substring(0, endOffset);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: isExpanded ? widget.text : displayedText,
                    style: widget.textStyle,
                  ),
                  if (!isExpanded && isTextOverflowing)
                    const TextSpan(
                      text: '... ',
                    ),
                  if (isTextOverflowing)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? ' 간단히 보기' : ' 더보기',
                          style: TextStyle(
                            color: const Color(0xFFced4da),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              maxLines: isExpanded ? null : widget.maxLine,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ],
        );
      },
    );
  }
}
