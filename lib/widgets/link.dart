import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/link.dart';
import '../styles/color.dart';

class LinkContainer extends StatelessWidget {
  const LinkContainer({super.key, required this.link});

  final Link link;

  _launchURL(url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(color: AppColors.link.text);

    return Card(
      color: AppColors.link.background,
      child: ListTile(
        title: Text(
          link.name,
          style: textStyle,
        ),
        onTap: () {
          _launchURL(Uri.encodeFull(link.url));
        }),
    );
  }
}
