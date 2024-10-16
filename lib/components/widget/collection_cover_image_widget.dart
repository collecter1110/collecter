import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selection_model.dart';
import '../../data/provider/selection_provider.dart';
import '../card/cover_image.dart';

class CollectionCoverImageWidget extends StatefulWidget {
  final int collectionId;
  final ValueSetter<bool> isSelected;

  const CollectionCoverImageWidget({
    super.key,
    required this.collectionId,
    required this.isSelected,
  });

  @override
  State<CollectionCoverImageWidget> createState() =>
      _CollectionCoverImageWidgetState();
}

class _CollectionCoverImageWidgetState
    extends State<CollectionCoverImageWidget> {
  int? selectedCoverIndex;
  String? seletedCoverFilePath;
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    final provider = context.read<SelectionProvider>();
    provider.getCollectionId = widget.collectionId;
    await provider.getSelectionData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionProvider>(builder: (context, provider, child) {
      final List<SelectionModel> _selections = provider.selections
              ?.where((selection) => selection.thumbFilePath != null)
              .toList() ??
          [];

      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return Align(
          alignment: Alignment.centerLeft,
          child: ListView.separated(
            primary: false,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 22.0.h),
            shrinkWrap: true,
            itemCount: _selections.length,
            itemBuilder: (context, index) {
              final SelectionModel _selection = _selections[index];
              return CoverImage(
                  coverIndex: index,
                  thumbFilePath: _selection.thumbFilePath!,
                  selectedCoverIndex: selectedCoverIndex,
                  ownerId: _selection.ownerId,
                  onTap: (value) {
                    setState(() {
                      selectedCoverIndex = value;
                      seletedCoverFilePath =
                          _selections[selectedCoverIndex!].thumbFilePath!;
                      provider.saveCollectionCoverImage = seletedCoverFilePath!;
                      widget.isSelected(true);
                    });
                  });
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 20.0.h,
              );
            },
          ),
        );
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
