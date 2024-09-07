import 'package:collect_er/data/model/selecting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selection_model.dart';
import '../../data/provider/selection_provider.dart';
import '../card/selection.dart';

class SelectionWidget extends StatefulWidget {
  final int collectionId;
  const SelectionWidget({
    super.key,
    required this.collectionId,
  });

  @override
  State<SelectionWidget> createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SelectionProvider>();
      provider.getCollectionId = widget.collectionId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionProvider>(builder: (context, provider, child) {
      final List<SelectionModel> _selections = provider.selections ?? [];

      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 22.0.h),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24.0.h,
            crossAxisSpacing: 12.0.w,
            childAspectRatio: 0.7,
          ),
          itemCount: _selections.length,
          itemBuilder: (context, index) {
            final SelectionModel _selection = _selections[index];
            return Selection(
              properties: PropertiesData.fromJson(
                {
                  "collection_id": _selection.collectionId,
                  "selection_id": _selection.selectionId,
                },
              ),
              title: _selection.selectionName,
              imageFilePath: _selection.imageFilePath,
              ownerName: _selection.ownerName,
            );
          },
        );
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
