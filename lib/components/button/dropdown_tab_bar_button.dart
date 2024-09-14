import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownTabBarButton extends StatefulWidget {
  final ValueChanged<String>? setCategory;

  DropdownTabBarButton({
    required this.setCategory,
  });

  @override
  _DropdownTabBarButtonState createState() => _DropdownTabBarButtonState();
}

class _DropdownTabBarButtonState extends State<DropdownTabBarButton> {
  String _selectedCategoryName = 'Collection';
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay?.insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 120.0.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5.0.h),
          child: Material(
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: const Color(0xFFdee2e6),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    selectedColor: Colors.black,
                    title: Text(
                      'Collection',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: _selectedCategoryName == 'Collection'
                            ? Colors.black
                            : Color(0xFFced4da),
                        height: 1.43,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCategoryName = 'Collection';
                      });
                      _removeDropdown();
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Selection',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: _selectedCategoryName == 'Selection'
                            ? Colors.black
                            : Color(0xFFced4da),
                        height: 1.43,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCategoryName = 'Selection';
                      });
                      _removeDropdown();
                    },
                  ),
                  ListTile(
                    title: Text(
                      'User',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: _selectedCategoryName == 'User'
                            ? Colors.black
                            : Color(0xFFced4da),
                        height: 1.43,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCategoryName = 'User';
                      });
                      _removeDropdown();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextButton(
        onPressed: _toggleDropdown,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.0.w,
            vertical: 8.0.h,
          ),
          backgroundColor: Colors.black,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
        ),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _selectedCategoryName,
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  height: 1.43,
                ),
              ),
            ),
            SizedBox(
              width: 6.0.w,
            ),
            Image.asset(
              'assets/icons/icon_arrow_down.png',
              color: Colors.white,
              height: 14.0.h,
            ),
          ],
        ),
      ),
    );
  }
}
