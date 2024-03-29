import 'package:Mingledxb/constants/constants.dart';
import 'package:Mingledxb/widgets/default_card_border.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCard extends StatelessWidget {
  final double? iconSize;

  const LoadingCard({Key? key, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      clipBehavior: Clip.antiAlias,
      shape: defaultCardBorder(),
      child: Shimmer.fromColors(
          child: Icon(Icons.favorite_border, size: iconSize ?? 150),
          baseColor: Colors.grey.withAlpha(70),
          highlightColor: APP_ACCENT_COLOR),
    );
  }
}
