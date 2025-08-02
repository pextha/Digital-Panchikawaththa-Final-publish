import 'package:flutter/material.dart';
import '../pages/filter_popup.dart';

void showFilterPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => FilterPopup(),
  );
}
