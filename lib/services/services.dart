import 'package:ai_scientific_middleware/constants/constants.dart';
import 'package:ai_scientific_middleware/widgets/drop_down.dart';
import 'package:ai_scientific_middleware/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            )
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Chosen Model:",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ModelsDropDownWidget(),
                )
              ],
            ),
          );
        }
    );
  }
}