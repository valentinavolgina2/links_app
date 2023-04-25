import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles/color.dart';

class Link {
  String url;
  String name;

  Link({required this.name, required this.url});

  _launchURL(url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildLink(BuildContext context) {
    final TextStyle textStyle = TextStyle(color: AppColors.link.text);

    return Card(
      color: AppColors.link.background,
      child: ListTile(
        title: Text(
          name,
          style: textStyle,
        ),
        onTap: () {
          _launchURL(Uri.encodeFull(url));
        }),
    );
  }
}
