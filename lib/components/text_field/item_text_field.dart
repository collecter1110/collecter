import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  late List<TextEditingController> _titleControllers = [];
  late List<TextEditingController> _descriptionControllers = [];

  @override
  void initState() {
    super.initState();
    _items = List<int>.generate(widget.itemNum, (int index) => index);
    _titleControllers = List.generate(
      widget.itemNum,
      (index) => TextEditingController(),
    );
    _descriptionControllers = List.generate(
      widget.itemNum,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.itemNum; i++) {
      _titleControllers[i];
      _descriptionControllers[i];
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
        _titleControllers.add(TextEditingController());
        _descriptionControllers.add(TextEditingController());

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
                      titleController: _titleControllers[index],
                      descriptionController: _descriptionControllers[index],
                    ),
                  ],
                ),
              )
            : ItemWidget(
                key: ValueKey(_items[index]),
                titleController: _titleControllers[index],
                descriptionController: _descriptionControllers[index],
              );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final int item = _items.removeAt(oldIndex);
        _items.insert(newIndex, item);
        final titleController = _titleControllers.removeAt(oldIndex);
        _titleControllers.insert(newIndex, titleController);
        final descriptionController =
            _descriptionControllers.removeAt(oldIndex);
        _descriptionControllers.insert(newIndex, descriptionController);

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
  final TextEditingController descriptionController;

  const ItemWidget({
    Key? key,
    required this.titleController,
    required this.descriptionController,
  }) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  late FocusNode _titleFocusNode;
  late FocusNode _descriptionFocusNode;

  late int itemKey;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();

    String keyString = widget.key.toString();
    itemKey = int.tryParse(keyString.replaceAll(RegExp(r'\D'), '')) ?? 0;
    _titleFocusNode.addListener(_onTitleFocusChanged);
    _descriptionFocusNode.addListener(_onDescriptionFocusChanged);
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  void _onTitleFocusChanged() {
    // if (!_titleFocusNode.hasFocus) {
    //   Provider.of<CreateListProvider>(context, listen: false).itemTitles = {
    //     itemKey: widget.titleController.text
    //   };
    // }
  }

  void _onDescriptionFocusChanged() {
    // if (!_descriptionFocusNode.hasFocus) {
    //   Provider.of<CreateListProvider>(context, listen: false).itemDescriptions =
    //       {itemKey: widget.descriptionController.text};
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xffF8F9FA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                focusNode: _titleFocusNode,
                controller: widget.titleController,
                expands: false,
                style: TextStyle(
                  decorationThickness: 0,
                  color: Color(0xff343A40),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '합정 최강금돈까스+${widget.key}',
                  hintStyle: TextStyle(
                    color: Color(0xffADB5BD),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                  suffixIcon: InkWell(
                    child: Image.asset(
                      'assets/icons/icon_delete_fill.png',
                      height: 20.0.h,
                      color: Color(0xFF343a40),
                    ),
                    onTap: () {},
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minHeight: 15.0.h,
                    minWidth: 15.0.w,
                  ),
                ),
              ),
              TextFormField(
                focusNode: _descriptionFocusNode,
                controller: widget.descriptionController,
                style: TextStyle(
                  decorationThickness: 0,
                  color: Color(0xff495057),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '아침에 가서 웨이팅 해야함',
                  hintStyle: TextStyle(
                    color: Color(0xffADB5BD),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
