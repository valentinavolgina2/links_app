import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/link.dart';
import '../../model/linkslist.dart';
import '../../styles/color.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, required this.list});

  final LinksList list;

  int _crossAxisCountByWidth(width) {
    const itemMinWidth = 190;

    return (width < itemMinWidth) ? 1 : width ~/ itemMinWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(list.name),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(children: <Widget>[
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: true,
                    crossAxisCount:
                        _crossAxisCountByWidth(constraints.maxWidth),
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: list.links
                        .map((link) => SelectGrid(
                              link: link,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ]),
              ),
            ),
          );
        }));
  }
}

class SelectGrid extends StatelessWidget {
  const SelectGrid({super.key, required this.link});
  final Link link;

  _launchURL(url) async{
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _launchURL(Uri.encodeFull(link.url));
        },
        child: Card(
            color: AppColors.link.background,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // BoardIconView(board: boardTemplates[grid]!),
                    // const SizedBox(height: 20),
                    Text(
                      link.url,
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
