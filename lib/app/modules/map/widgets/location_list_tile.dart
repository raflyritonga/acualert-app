import 'package:flutter/material.dart';
import '../../../config/config.dart';

class LocationListTite extends StatelessWidget {
  final String location;
  final VoidCallback press;

  const LocationListTite({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: Colors.black54,
        )
      ],
    );
  }
}
