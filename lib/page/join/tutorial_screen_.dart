import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/complete_button.dart';
import '../../components/constants/screen_size.dart';
import 'user_agreement.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  TextStyle commonTextStyle = TextStyle(
      fontFamily: 'PretendardRegular',
      fontSize: 22.sp,
      fontWeight: FontWeight.w500,
      color: Color(0xFF212529),
      height: 1.8);
  TextStyle highlightTextStyle = TextStyle(
      fontFamily: 'PretendardRegular',
      fontSize: 26.sp,
      fontWeight: FontWeight.w900,
      color: Colors.black,
      height: 1.8);

  @override
  Widget build(BuildContext context) {
    List<Widget> _tutorialTexts = [
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '내 취향을 담은 기록들\n',
              style: commonTextStyle,
            ),
            TextSpan(
              text: '한곳에',
              style: highlightTextStyle,
            ),
            TextSpan(
              text: ' 정리할 수는 없을까?',
              style: commonTextStyle,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: commonTextStyle,
          children: [
            WidgetSpan(
              child: Image.asset(
                'assets/images/image_logo_text.png',
                height: 24.sp,
              ),
            ),
            TextSpan(
              text: ' 에서\n한눈에 관리하자!',
            ),
          ],
        ),
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '기록하고 싶은\n아이템, ',
              style: commonTextStyle,
            ),
            TextSpan(
              text: '셀렉션',
              style: highlightTextStyle,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '셀렉션이 모여 \n완성되는 그룹, ',
              style: commonTextStyle,
            ),
            TextSpan(
              text: '컬렉션',
              style: highlightTextStyle,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '셀렉션을 직접 ',
              style: commonTextStyle,
            ),
            TextSpan(
              text: '만들어',
              style: highlightTextStyle,
            ),
            TextSpan(
              text: '\n 컬렉션에 추가하거나',
              style: commonTextStyle,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '마음에 드는 셀렉션은\n',
              style: commonTextStyle,
            ),
            TextSpan(
              text: '선택',
              style: highlightTextStyle,
            ),
            TextSpan(
              text: '하고',
              style: commonTextStyle,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '원하는 컬렉션에\n',
              style: commonTextStyle,
            ),
            TextSpan(
              text: '저장',
              style: highlightTextStyle,
            ),
            TextSpan(
              text: '하여',
              style: commonTextStyle,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: commonTextStyle,
          children: [
            TextSpan(
              text: '나만의 컬렉션을 만들어서\n',
              style: commonTextStyle,
            ),
            TextSpan(
              text: '한곳에',
              style: highlightTextStyle,
            ),
            TextSpan(
              text: ' 기록하자!',
              style: commonTextStyle,
            ),
          ],
        ),
      ),
    ];
    Future<void> loading() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserAgreement()));
      } finally {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 40.0.h + ViewPaddingTopSize(context)),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                physics: BouncingScrollPhysics(),
                itemCount: _tutorialTexts.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0.h),
                        child: _tutorialTexts[index],
                      ),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          child: Image.asset(
                            'assets/images/image_tutorial_${index + 1}.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _tutorialTexts.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                  width: _currentPage == index ? 12.0.w : 8.0.w,
                  height: 8.0.w,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(bottom: 40.0.h, left: 16.0.w, right: 16.0.w),
            child: CompleteButton(
              firstFieldState: true,
              secondFieldState: _currentPage == _tutorialTexts.length - 1,
              text: '회원가입',
              onTap: () async {
                await loading();
              },
            ),
          ),
        ],
      ),
    );
  }
}
