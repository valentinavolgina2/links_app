import 'package:flutter/material.dart';
import 'package:links_app/widgets/link/popup_menu.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/gradient.dart';
import '../../model/link.dart';
import '../../styles/color.dart';
import '../../styles/size.dart';
import '../message.dart';

class LinkContainer extends StatelessWidget {
  const LinkContainer(
      {super.key,
      required this.link,
      required this.listTags,
      required this.listCategories});

  final Link link;
  final List<String> listTags;
  final List<String> listCategories;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(color: AppColors.darkText);
    final double randomStart = randomGradientStart();
    final Map<String, Alignment> randomGardient = randomGradient();

    launchURL(url) async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Cannot launch url';
      }
    }

    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: randomGardient['begin']!,
            end: randomGardient['end']!,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
            stops: [randomStart, randomStart + 0.2],
          ),
        ),
        child: ListTile(
          leading: link.completed ? const Icon(Icons.done) : null,
          title: Text(
            link.name,
            style: textStyle,
          ),
          subtitle: link.tags.isEmpty
              ? null
              : Padding(
                  padding: EdgeInsets.only(top: AppSizes.small),
                  child: Text(Link.hashStrFromTagsList(link.tags)),
                ),
          trailing: LinkPopupMenu(
              link: link, listTags: listTags, listCategories: listCategories),
          onTap: () async {
            final url = Uri.encodeFull(link.url);

            await launchURL(url)
                .then((value) => null)
                .onError((error, stackTrace) {
              SystemMessage.showError(
                  context: context, message: 'Could not launch $url');
              debugPrint('Could not launch $url');
            });
          },
        ),
      ),
    );
  }
}
