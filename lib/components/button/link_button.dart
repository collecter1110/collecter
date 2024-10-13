import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkButton extends StatelessWidget {
  final String linkUrl;
  const LinkButton({
    super.key,
    required this.linkUrl,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> _launchInBrowser(String link) async {
      Uri url = Uri.parse(linkUrl);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () async {
          await _launchInBrowser(linkUrl);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0.r),
          ),
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.0.h),
          backgroundColor: Colors.white,
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(
            color: Color(0xFFadb5bd),
            width: 1.0.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/icon_link.png',
              color: Color(0xFF868e96),
              height: 10.0.h,
            ),
            SizedBox(
              width: 6.0.w,
            ),
            Text(
              'Link',
              style: TextStyle(
                fontFamily: 'PretendardRegular',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF868e96),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
