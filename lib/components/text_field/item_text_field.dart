import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../button/add_link_button.dart';

class ItemTextField extends StatefulWidget {
  final int itemNum;
  final bool orderState;

  const ItemTextField({
    Key? key,
    required this.itemNum,
    required this.orderState,
  }) : super(key: key);

  @override
  _ItemTextFieldState createState() => _ItemTextFieldState();
}

class _ItemTextFieldState extends State<ItemTextField> {
  List<int> _items = [];

  late List<TextEditingController> _descriptionControllers = [];
  late List<TextEditingController> _linkControllers = [];

  @override
  void initState() {
    super.initState();
    _items = List<int>.generate(widget.itemNum, (int index) => index);

    _descriptionControllers = List.generate(
      widget.itemNum,
      (index) => TextEditingController(),
    );
    _linkControllers = List.generate(
      widget.itemNum,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.itemNum; i++) {
      _descriptionControllers[i];
      _linkControllers[i];
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(ItemTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemNum != oldWidget.itemNum) {
      setState(() {
        print('this');
        _items.add(widget.itemNum - 1);

        _descriptionControllers.add(TextEditingController());
        _linkControllers.add(TextEditingController());

        saveItemsOrder();
      });
    }
  }

  void saveItemsOrder() {
    //Provider.of<CreateListProvider>(context, listen: false).itemsOrder = _items;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: animation.drive(
              Tween<double>(begin: 1, end: 1.1).chain(
                CurveTween(curve: Curves.linear),
              ),
            ),
            child: child,
          ),
        );
      },
      buildDefaultDragHandles: widget.orderState,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return widget.orderState
            ? CustomReorderableDelayedDragStartListener(
                key: Key('$index'),
                delay: const Duration(
                  milliseconds: 150,
                ),
                index: index,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.0.w),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Color(0xFF343a40),
                          fontSize: 18.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ItemWidget(
                      key: ValueKey(_items[index]),
                      descriptionController: _descriptionControllers[index],
                      linkController: _linkControllers[index],
                    ),
                  ],
                ),
              )
            : ItemWidget(
                key: ValueKey(_items[index]),
                descriptionController: _descriptionControllers[index],
                linkController: _linkControllers[index],
              );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final int item = _items.removeAt(oldIndex);
        _items.insert(newIndex, item);

        final descriptionController =
            _descriptionControllers.removeAt(oldIndex);

        _descriptionControllers.insert(newIndex, descriptionController);
        final linkController = _linkControllers.removeAt(oldIndex);
        _linkControllers.insert(newIndex, linkController);
        saveItemsOrder();
      },
    );
  }
}

class CustomReorderableDelayedDragStartListener
    extends ReorderableDragStartListener {
  final Duration delay;

  const CustomReorderableDelayedDragStartListener({
    this.delay = kLongPressTimeout,
    Key? key,
    required Widget child,
    required int index,
    bool enabled = true,
  }) : super(
          key: key,
          child: child,
          index: index,
          enabled: enabled,
        );

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(delay: delay, debugOwner: this);
  }
}

class ItemWidget extends StatefulWidget {
  final TextEditingController descriptionController;
  final TextEditingController linkController;

  const ItemWidget({
    Key? key,
    required this.descriptionController,
    required this.linkController,
  }) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late FocusNode _descriptionFocusNode;
  late FocusNode _linkFocusNode;

  late int itemKey;
  bool _showLinkField = false;

  @override
  void initState() {
    super.initState();

    _descriptionFocusNode = FocusNode();
    _linkFocusNode = FocusNode();

    String keyString = widget.key.toString();
    itemKey = int.tryParse(keyString.replaceAll(RegExp(r'\D'), '')) ?? 0;

    _descriptionFocusNode.addListener(_onDescriptionFocusChanged);
    _linkFocusNode.addListener(_onLinkFocusChanged);
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _linkFocusNode.dispose();
    super.dispose();
  }

  void _onDescriptionFocusChanged() {
    // if (!_descriptionFocusNode.hasFocus) {
    //   Provider.of<CreateListProvider>(context, listen: false).itemDescriptions =
    //       {itemKey: widget.descriptionController.text};
    // }
  }
  void _onLinkFocusChanged() {
    // if (!_descriptionFocusNode.hasFocus) {
    //   Provider.of<CreateListProvider>(context, listen: false).itemDescriptions =
    //       {itemKey: widget.descriptionController.text};
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0.h),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF5F6F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        controller: widget.descriptionController,
                        textAlignVertical: TextAlignVertical.top,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        style: TextStyle(
                          decorationThickness: 0,
                          color: Color(0xff495057),
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        decoration: InputDecoration(
                          hintText: '내용을 입력헤주세요.',
                          hintStyle: TextStyle(
                            color: Color(0xffADB5BD),
                            fontSize: 14.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 4.0.h,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Row(
                        children: [
                          AddLinkButton(
                            onTap: () {
                              setState(() {
                                _showLinkField = !_showLinkField;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10.0.w,
                          ),
                          _showLinkField
                              ? Flexible(
                                  child: TextFormField(
                                    focusNode: _linkFocusNode,
                                    controller: widget.linkController,
                                    textAlignVertical: TextAlignVertical.center,
                                    expands: false,
                                    style: TextStyle(
                                      decorationThickness: 0,
                                      color: Color(0xff495057),
                                      fontSize: 12.sp,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '링크 추가',
                                      hintStyle: TextStyle(
                                        color: Color(0xffADB5BD),
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 0.0),
                                      isDense: true,
                                      border: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFFdee2e6),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF495057),
                                          width: 0.1,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          size: 12.0.h,
                                          color: Color(0xFF868e96),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _showLinkField = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Image.asset(
                    'assets/icons/icon_delete_fill.png',
                    width: 20.0.h,
                    color: Color(0xFF343a40),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
