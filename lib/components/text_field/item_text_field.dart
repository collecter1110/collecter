import 'package:collect_er/data/provider/item_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  List<int> _itemIndexOrder = [];

  late List<TextEditingController> _titleControllers = [];

  @override
  void initState() {
    super.initState();
    _itemIndexOrder = List<int>.generate(widget.itemNum, (int index) => index);

    _titleControllers = List.generate(
      widget.itemNum,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.itemNum; i++) {
      _titleControllers[i];
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(ItemTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemNum != oldWidget.itemNum) {
      setState(() {
        _itemIndexOrder.add(widget.itemNum - 1);

        _titleControllers.add(TextEditingController());

        saveItemsOrder();
      });
    }
  }

  void saveItemsOrder() {
    print(_itemIndexOrder);
    context.read<ItemProvider>().saveItemOrder = _itemIndexOrder;
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
      itemCount: _itemIndexOrder.length,
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
                    Flexible(
                      child: ItemWidget(
                        key: ValueKey(_itemIndexOrder[index]),
                        titleController: _titleControllers[index],
                      ),
                    ),
                  ],
                ),
              )
            : ItemWidget(
                key: ValueKey(_itemIndexOrder[index]),
                titleController: _titleControllers[index],
              );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final int item = _itemIndexOrder.removeAt(oldIndex);
        _itemIndexOrder.insert(newIndex, item);

        final titleController = _titleControllers.removeAt(oldIndex);

        _titleControllers.insert(newIndex, titleController);

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
  final TextEditingController titleController;

  const ItemWidget({
    Key? key,
    required this.titleController,
  }) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late FocusNode _titleFocusNode;

  late int itemKey;

  @override
  void initState() {
    super.initState();

    _titleFocusNode = FocusNode();

    String keyString = widget.key.toString();
    itemKey = int.tryParse(keyString.replaceAll(RegExp(r'\D'), '')) ?? 0;

    print(itemKey);
    _titleFocusNode.addListener(_onDescriptionFocusChanged);
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();

    super.dispose();
  }

  void _onDescriptionFocusChanged() {
    if (!_titleFocusNode.hasFocus) {
      context.read<ItemProvider>().saveItemTitle = {
        itemKey: widget.titleController.text
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: TextFormField(
                  focusNode: _titleFocusNode,
                  keyboardType: TextInputType.multiline,
                  controller: widget.titleController,
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
    );
  }
}
